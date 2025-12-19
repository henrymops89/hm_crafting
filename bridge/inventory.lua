-- ====================================
-- HENRY CRAFTING - INVENTORY BRIDGE
-- Supports: qb-inventory, ox_inventory
-- ====================================

Inventory = {}
Inventory.Name = nil

-- ====================================
-- INVENTORY DETECTION
-- ====================================

local function detectInventory()
    if GetResourceState('ox_inventory') == 'started' then
        Inventory.Name = 'ox_inventory'
        print('[Henry Crafting] Inventory detected: ox_inventory')
        return true
    elseif GetResourceState('qb-inventory') == 'started' then
        Inventory.Name = 'qb-inventory'
        print('[Henry Crafting] Inventory detected: qb-inventory')
        return true
    elseif GetResourceState('qs-inventory') == 'started' then
        Inventory.Name = 'qs-inventory'
        print('[Henry Crafting] Inventory detected: qs-inventory')
        return true
    end
    
    print('[Henry Crafting] ^1ERROR: No supported inventory found!^0')
    return false
end

CreateThread(function()
    detectInventory()
end)

-- ====================================
-- SERVER-SIDE FUNCTIONS
-- ====================================

if IsDuplicityVersion() then
    
    -- Get Item Count
    function Inventory.GetItemCount(source, itemName)
        if Inventory.Name == 'ox_inventory' then
            return exports.ox_inventory:GetItemCount(source, itemName)
        elseif Inventory.Name == 'qb-inventory' or Inventory.Name == 'qs-inventory' then
            local Player = Framework.GetPlayer(source)
            if not Player then return 0 end
            
            local item = Player.Functions.GetItemByName(itemName)
            return item and item.amount or 0
        end
        return 0
    end
    
    -- Has Item
    function Inventory.HasItem(source, itemName, amount)
        amount = amount or 1
        return Inventory.GetItemCount(source, itemName) >= amount
    end
    
    -- Add Item
    function Inventory.AddItem(source, itemName, amount, metadata)
        amount = amount or 1
        
        if Inventory.Name == 'ox_inventory' then
            return exports.ox_inventory:AddItem(source, itemName, amount, metadata)
        elseif Inventory.Name == 'qb-inventory' or Inventory.Name == 'qs-inventory' then
            local Player = Framework.GetPlayer(source)
            if not Player then return false end
            
            return Player.Functions.AddItem(itemName, amount, false, metadata)
        end
        return false
    end
    
    -- Remove Item
    function Inventory.RemoveItem(source, itemName, amount, metadata)
        amount = amount or 1
        
        if Inventory.Name == 'ox_inventory' then
            return exports.ox_inventory:RemoveItem(source, itemName, amount, metadata)
        elseif Inventory.Name == 'qb-inventory' or Inventory.Name == 'qs-inventory' then
            local Player = Framework.GetPlayer(source)
            if not Player then return false end
            
            return Player.Functions.RemoveItem(itemName, amount)
        end
        return false
    end
    
    -- Can Carry Item
    function Inventory.CanCarryItem(source, itemName, amount)
        amount = amount or 1
        
        if Inventory.Name == 'ox_inventory' then
            return exports.ox_inventory:CanCarryItem(source, itemName, amount)
        elseif Inventory.Name == 'qb-inventory' or Inventory.Name == 'qs-inventory' then
            local Player = Framework.GetPlayer(source)
            if not Player then return false end
            
            -- Simple weight check (kann erweitert werden)
            local item = Player.Functions.GetItemByName(itemName)
            return true -- Vereinfachte Version
        end
        return false
    end
    
    -- Get Item
    function Inventory.GetItem(source, itemName)
        if Inventory.Name == 'ox_inventory' then
            return exports.ox_inventory:GetItem(source, itemName)
        elseif Inventory.Name == 'qb-inventory' or Inventory.Name == 'qs-inventory' then
            local Player = Framework.GetPlayer(source)
            if not Player then return nil end
            
            return Player.Functions.GetItemByName(itemName)
        end
        return nil
    end

end
