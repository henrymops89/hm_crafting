-- ====================================
-- HENRY CRAFTING - FRAMEWORK BRIDGE
-- Supports: QBCore, QBox, ESX
-- ====================================

Framework = {}
Framework.Name = nil
Framework.Object = nil

-- ====================================
-- FRAMEWORK DETECTION
-- ====================================

local function detectFramework()
    if GetResourceState('qbx_core') == 'started' then
        Framework.Name = 'QBox'
        print('[Henry Crafting] Framework detected: QBox')
        return true
    elseif GetResourceState('qb-core') == 'started' then
        Framework.Name = 'QBCore'
        Framework.Object = exports['qb-core']:GetCoreObject()
        print('[Henry Crafting] Framework detected: QBCore')
        return true
    elseif GetResourceState('es_extended') == 'started' then
        Framework.Name = 'ESX'
        Framework.Object = exports['es_extended']:getSharedObject()
        print('[Henry Crafting] Framework detected: ESX')
        return true
    end
    
    print('[Henry Crafting] ^1ERROR: No supported framework found!^0')
    return false
end

CreateThread(function()
    detectFramework()
end)

-- ====================================
-- SERVER-SIDE FUNCTIONS
-- ====================================

if IsDuplicityVersion() then
    
    -- Get Player Object
    function Framework.GetPlayer(source)
        if Framework.Name == 'QBox' then
            return exports.qbx_core:GetPlayer(source)
        elseif Framework.Name == 'QBCore' then
            return Framework.Object.Functions.GetPlayer(source)
        elseif Framework.Name == 'ESX' then
            return Framework.Object.GetPlayerFromId(source)
        end
        return nil
    end
    
    -- Get Player Identifier
    function Framework.GetIdentifier(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return nil end
        
        if Framework.Name == 'QBox' or Framework.Name == 'QBCore' then
            return Player.PlayerData.citizenid
        elseif Framework.Name == 'ESX' then
            return Player.identifier
        end
        return nil
    end
    
    -- Get Player Name
    function Framework.GetPlayerName(source)
        local Player = Framework.GetPlayer(source)
        if not Player then return 'Unknown' end
        
        if Framework.Name == 'QBox' or Framework.Name == 'QBCore' then
            local charinfo = Player.PlayerData.charinfo
            return charinfo.firstname .. ' ' .. charinfo.lastname
        elseif Framework.Name == 'ESX' then
            return Player.getName()
        end
        return 'Unknown'
    end
    
    -- Get Money
    function Framework.GetMoney(source, moneyType)
        local Player = Framework.GetPlayer(source)
        if not Player then return 0 end
        
        if Framework.Name == 'QBox' then
            return exports.qbx_core:GetMoney(source, moneyType)
        elseif Framework.Name == 'QBCore' then
            return Player.Functions.GetMoney(moneyType)
        elseif Framework.Name == 'ESX' then
            local accountType = moneyType == 'cash' and 'money' or moneyType
            return Player.getAccount(accountType).money
        end
        return 0
    end
    
    -- Remove Money
    function Framework.RemoveMoney(source, moneyType, amount, reason)
        local Player = Framework.GetPlayer(source)
        if not Player then return false end
        
        if Framework.Name == 'QBox' then
            return exports.qbx_core:RemoveMoney(source, moneyType, amount, reason)
        elseif Framework.Name == 'QBCore' then
            return Player.Functions.RemoveMoney(moneyType, amount, reason)
        elseif Framework.Name == 'ESX' then
            local accountType = moneyType == 'cash' and 'money' or moneyType
            Player.removeAccountMoney(accountType, amount)
            return true
        end
        return false
    end
    
    -- Add Money
    function Framework.AddMoney(source, moneyType, amount, reason)
        local Player = Framework.GetPlayer(source)
        if not Player then return false end
        
        if Framework.Name == 'QBox' then
            return exports.qbx_core:AddMoney(source, moneyType, amount, reason)
        elseif Framework.Name == 'QBCore' then
            Player.Functions.AddMoney(moneyType, amount, reason)
            return true
        elseif Framework.Name == 'ESX' then
            local accountType = moneyType == 'cash' and 'money' or moneyType
            Player.addAccountMoney(accountType, amount)
            return true
        end
        return false
    end
    
    -- Notify Player
    function Framework.Notify(source, message, type, duration)
        if GetResourceState('ox_lib') == 'started' then
            TriggerClientEvent('ox_lib:notify', source, {
                description = message,
                type = type or 'info',
                duration = duration or 5000
            })
        else
            if Framework.Name == 'QBox' then
                exports.qbx_core:Notify(source, message, type or 'info')
            elseif Framework.Name == 'QBCore' then
                TriggerClientEvent('QBCore:Notify', source, message, type or 'primary')
            elseif Framework.Name == 'ESX' then
                TriggerClientEvent('esx:showNotification', source, message)
            end
        end
    end

-- ====================================
-- CLIENT-SIDE FUNCTIONS
-- ====================================

else
    
    -- Get Player Data
    function Framework.GetPlayerData()
        if Framework.Name == 'QBox' then
            local QBX = require '@qbx_core/modules/playerdata'
            return QBX.PlayerData
        elseif Framework.Name == 'QBCore' then
            return Framework.Object.Functions.GetPlayerData()
        elseif Framework.Name == 'ESX' then
            return Framework.Object.GetPlayerData()
        end
        return nil
    end
    
    -- Notify (Client)
    function Framework.Notify(message, type, duration)
        if GetResourceState('ox_lib') == 'started' then
            lib.notify({
                description = message,
                type = type or 'info',
                duration = duration or 5000
            })
        else
            if Framework.Name == 'QBox' then
                exports.qbx_core:Notify(message, type or 'info')
            elseif Framework.Name == 'QBCore' then
                Framework.Object.Functions.Notify(message, type or 'primary')
            elseif Framework.Name == 'ESX' then
                Framework.Object.ShowNotification(message)
            end
        end
    end

end
