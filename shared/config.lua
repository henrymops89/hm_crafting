-- ====================================
-- HENRY CRAFTING - MAIN CONFIG
-- ====================================

Config = {}

-- ====================================
-- GENERAL SETTINGS
-- ====================================

Config.Debug = true -- Enable debug prints

Config.UseSkillSystem = true -- Enable XP/Level system
Config.UseBlueprints = true -- Require blueprints to craft
Config.UseCraftingTime = true -- Enable crafting duration
Config.UseAnimations = true -- Enable crafting animations

-- ====================================
-- SKILL SYSTEM
-- ====================================

Config.Skills = {
    MaxLevel = 100,
    XPPerLevel = 1000, -- XP needed per level
    XPPerCraft = {
        common = 10,
        uncommon = 25,
        rare = 50,
        epic = 100,
        legendary = 200
    }
}

-- ====================================
-- CRAFTING CATEGORIES
-- ====================================

Config.Categories = {
    {
        id = 'weapons',
        label = 'Waffen',
        icon = 'gun',
        requiredLevel = 0
    },
    {
        id = 'attachments',
        label = 'Waffenzubehör',
        icon = 'crosshairs',
        requiredLevel = 10
    },
    {
        id = 'items',
        label = 'Items',
        icon = 'box',
        requiredLevel = 0
    },
    {
        id = 'consumables',
        label = 'Verbrauchsgüter',
        icon = 'flask',
        requiredLevel = 5
    },
    {
        id = 'tools',
        label = 'Werkzeuge',
        icon = 'wrench',
        requiredLevel = 15
    }
}

-- ====================================
-- CRAFTING LOCATIONS
-- ====================================

Config.Locations = {
    -- Weapons Bench
    {
        id = 'weapons_bench_1',
        label = 'Waffen Werkbank',
        coords = vector3(1088.71, -3194.33, -38.99),
        category = 'weapons',
        blip = {
            enabled = false,
            sprite = 110,
            color = 1,
            scale = 0.8
        },
        zone = {
            radius = 2.0,
            debug = Config.Debug
        },
        jobs = nil -- nil = everyone, {'police', 'mechanic'} = job restricted
    },
    
    -- Items Bench
    {
        id = 'items_bench_1',
        label = 'Item Werkbank',
        coords = vector3(1093.18, -3196.65, -38.99),
        category = 'items',
        blip = {
            enabled = false,
            sprite = 478,
            color = 5,
            scale = 0.8
        },
        zone = {
            radius = 2.0,
            debug = Config.Debug
        },
        jobs = nil
    },
    
    -- Tools Bench (Job Restricted Example)
    {
        id = 'mechanic_bench',
        label = 'Mechaniker Werkbank',
        coords = vector3(-337.89, -136.09, 39.01),
        category = 'tools',
        blip = {
            enabled = true,
            sprite = 446,
            color = 47,
            scale = 0.7
        },
        zone = {
            radius = 2.5,
            debug = Config.Debug
        },
        jobs = {'mechanic'}
    }
}

-- ====================================
-- CRAFTING SETTINGS
-- ====================================

Config.Crafting = {
    -- Success Chance (0-100)
    BaseSuccessChance = 85,
    
    -- Success chance increases with skill level
    SkillBonusPerLevel = 0.15, -- 0.15% per level
    
    -- Fail consequences
    OnFailure = {
        returnMaterials = true, -- Return materials on fail
        returnPercentage = 50, -- 50% of materials returned
        giveXP = true, -- Give XP even on fail
        xpPercentage = 25 -- 25% of normal XP
    },
    
    -- Animation
    Animation = {
        dict = 'amb@prop_human_parking_meter@female@idle_a',
        anim = 'idle_a_female',
        flag = 16
    },
    
    -- Progress Bar
    ProgressBar = {
        label = 'Crafting...',
        useWhileDead = false,
        canCancel = true,
        disableControls = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }
    }
}

-- ====================================
-- BLUEPRINTS
-- ====================================

Config.Blueprints = {
    -- Blueprint items (müssen im Inventory existieren)
    ItemName = 'blueprint',
    
    -- Where to get blueprints
    Sources = {
        {
            type = 'shop', -- shop, mission, loot, crafting
            label = 'Schwarzmarkt',
            coords = vector3(1090.0, -3195.0, -38.99),
            blip = {
                enabled = false,
                sprite = 108,
                color = 1
            }
        }
    },
    
    -- Blueprint rarities & prices
    Rarities = {
        common = {
            label = 'Gewöhnlich',
            color = '#9CA3AF',
            price = 500
        },
        uncommon = {
            label = 'Ungewöhnlich',
            color = '#10B981',
            price = 1500
        },
        rare = {
            label = 'Selten',
            color = '#3B82F6',
            price = 5000
        },
        epic = {
            label = 'Episch',
            color = '#A855F7',
            price = 15000
        },
        legendary = {
            label = 'Legendär',
            color = '#F59E0B',
            price = 50000
        }
    }
}

-- ====================================
-- UI SETTINGS
-- ====================================

Config.UI = {
    DefaultCategory = 'weapons',
    ShowOwnedBlueprints = true,
    ShowLockedRecipes = true,
    SortBy = 'level' -- 'level', 'name', 'rarity'
}
