irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('irp-fish:payShit')
AddEventHandler('irp-fish:payShit', function(money)
    local source = source
    local xPlayer  = irpCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)

RegisterServerEvent('fish:checkAndTakeDepo')
AddEventHandler('fish:checkAndTakeDepo', function()
local source = source
local xPlayer  = irpCore.GetPlayerFromId(source)
    xPlayer.removeMoney(500)
end)

RegisterServerEvent('fish:returnDepo')
AddEventHandler('fish:returnDepo', function()
local source = source
local xPlayer  = irpCore.GetPlayerFromId(source)
    xPlayer.addMoney(500)
end)

RegisterServerEvent('irp-fish:getFish')
AddEventHandler('irp-fish:getFish', function()
local source = source
    local roll = math.random(1,8)
    if roll == 1 then
        TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,3))
    end
    if roll == 2 then
        TriggerClientEvent('player:receiveItem', source, 'plastic', math.random(1,3))
    end
    if roll == 3 then
        TriggerClientEvent('player:receiveItem', source, 'aluminium', math.random(1,5))
    end
    if roll == 4 then
        TriggerClientEvent('player:receiveItem', source, '1gcocaine', math.random(1,2))
    end
    if roll == 5 then
        TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,3))
    end
    if roll == 6 then
        TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,3))
    end
    if roll == 7 then
        TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,3))
    end
    if roll == 8 then
        TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,3))
    end
end)