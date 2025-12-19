-- ====================================
-- HENRY CRAFTING - LOCATIONS & ZONES
-- ====================================

local activeZones = {}
local activeBlips = {}

-- ====================================
-- HELPER FUNCTIONS
-- ====================================

local function debugPrint(message)
    if Config.Debug then
        print('^5[DEBUG]^0 ' .. message)
    end
end

local function hasRequiredJob(location)
    if not location.jobs or #location.jobs == 0 then
        return true -- No job restriction
    end
    
    local PlayerData = Framework.GetPlayerData()
    if not PlayerData then return false end
    
    local playerJob = nil
    if Framework.Name == 'QBCore' or Framework.Name == 'QBox' then
        playerJob = PlayerData.job.name
    elseif Framework.Name == 'ESX' then
        playerJob = PlayerData.job.name
    end
    
    for _, job in ipairs(location.jobs) do
        if playerJob == job then
            return true
        end
    end
    
    return false
end

-- ====================================
-- BLIPS
-- ====================================

local function createBlip(location)
    if not location.blip.enabled then return end
    
    local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
    
    SetBlipSprite(blip, location.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, location.blip.scale)
    SetBlipColour(blip, location.blip.color)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(location.label)
    EndTextCommandSetBlipName(blip)
    
    activeBlips[location.id] = blip
    debugPrint('Created blip for: ' .. location.label)
end

local function createAllBlips()
    for _, location in ipairs(Config.Locations) do
        createBlip(location)
    end
end

local function removeAllBlips()
    for id, blip in pairs(activeBlips) do
        RemoveBlip(blip)
    end
    activeBlips = {}
end

-- ====================================
-- ZONES (ox_lib)
-- ====================================

local function createZone(location)
    local zone = lib.zones.sphere({
        coords = location.coords,
        radius = location.zone.radius,
        debug = location.zone.debug,
        
        onEnter = function()
            debugPrint('Entered zone: ' .. location.label)
            
            -- Check job requirement
            if not hasRequiredJob(location) then
                return
            end
            
            isNearBench = true
            currentLocation = location
            
            -- Show TextUI
            lib.showTextUI('[E] - ' .. location.label, {
                position = "top-center",
                icon = 'hammer',
                style = {
                    borderRadius = 5,
                    backgroundColor = '#48BB78',
                    color = 'white'
                }
            })
        end,
        
        onExit = function()
            debugPrint('Exited zone: ' .. location.label)
            
            isNearBench = false
            currentLocation = nil
            
            lib.hideTextUI()
        end,
        
        inside = function()
            if IsControlJustReleased(0, 38) then -- E key
                if hasRequiredJob(location) then
                    OpenCraftingMenu(location.id)
                else
                    Framework.Notify('Du hast nicht den erforderlichen Job!', 'error')
                end
            end
        end
    })
    
    activeZones[location.id] = zone
    debugPrint('Created zone for: ' .. location.label)
end

local function createAllZones()
    for _, location in ipairs(Config.Locations) do
        createZone(location)
    end
end

local function removeAllZones()
    for id, zone in pairs(activeZones) do
        zone:remove()
    end
    activeZones = {}
end

-- ====================================
-- RESOURCE START/STOP
-- ====================================

CreateThread(function()
    -- Wait for framework
    while not Framework.Name do
        Wait(100)
    end
    
    Wait(1000) -- Give some time for player to load
    
    createAllBlips()
    createAllZones()
    
    print('^2[Henry Crafting] Locations initialized!^0')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    removeAllBlips()
    removeAllZones()
    lib.hideTextUI()
end)

-- ====================================
-- JOB CHANGE HANDLING
-- ====================================

if Framework.Name == 'QBCore' then
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
        -- Refresh zones when job changes
        removeAllZones()
        Wait(100)
        createAllZones()
    end)
elseif Framework.Name == 'QBox' then
    -- QBox doesn't have specific job update event, handled by onEnter check
elseif Framework.Name == 'ESX' then
    RegisterNetEvent('esx:setJob', function(job)
        -- Refresh zones when job changes
        removeAllZones()
        Wait(100)
        createAllZones()
    end)
end
