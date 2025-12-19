-- ====================================
-- HENRY CRAFTING - ANIMATIONS
-- ====================================

local Animations = {}

-- ====================================
-- ANIMATION PRESETS
-- ====================================

Animations.Presets = {
    -- Default crafting
    default = {
        dict = 'amb@prop_human_parking_meter@female@idle_a',
        anim = 'idle_a_female',
        flag = 16
    },
    
    -- Mechanic work
    mechanic = {
        dict = 'mini@repair',
        anim = 'fixing_a_ped',
        flag = 16
    },
    
    -- Welding
    welding = {
        dict = 'amb@world_human_welding@male@base',
        anim = 'base',
        flag = 16
    },
    
    -- Electronics work
    electronics = {
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        anim = 'machinic_loop_mechandplayer',
        flag = 16
    },
    
    -- Heavy lifting
    lifting = {
        dict = 'amb@prop_human_bum_bin@idle_b',
        anim = 'idle_d',
        flag = 16
    },
    
    -- Precise work
    precise = {
        dict = 'amb@world_human_clipboard@male@idle_a',
        anim = 'idle_a',
        flag = 49
    }
}

-- ====================================
-- ANIMATION FUNCTIONS
-- ====================================

function Animations.Play(animName)
    local preset = Animations.Presets[animName] or Animations.Presets.default
    local ped = cache.ped
    
    lib.requestAnimDict(preset.dict, 2000)
    
    TaskPlayAnim(
        ped,
        preset.dict,
        preset.anim,
        8.0, 8.0, -1,
        preset.flag,
        0, false, false, false
    )
end

function Animations.Stop()
    ClearPedTasks(cache.ped)
end

function Animations.PlayByCategory(category)
    local animMap = {
        weapons = 'welding',
        attachments = 'precise',
        items = 'default',
        consumables = 'default',
        tools = 'mechanic',
        vehicles = 'mechanic'
    }
    
    local animName = animMap[category] or 'default'
    Animations.Play(animName)
end

-- ====================================
-- PROPS (Optional - for future use)
-- ====================================

Animations.Props = {}

function Animations.AttachProp(propModel, bone, offset, rotation)
    local ped = cache.ped
    
    lib.requestModel(propModel, 2000)
    
    local prop = CreateObject(propModel, 0.0, 0.0, 0.0, true, true, true)
    
    AttachEntityToEntity(
        prop, ped, 
        GetPedBoneIndex(ped, bone),
        offset.x, offset.y, offset.z,
        rotation.x, rotation.y, rotation.z,
        true, true, false, true, 1, true
    )
    
    table.insert(Animations.Props, prop)
    
    return prop
end

function Animations.RemoveAllProps()
    for _, prop in ipairs(Animations.Props) do
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    Animations.Props = {}
end

-- ====================================
-- EXAMPLES (commented out)
-- ====================================

--[[
-- Example: Welding with sparks effect
function Animations.WeldingWithEffects()
    Animations.Play('welding')
    
    -- Particle effect
    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    
    lib.requestNamedPtfxAsset('core', 2000)
    
    UseParticleFxAsset('core')
    StartNetworkedParticleFxNonLoopedAtCoord(
        'ent_ray_heli_aprtmnt_l_fire',
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        0.3, false, false, false
    )
end

-- Example: Crafting with tool prop
function Animations.CraftWithHammer()
    Animations.Play('mechanic')
    
    local hammerProp = Animations.AttachProp(
        `prop_tool_hammer`,
        28422, -- Right hand bone
        {x = 0.0, y = 0.0, z = 0.0},
        {x = 0.0, y = 0.0, z = 0.0}
    )
    
    return hammerProp
end
]]--

-- ====================================
-- CLEANUP ON RESOURCE STOP
-- ====================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    Animations.Stop()
    Animations.RemoveAllProps()
end)
