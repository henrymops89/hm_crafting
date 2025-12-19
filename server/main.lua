-- ====================================
-- HENRY CRAFTING - SERVER MAIN
-- ====================================

local craftingInProgress = {}

-- ====================================
-- RESOURCE START
-- ====================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^2[Henry Crafting] Resource started successfully!^0')
    print('^3[Henry Crafting] Framework: ' .. (Framework.Name or 'Unknown') .. '^0')
    print('^3[Henry Crafting] Inventory: ' .. (Inventory.Name or 'Unknown') .. '^0')
    
    -- Initialize Database
    MySQL.ready(function()
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS henry_crafting_skills (
                identifier VARCHAR(50) PRIMARY KEY,
                level INT DEFAULT 0,
                xp INT DEFAULT 0,
                crafted_items INT DEFAULT 0
            )
        ]])
        
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS henry_crafting_blueprints (
                id INT AUTO_INCREMENT PRIMARY KEY,
                identifier VARCHAR(50),
                recipe_id VARCHAR(100),
                acquired_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ]])
        
        print('^2[Henry Crafting] Database initialized!^0')
    end)
end)

-- ====================================
-- HELPER FUNCTIONS
-- ====================================

local function debugPrint(message)
    if Config.Debug then
        print('^5[DEBUG]^0 ' .. message)
    end
end

-- ====================================
-- SKILL SYSTEM
-- ====================================

local function getPlayerSkills(identifier)
    local result = MySQL.single.await('SELECT * FROM henry_crafting_skills WHERE identifier = ?', {identifier})
    
    if result then
        return {
            level = result.level,
            xp = result.xp,
            craftedItems = result.crafted_items
        }
    else
        -- Create new entry
        MySQL.insert('INSERT INTO henry_crafting_skills (identifier) VALUES (?)', {identifier})
        return {
            level = 0,
            xp = 0,
            craftedItems = 0
        }
    end
end

local function addXP(identifier, xp)
    local skills = getPlayerSkills(identifier)
    local newXP = skills.xp + xp
    local newLevel = skills.level
    
    -- Level up check
    local xpForNextLevel = Config.Skills.XPPerLevel * (newLevel + 1)
    
    while newXP >= xpForNextLevel and newLevel < Config.Skills.MaxLevel do
        newLevel = newLevel + 1
        newXP = newXP - xpForNextLevel
        xpForNextLevel = Config.Skills.XPPerLevel * (newLevel + 1)
    end
    
    MySQL.update('UPDATE henry_crafting_skills SET level = ?, xp = ? WHERE identifier = ?', {
        newLevel, newXP, identifier
    })
    
    return {
        leveledUp = newLevel > skills.level,
        newLevel = newLevel,
        newXP = newXP
    }
end

local function incrementCraftedItems(identifier)
    MySQL.update('UPDATE henry_crafting_skills SET crafted_items = crafted_items + 1 WHERE identifier = ?', {identifier})
end

-- ====================================
-- BLUEPRINT SYSTEM
-- ====================================

local function hasBlueprint(identifier, recipeId)
    if not Config.UseBlueprints then return true end
    
    local result = MySQL.single.await(
        'SELECT * FROM henry_crafting_blueprints WHERE identifier = ? AND recipe_id = ?',
        {identifier, recipeId}
    )
    
    return result ~= nil
end

local function giveBlueprint(identifier, recipeId)
    MySQL.insert('INSERT INTO henry_crafting_blueprints (identifier, recipe_id) VALUES (?, ?)', {
        identifier, recipeId
    })
end

local function getPlayerBlueprints(identifier)
    local results = MySQL.query.await('SELECT recipe_id FROM henry_crafting_blueprints WHERE identifier = ?', {identifier})
    
    local blueprints = {}
    for _, row in ipairs(results) do
        table.insert(blueprints, row.recipe_id)
    end
    
    return blueprints
end

-- ====================================
-- CRAFTING SYSTEM
-- ====================================

local function canCraftRecipe(source, recipe)
    local identifier = Framework.GetIdentifier(source)
    local skills = getPlayerSkills(identifier)
    
    -- Level check
    if skills.level < recipe.requirements.level then
        return false, 'Dein Level ist zu niedrig! (Benötigt: ' .. recipe.requirements.level .. ')'
    end
    
    -- Blueprint check
    if recipe.requirements.blueprint and not hasBlueprint(identifier, recipe.id) then
        return false, 'Du besitzt nicht die benötigte Blaupause!'
    end
    
    -- Materials check
    for _, material in ipairs(recipe.materials) do
        local hasAmount = Inventory.GetItemCount(source, material.item)
        if hasAmount < material.amount then
            return false, 'Nicht genug ' .. material.label .. ' (' .. hasAmount .. '/' .. material.amount .. ')'
        end
    end
    
    return true, 'OK'
end

local function removeMaterials(source, materials)
    for _, material in ipairs(materials) do
        Inventory.RemoveItem(source, material.item, material.amount)
    end
end

local function returnMaterials(source, materials, percentage)
    for _, material in ipairs(materials) do
        local returnAmount = math.floor(material.amount * (percentage / 100))
        if returnAmount > 0 then
            Inventory.AddItem(source, material.item, returnAmount)
        end
    end
end

local function calculateSuccessChance(recipe, skills)
    local baseChance = recipe.crafting.successChance or Config.Crafting.BaseSuccessChance
    local levelBonus = skills.level * Config.Crafting.SkillBonusPerLevel
    
    local totalChance = baseChance + levelBonus
    return math.min(totalChance, 100) -- Cap at 100%
end

-- ====================================
-- CALLBACKS
-- ====================================

-- Get Player Data
lib.callback.register('henry_crafting:getPlayerData', function(source)
    local identifier = Framework.GetIdentifier(source)
    local skills = getPlayerSkills(identifier)
    local blueprints = getPlayerBlueprints(identifier)
    
    return {
        skills = skills,
        blueprints = blueprints
    }
end)

-- Get Available Recipes (for location)
lib.callback.register('henry_crafting:getRecipes', function(source, locationId)
    local location = nil
    for _, loc in ipairs(Config.Locations) do
        if loc.id == locationId then
            location = loc
            break
        end
    end
    
    if not location then
        return {}
    end
    
    local identifier = Framework.GetIdentifier(source)
    local skills = getPlayerSkills(identifier)
    local recipes = Config.GetRecipesByCategory(location.category)
    
    -- Add player-specific data to recipes
    local enrichedRecipes = {}
    for _, recipe in ipairs(recipes) do
        local recipeData = {
            id = recipe.id,
            label = recipe.label,
            item = recipe.item,
            category = recipe.category,
            rarity = recipe.rarity,
            requirements = recipe.requirements,
            materials = recipe.materials,
            result = recipe.result,
            crafting = recipe.crafting,
            
            -- Player-specific
            canCraft = false,
            hasBlueprint = hasBlueprint(identifier, recipe.id),
            meetsLevel = skills.level >= recipe.requirements.level
        }
        
        local canCraft, reason = canCraftRecipe(source, recipe)
        recipeData.canCraft = canCraft
        recipeData.reason = reason
        
        table.insert(enrichedRecipes, recipeData)
    end
    
    return enrichedRecipes
end)

-- Start Crafting
lib.callback.register('henry_crafting:startCraft', function(source, recipeId)
    -- Prevent multiple crafts
    if craftingInProgress[source] then
        return {success = false, message = 'Du craftest bereits etwas!'}
    end
    
    local recipe = Config.GetRecipeById(recipeId)
    if not recipe then
        return {success = false, message = 'Rezept nicht gefunden!'}
    end
    
    -- Check if can craft
    local canCraft, reason = canCraftRecipe(source, recipe)
    if not canCraft then
        return {success = false, message = reason}
    end
    
    -- Mark as crafting
    craftingInProgress[source] = true
    
    -- Remove materials
    removeMaterials(source, recipe.materials)
    
    debugPrint('Player ' .. source .. ' started crafting: ' .. recipe.label)
    
    return {
        success = true,
        recipe = recipe,
        duration = recipe.crafting.time
    }
end)

-- Complete Crafting
lib.callback.register('henry_crafting:completeCraft', function(source, recipeId, cancelled)
    craftingInProgress[source] = nil
    
    local recipe = Config.GetRecipeById(recipeId)
    if not recipe then
        return {success = false, message = 'Rezept nicht gefunden!'}
    end
    
    -- If cancelled, return materials
    if cancelled then
        returnMaterials(source, recipe.materials, 100)
        Framework.Notify(source, 'Crafting abgebrochen! Materialien zurückerstattet.', 'error')
        return {success = false, cancelled = true}
    end
    
    -- Calculate success
    local identifier = Framework.GetIdentifier(source)
    local skills = getPlayerSkills(identifier)
    local successChance = calculateSuccessChance(recipe, skills)
    local roll = math.random(100)
    local success = roll <= successChance
    
    debugPrint('Craft attempt: ' .. recipe.label .. ' | Chance: ' .. successChance .. '% | Roll: ' .. roll .. '% | Success: ' .. tostring(success))
    
    if success then
        -- Success!
        Inventory.AddItem(source, recipe.result.item, recipe.result.amount)
        
        local xpGained = recipe.crafting.xp
        local skillUpdate = addXP(identifier, xpGained)
        incrementCraftedItems(identifier)
        
        local message = 'Du hast ' .. recipe.result.amount .. 'x ' .. recipe.label .. ' hergestellt! (+'.. xpGained ..' XP)'
        
        if skillUpdate.leveledUp then
            message = message .. '\n🎉 Level Up! Du bist jetzt Level ' .. skillUpdate.newLevel
        end
        
        Framework.Notify(source, message, 'success', 7000)
        
        return {
            success = true,
            item = recipe.result.item,
            amount = recipe.result.amount,
            xp = xpGained,
            leveledUp = skillUpdate.leveledUp,
            newLevel = skillUpdate.newLevel
        }
    else
        -- Failure
        if Config.Crafting.OnFailure.returnMaterials then
            returnMaterials(source, recipe.materials, Config.Crafting.OnFailure.returnPercentage)
        end
        
        if Config.Crafting.OnFailure.giveXP then
            local xpGained = math.floor(recipe.crafting.xp * (Config.Crafting.OnFailure.xpPercentage / 100))
            addXP(identifier, xpGained)
        end
        
        Framework.Notify(source, 'Crafting fehlgeschlagen! ' .. Config.Crafting.OnFailure.returnPercentage .. '% der Materialien zurückerstattet.', 'error', 7000)
        
        return {
            success = false,
            failed = true
        }
    end
end)

-- ====================================
-- ADMIN COMMANDS
-- ====================================

lib.addCommand('givexp', {
    help = 'Gib einem Spieler Crafting XP',
    restricted = 'group.admin',
    params = {
        {name = 'target', type = 'playerId', help = 'Spieler ID'},
        {name = 'amount', type = 'number', help = 'XP Menge'}
    }
}, function(source, args)
    local target = args.target
    local amount = args.amount
    
    local identifier = Framework.GetIdentifier(target)
    if not identifier then
        Framework.Notify(source, 'Spieler nicht gefunden!', 'error')
        return
    end
    
    local skillUpdate = addXP(identifier, amount)
    
    Framework.Notify(source, 'Du hast ' .. Framework.GetPlayerName(target) .. ' ' .. amount .. ' XP gegeben!', 'success')
    Framework.Notify(target, 'Du hast ' .. amount .. ' Crafting XP erhalten!', 'success')
    
    if skillUpdate.leveledUp then
        Framework.Notify(target, '🎉 Level Up! Du bist jetzt Level ' .. skillUpdate.newLevel, 'success')
    end
end)

lib.addCommand('giveblueprint', {
    help = 'Gib einem Spieler eine Blaupause',
    restricted = 'group.admin',
    params = {
        {name = 'target', type = 'playerId', help = 'Spieler ID'},
        {name = 'recipe', type = 'string', help = 'Rezept ID'}
    }
}, function(source, args)
    local target = args.target
    local recipeId = args.recipe
    
    local recipe = Config.GetRecipeById(recipeId)
    if not recipe then
        Framework.Notify(source, 'Rezept nicht gefunden!', 'error')
        return
    end
    
    local identifier = Framework.GetIdentifier(target)
    if not identifier then
        Framework.Notify(source, 'Spieler nicht gefunden!', 'error')
        return
    end
    
    if hasBlueprint(identifier, recipeId) then
        Framework.Notify(source, 'Spieler hat diese Blaupause bereits!', 'error')
        return
    end
    
    giveBlueprint(identifier, recipeId)
    
    Framework.Notify(source, 'Du hast ' .. Framework.GetPlayerName(target) .. ' die Blaupause für ' .. recipe.label .. ' gegeben!', 'success')
    Framework.Notify(target, 'Du hast eine Blaupause für ' .. recipe.label .. ' erhalten!', 'success')
end)

lib.addCommand('craftingstats', {
    help = 'Zeige Crafting Stats eines Spielers',
    restricted = 'group.admin',
    params = {
        {name = 'target', type = 'playerId', help = 'Spieler ID', optional = true}
    }
}, function(source, args)
    local target = args.target or source
    
    local identifier = Framework.GetIdentifier(target)
    if not identifier then
        Framework.Notify(source, 'Spieler nicht gefunden!', 'error')
        return
    end
    
    local skills = getPlayerSkills(identifier)
    local blueprints = getPlayerBlueprints(identifier)
    
    local message = '📊 Crafting Stats für ' .. Framework.GetPlayerName(target) .. ':\n'
    message = message .. 'Level: ' .. skills.level .. '/' .. Config.Skills.MaxLevel .. '\n'
    message = message .. 'XP: ' .. skills.xp .. '\n'
    message = message .. 'Hergestellte Items: ' .. skills.craftedItems .. '\n'
    message = message .. 'Blaupausen: ' .. #blueprints
    
    Framework.Notify(source, message, 'info', 10000)
end)
