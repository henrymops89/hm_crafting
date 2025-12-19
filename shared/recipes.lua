-- ====================================
-- HENRY CRAFTING - RECIPES
-- ====================================

Config.Recipes = {}

-- ====================================
-- WEAPONS
-- ====================================

Config.Recipes.weapons = {
    -- Pistols
    {
        id = 'weapon_pistol',
        label = 'Pistole',
        item = 'weapon_pistol',
        category = 'weapons',
        rarity = 'common',
        
        requirements = {
            level = 0,
            blueprint = false -- Kein Blueprint nötig
        },
        
        materials = {
            {item = 'steel', amount = 10, label = 'Stahl'},
            {item = 'plastic', amount = 5, label = 'Plastik'},
            {item = 'rubber', amount = 3, label = 'Gummi'}
        },
        
        result = {
            item = 'weapon_pistol',
            amount = 1
        },
        
        crafting = {
            time = 15000, -- 15 Sekunden
            successChance = 90,
            xp = 50
        }
    },
    
    {
        id = 'weapon_pistol_mk2',
        label = 'Pistole MK2',
        item = 'weapon_pistol_mk2',
        category = 'weapons',
        rarity = 'uncommon',
        
        requirements = {
            level = 10,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 15, label = 'Stahl'},
            {item = 'plastic', amount = 8, label = 'Plastik'},
            {item = 'rubber', amount = 5, label = 'Gummi'},
            {item = 'electronics', amount = 2, label = 'Elektronik'}
        },
        
        result = {
            item = 'weapon_pistol_mk2',
            amount = 1
        },
        
        crafting = {
            time = 20000,
            successChance = 85,
            xp = 100
        }
    },
    
    -- SMGs
    {
        id = 'weapon_microsmg',
        label = 'Micro SMG',
        item = 'weapon_microsmg',
        category = 'weapons',
        rarity = 'rare',
        
        requirements = {
            level = 20,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 25, label = 'Stahl'},
            {item = 'plastic', amount = 15, label = 'Plastik'},
            {item = 'rubber', amount = 10, label = 'Gummi'},
            {item = 'electronics', amount = 5, label = 'Elektronik'}
        },
        
        result = {
            item = 'weapon_microsmg',
            amount = 1
        },
        
        crafting = {
            time = 30000,
            successChance = 75,
            xp = 200
        }
    },
    
    {
        id = 'weapon_smg',
        label = 'SMG',
        item = 'weapon_smg',
        category = 'weapons',
        rarity = 'rare',
        
        requirements = {
            level = 25,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 30, label = 'Stahl'},
            {item = 'plastic', amount = 20, label = 'Plastik'},
            {item = 'rubber', amount = 12, label = 'Gummi'},
            {item = 'electronics', amount = 8, label = 'Elektronik'}
        },
        
        result = {
            item = 'weapon_smg',
            amount = 1
        },
        
        crafting = {
            time = 35000,
            successChance = 70,
            xp = 250
        }
    },
    
    -- Rifles
    {
        id = 'weapon_assaultrifle',
        label = 'Assault Rifle',
        item = 'weapon_assaultrifle',
        category = 'weapons',
        rarity = 'epic',
        
        requirements = {
            level = 40,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 50, label = 'Stahl'},
            {item = 'plastic', amount = 30, label = 'Plastik'},
            {item = 'rubber', amount = 20, label = 'Gummi'},
            {item = 'electronics', amount = 15, label = 'Elektronik'},
            {item = 'weapon_parts', amount = 5, label = 'Waffenteile'}
        },
        
        result = {
            item = 'weapon_assaultrifle',
            amount = 1
        },
        
        crafting = {
            time = 60000,
            successChance = 60,
            xp = 500
        }
    },
    
    {
        id = 'weapon_carbinerifle',
        label = 'Carbine Rifle',
        item = 'weapon_carbinerifle',
        category = 'weapons',
        rarity = 'epic',
        
        requirements = {
            level = 45,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 55, label = 'Stahl'},
            {item = 'plastic', amount = 35, label = 'Plastik'},
            {item = 'rubber', amount = 25, label = 'Gummi'},
            {item = 'electronics', amount = 18, label = 'Elektronik'},
            {item = 'weapon_parts', amount = 8, label = 'Waffenteile'}
        },
        
        result = {
            item = 'weapon_carbinerifle',
            amount = 1
        },
        
        crafting = {
            time = 75000,
            successChance = 55,
            xp = 600
        }
    },
    
    -- Shotguns
    {
        id = 'weapon_pumpshotgun',
        label = 'Pump Shotgun',
        item = 'weapon_pumpshotgun',
        category = 'weapons',
        rarity = 'uncommon',
        
        requirements = {
            level = 15,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 20, label = 'Stahl'},
            {item = 'plastic', amount = 12, label = 'Plastik'},
            {item = 'rubber', amount = 8, label = 'Gummi'},
            {item = 'wood', amount = 10, label = 'Holz'}
        },
        
        result = {
            item = 'weapon_pumpshotgun',
            amount = 1
        },
        
        crafting = {
            time = 25000,
            successChance = 80,
            xp = 150
        }
    }
}

-- ====================================
-- ATTACHMENTS
-- ====================================

Config.Recipes.attachments = {
    {
        id = 'weapon_flashlight',
        label = 'Waffen Taschenlampe',
        item = 'weapon_flashlight',
        category = 'attachments',
        rarity = 'common',
        
        requirements = {
            level = 5,
            blueprint = false
        },
        
        materials = {
            {item = 'plastic', amount = 3, label = 'Plastik'},
            {item = 'electronics', amount = 2, label = 'Elektronik'},
            {item = 'battery', amount = 1, label = 'Batterie'}
        },
        
        result = {
            item = 'weapon_flashlight',
            amount = 1
        },
        
        crafting = {
            time = 10000,
            successChance = 95,
            xp = 25
        }
    },
    
    {
        id = 'weapon_suppressor',
        label = 'Schalldämpfer',
        item = 'weapon_suppressor',
        category = 'attachments',
        rarity = 'rare',
        
        requirements = {
            level = 30,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 15, label = 'Stahl'},
            {item = 'rubber', amount = 10, label = 'Gummi'},
            {item = 'foam', amount = 5, label = 'Schaumstoff'}
        },
        
        result = {
            item = 'weapon_suppressor',
            amount = 1
        },
        
        crafting = {
            time = 25000,
            successChance = 70,
            xp = 150
        }
    },
    
    {
        id = 'weapon_scope',
        label = 'Zielfernrohr',
        item = 'weapon_scope',
        category = 'attachments',
        rarity = 'uncommon',
        
        requirements = {
            level = 20,
            blueprint = true
        },
        
        materials = {
            {item = 'plastic', amount = 8, label = 'Plastik'},
            {item = 'electronics', amount = 5, label = 'Elektronik'},
            {item = 'glass', amount = 3, label = 'Glas'}
        },
        
        result = {
            item = 'weapon_scope',
            amount = 1
        },
        
        crafting = {
            time = 20000,
            successChance = 85,
            xp = 100
        }
    },
    
    {
        id = 'weapon_grip',
        label = 'Waffengriff',
        item = 'weapon_grip',
        category = 'attachments',
        rarity = 'common',
        
        requirements = {
            level = 8,
            blueprint = false
        },
        
        materials = {
            {item = 'plastic', amount = 5, label = 'Plastik'},
            {item = 'rubber', amount = 3, label = 'Gummi'}
        },
        
        result = {
            item = 'weapon_grip',
            amount = 1
        },
        
        crafting = {
            time = 12000,
            successChance = 90,
            xp = 40
        }
    }
}

-- ====================================
-- ITEMS
-- ====================================

Config.Recipes.items = {
    {
        id = 'lockpick',
        label = 'Dietrich',
        item = 'lockpick',
        category = 'items',
        rarity = 'common',
        
        requirements = {
            level = 0,
            blueprint = false
        },
        
        materials = {
            {item = 'steel', amount = 2, label = 'Stahl'},
            {item = 'plastic', amount = 1, label = 'Plastik'}
        },
        
        result = {
            item = 'lockpick',
            amount = 1
        },
        
        crafting = {
            time = 5000,
            successChance = 95,
            xp = 10
        }
    },
    
    {
        id = 'advanced_lockpick',
        label = 'Erweiterter Dietrich',
        item = 'advanced_lockpick',
        category = 'items',
        rarity = 'uncommon',
        
        requirements = {
            level = 15,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 5, label = 'Stahl'},
            {item = 'plastic', amount = 3, label = 'Plastik'},
            {item = 'electronics', amount = 2, label = 'Elektronik'}
        },
        
        result = {
            item = 'advanced_lockpick',
            amount = 1
        },
        
        crafting = {
            time = 15000,
            successChance = 85,
            xp = 75
        }
    },
    
    {
        id = 'armor',
        label = 'Körperpanzerung',
        item = 'armor',
        category = 'items',
        rarity = 'uncommon',
        
        requirements = {
            level = 10,
            blueprint = false
        },
        
        materials = {
            {item = 'steel', amount = 15, label = 'Stahl'},
            {item = 'plastic', amount = 10, label = 'Plastik'},
            {item = 'cloth', amount = 8, label = 'Stoff'}
        },
        
        result = {
            item = 'armor',
            amount = 1
        },
        
        crafting = {
            time = 20000,
            successChance = 90,
            xp = 100
        }
    },
    
    {
        id = 'heavyarmor',
        label = 'Schwere Panzerung',
        item = 'heavyarmor',
        category = 'items',
        rarity = 'rare',
        
        requirements = {
            level = 30,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 30, label = 'Stahl'},
            {item = 'plastic', amount = 20, label = 'Plastik'},
            {item = 'cloth', amount = 15, label = 'Stoff'},
            {item = 'kevlar', amount = 5, label = 'Kevlar'}
        },
        
        result = {
            item = 'heavyarmor',
            amount = 1
        },
        
        crafting = {
            time = 40000,
            successChance = 75,
            xp = 250
        }
    },
    
    {
        id = 'radio',
        label = 'Radio',
        item = 'radio',
        category = 'items',
        rarity = 'common',
        
        requirements = {
            level = 5,
            blueprint = false
        },
        
        materials = {
            {item = 'plastic', amount = 5, label = 'Plastik'},
            {item = 'electronics', amount = 8, label = 'Elektronik'},
            {item = 'battery', amount = 2, label = 'Batterie'}
        },
        
        result = {
            item = 'radio',
            amount = 1
        },
        
        crafting = {
            time = 12000,
            successChance = 90,
            xp = 50
        }
    },
    
    {
        id = 'phone',
        label = 'Handy',
        item = 'phone',
        category = 'items',
        rarity = 'uncommon',
        
        requirements = {
            level = 12,
            blueprint = true
        },
        
        materials = {
            {item = 'plastic', amount = 8, label = 'Plastik'},
            {item = 'electronics', amount = 15, label = 'Elektronik'},
            {item = 'battery', amount = 3, label = 'Batterie'},
            {item = 'glass', amount = 2, label = 'Glas'}
        },
        
        result = {
            item = 'phone',
            amount = 1
        },
        
        crafting = {
            time = 25000,
            successChance = 85,
            xp = 120
        }
    }
}

-- ====================================
-- CONSUMABLES
-- ====================================

Config.Recipes.consumables = {
    {
        id = 'bandage',
        label = 'Verband',
        item = 'bandage',
        category = 'consumables',
        rarity = 'common',
        
        requirements = {
            level = 0,
            blueprint = false
        },
        
        materials = {
            {item = 'cloth', amount = 2, label = 'Stoff'}
        },
        
        result = {
            item = 'bandage',
            amount = 3
        },
        
        crafting = {
            time = 5000,
            successChance = 98,
            xp = 5
        }
    },
    
    {
        id = 'firstaid',
        label = 'Erste-Hilfe-Set',
        item = 'firstaid',
        category = 'consumables',
        rarity = 'uncommon',
        
        requirements = {
            level = 8,
            blueprint = false
        },
        
        materials = {
            {item = 'cloth', amount = 5, label = 'Stoff'},
            {item = 'plastic', amount = 3, label = 'Plastik'},
            {item = 'bandage', amount = 2, label = 'Verband'}
        },
        
        result = {
            item = 'firstaid',
            amount = 1
        },
        
        crafting = {
            time = 15000,
            successChance = 92,
            xp = 50
        }
    },
    
    {
        id = 'repairkit',
        label = 'Reparaturset',
        item = 'repairkit',
        category = 'consumables',
        rarity = 'uncommon',
        
        requirements = {
            level = 10,
            blueprint = false
        },
        
        materials = {
            {item = 'steel', amount = 8, label = 'Stahl'},
            {item = 'plastic', amount = 5, label = 'Plastik'},
            {item = 'rubber', amount = 3, label = 'Gummi'}
        },
        
        result = {
            item = 'repairkit',
            amount = 1
        },
        
        crafting = {
            time = 18000,
            successChance = 88,
            xp = 80
        }
    },
    
    {
        id = 'advancedrepairkit',
        label = 'Erweiterte Reparaturset',
        item = 'advancedrepairkit',
        category = 'consumables',
        rarity = 'rare',
        
        requirements = {
            level = 25,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 15, label = 'Stahl'},
            {item = 'plastic', amount = 10, label = 'Plastik'},
            {item = 'rubber', amount = 8, label = 'Gummi'},
            {item = 'electronics', amount = 5, label = 'Elektronik'}
        },
        
        result = {
            item = 'advancedrepairkit',
            amount = 1
        },
        
        crafting = {
            time = 30000,
            successChance = 80,
            xp = 150
        }
    }
}

-- ====================================
-- TOOLS
-- ====================================

Config.Recipes.tools = {
    {
        id = 'drill',
        label = 'Bohrmaschine',
        item = 'drill',
        category = 'tools',
        rarity = 'uncommon',
        
        requirements = {
            level = 18,
            blueprint = true
        },
        
        materials = {
            {item = 'steel', amount = 12, label = 'Stahl'},
            {item = 'plastic', amount = 8, label = 'Plastik'},
            {item = 'electronics', amount = 10, label = 'Elektronik'},
            {item = 'battery', amount = 3, label = 'Batterie'}
        },
        
        result = {
            item = 'drill',
            amount = 1
        },
        
        crafting = {
            time = 25000,
            successChance = 85,
            xp = 120
        }
    },
    
    {
        id = 'thermite',
        label = 'Thermit',
        item = 'thermite',
        category = 'tools',
        rarity = 'rare',
        
        requirements = {
            level = 35,
            blueprint = true
        },
        
        materials = {
            {item = 'aluminum', amount = 10, label = 'Aluminium'},
            {item = 'iron_oxide', amount = 8, label = 'Eisenoxid'},
            {item = 'plastic', amount = 5, label = 'Plastik'},
            {item = 'electronics', amount = 3, label = 'Elektronik'}
        },
        
        result = {
            item = 'thermite',
            amount = 1
        },
        
        crafting = {
            time = 45000,
            successChance = 70,
            xp = 300
        }
    },
    
    {
        id = 'electronickit',
        label = 'Elektronik-Kit',
        item = 'electronickit',
        category = 'tools',
        rarity = 'uncommon',
        
        requirements = {
            level = 15,
            blueprint = true
        },
        
        materials = {
            {item = 'electronics', amount = 15, label = 'Elektronik'},
            {item = 'plastic', amount = 8, label = 'Plastik'},
            {item = 'copper', amount = 5, label = 'Kupfer'}
        },
        
        result = {
            item = 'electronickit',
            amount = 1
        },
        
        crafting = {
            time = 20000,
            successChance = 87,
            xp = 90
        }
    },
    
    {
        id = 'gatecrack',
        label = 'Tor-Hacker',
        item = 'gatecrack',
        category = 'tools',
        rarity = 'epic',
        
        requirements = {
            level = 50,
            blueprint = true
        },
        
        materials = {
            {item = 'electronics', amount = 25, label = 'Elektronik'},
            {item = 'plastic', amount = 15, label = 'Plastik'},
            {item = 'copper', amount = 10, label = 'Kupfer'},
            {item = 'microchip', amount = 5, label = 'Mikrochip'}
        },
        
        result = {
            item = 'gatecrack',
            amount = 1
        },
        
        crafting = {
            time = 60000,
            successChance = 65,
            xp = 500
        }
    }
}

-- ====================================
-- HELPER FUNCTIONS
-- ====================================

function Config.GetRecipeById(recipeId)
    for category, recipes in pairs(Config.Recipes) do
        for _, recipe in ipairs(recipes) do
            if recipe.id == recipeId then
                return recipe
            end
        end
    end
    return nil
end

function Config.GetRecipesByCategory(category)
    return Config.Recipes[category] or {}
end

function Config.GetAllRecipes()
    local allRecipes = {}
    for category, recipes in pairs(Config.Recipes) do
        for _, recipe in ipairs(recipes) do
            table.insert(allRecipes, recipe)
        end
    end
    return allRecipes
end
