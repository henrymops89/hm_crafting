-- ====================================
-- HENRY CRAFTING - CLIENT MAIN
-- ====================================

local PlayerData = {}
local currentLocation = nil
local isNearBench = false

-- ====================================
-- RESOURCE START
-- ====================================

CreateThread(function()
    while not Framework.Name do
        Wait(100)
    end
    
    PlayerData = Framework.GetPlayerData()
    print('^2[Henry Crafting] Client initialized!^0')
end)

-- ====================================
-- PLAYER LOADED
-- ====================================

if Framework.Name == 'QBCore' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = Framework.GetPlayerData()
    end)
    
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        PlayerData = {}
    end)
elseif Framework.Name == 'QBox' then
    RegisterNetEvent('qbx_core:client:playerLoaded', function()
        PlayerData = Framework.GetPlayerData()
    end)
    
    RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
        PlayerData = {}
    end)
elseif Framework.Name == 'ESX' then
    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)
    
    RegisterNetEvent('esx:onPlayerLogout', function()
        PlayerData = {}
    end)
end

-- ====================================
-- HELPER FUNCTIONS
-- ====================================

local function debugPrint(message)
    if Config.Debug then
        print('^5[DEBUG]^0 ' .. message)
    end
end

-- ====================================
-- CRAFTING MENU (ox_lib)
-- ====================================

local function openCraftingMenu(locationId)
    debugPrint('Opening crafting menu for location: ' .. locationId)
    
    -- Get player data
    local playerData = lib.callback.await('henry_crafting:getPlayerData', false)
    if not playerData then
        Framework.Notify('Fehler beim Laden der Spielerdaten!', 'error')
        return
    end
    
    -- Get recipes for this location
    local recipes = lib.callback.await('henry_crafting:getRecipes', false, locationId)
    if not recipes or #recipes == 0 then
        Framework.Notify('Keine Rezepte für diese Werkbank verfügbar!', 'error')
        return
    end
    
    -- Build menu options
    local menuOptions = {}
    
    -- Player stats header
    table.insert(menuOptions, {
        title = '📊 Deine Stats',
        description = 'Level: ' .. playerData.skills.level .. ' | XP: ' .. playerData.skills.xp .. ' | Items: ' .. playerData.skills.craftedItems,
        icon = 'chart-line',
        disabled = true
    })
    
    table.insert(menuOptions, {
        title = '─────────────',
        disabled = true
    })
    
    -- Add recipes
    for _, recipe in ipairs(recipes) do
        local rarityColor = Config.Blueprints.Rarities[recipe.rarity].color
        local statusIcon = '✅'
        local statusText = ''
        
        if not recipe.meetsLevel then
            statusIcon = '🔒'
            statusText = ' (Level ' .. recipe.requirements.level .. ' benötigt)'
        elseif recipe.requirements.blueprint and not recipe.hasBlueprint then
            statusIcon = '📜'
            statusText = ' (Blaupause benötigt)'
        elseif not recipe.canCraft then
            statusIcon = '❌'
            statusText = ' (' .. (recipe.reason or 'Materialien fehlen') .. ')'
        end
        
        -- Materials string
        local materialsText = ''
        for i, material in ipairs(recipe.materials) do
            if i > 1 then materialsText = materialsText .. ', ' end
            materialsText = materialsText .. material.amount .. 'x ' .. material.label
        end
        
        table.insert(menuOptions, {
            title = statusIcon .. ' ' .. recipe.label .. statusText,
            description = 'Materialien: ' .. materialsText .. '\nZeit: ' .. (recipe.crafting.time / 1000) .. 's | Chance: ' .. recipe.crafting.successChance .. '% | XP: ' .. recipe.crafting.xp,
            icon = 'hammer',
            iconColor = rarityColor,
            disabled = not recipe.canCraft,
            onSelect = function()
                startCrafting(recipe)
            end,
            metadata = {
                {label = 'Level', value = recipe.requirements.level},
                {label = 'Rarity', value = Config.Blueprints.Rarities[recipe.rarity].label},
                {label = 'Erfolgsrate', value = recipe.crafting.successChance .. '%'},
            }
        })
    end
    
    -- Register and show menu
    lib.registerContext({
        id = 'henry_crafting_menu',
        title = '🔨 Crafting Werkbank',
        options = menuOptions
    })
    
    lib.showContext('henry_crafting_menu')
end

-- ====================================
-- CRAFTING PROCESS
-- ====================================

local function startCrafting(recipe)
    debugPrint('Starting craft: ' .. recipe.label)
    
    -- Request craft start from server
    local craftData = lib.callback.await('henry_crafting:startCraft', false, recipe.id)
    
    if not craftData.success then
        Framework.Notify(craftData.message, 'error')
        return
    end
    
    -- Play animation
    if Config.UseAnimations then
        local ped = cache.ped
        lib.requestAnimDict(Config.Crafting.Animation.dict, 2000)
        TaskPlayAnim(
            ped,
            Config.Crafting.Animation.dict,
            Config.Crafting.Animation.anim,
            8.0, 8.0, -1,
            Config.Crafting.Animation.flag,
            0, false, false, false
        )
    end
    
    -- Show progress bar
    local success = lib.progressBar({
        duration = craftData.duration,
        label = Config.Crafting.ProgressBar.label .. ' ' .. recipe.label,
        useWhileDead = Config.Crafting.ProgressBar.useWhileDead,
        canCancel = Config.Crafting.ProgressBar.canCancel,
        disable = Config.Crafting.ProgressBar.disableControls
    })
    
    -- Stop animation
    if Config.UseAnimations then
        ClearPedTasks(cache.ped)
    end
    
    -- Complete crafting
    local result = lib.callback.await('henry_crafting:completeCraft', false, recipe.id, not success)
    
    if result.cancelled then
        return
    end
    
    if result.success then
        debugPrint('Craft successful: ' .. recipe.label)
        -- Success notification is sent from server
    else
        debugPrint('Craft failed: ' .. recipe.label)
        -- Failure notification is sent from server
    end
    
    -- Reopen menu
    Wait(1000)
    if isNearBench and currentLocation then
        openCraftingMenu(currentLocation.id)
    end
end

-- ====================================
-- EXPORTS
-- ====================================

exports('OpenCraftingMenu', openCraftingMenu)

-- ====================================
-- GLOBAL FUNCTIONS
-- ====================================

function OpenCraftingMenu(locationId)
    openCraftingMenu(locationId)
end
