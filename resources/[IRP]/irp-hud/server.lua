GRPCore = nil

TriggerEvent('grp:getSharedObject', function(obj) GRPCore = obj end)

local currentArmour = nil

RegisterNetEvent('grp-armour:RefreshCurrentArmour')
AddEventHandler('grp-armour:RefreshCurrentArmour', function(updateArmour)
   currentArmour = updateArmour
end)

AddEventHandler('grp:playerLoaded', function(playerId)
    local xPlayer = GRPCore.GetPlayerFromId(playerId)
    MySQL.Async.fetchScalar("SELECT armour FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = tostring(xPlayer.getIdentifier())
        }, function(data)
        if (data ~= nil) then
            TriggerClientEvent('grp-armour:SetPlayerArmour', playerId, data)
		end
    end)
end)

AddEventHandler('grp:playerDropped', function(playerId)
    if currentArmour ~= nil then
        local xPlayer = GRPCore.GetPlayerFromId(playerId)
        MySQL.Async.execute("UPDATE users SET armour = @armour WHERE identifier = @identifier", { 
            ['@identifier'] = tostring(xPlayer.getIdentifier()),
            ['@armour'] = tonumber(currentArmour)
		})
    end
end)