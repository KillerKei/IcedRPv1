irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('irp:huntingreturnree')
AddEventHandler('irp:huntingreturnree', function()
local source = source
local xPlayer  = irpCore.GetPlayerFromId(source)
    xPlayer.addMoney(500)
end)

RegisterServerEvent('irp:huntingdeposit')
AddEventHandler('irp:huntingdeposit', function()
local source = source
local xPlayer  = irpCore.GetPlayerFromId(source)
    xPlayer.removeMoney(1000)
end)

RegisterServerEvent('irp-hunting:sell')
AddEventHandler('irp-hunting:sell', function()
local source = source
local xPlayer  = irpCore.GetPlayerFromId(source)
local randompayout = math.random(70, 90)
    xPlayer.addMoney(randompayout)
end)

RegisterServerEvent('irp-hunting:giveloadout')
AddEventHandler('irp-hunting:giveloadout', function()
    TriggerClientEvent('player:receiveItem', source, '100416529', 1)
end)

RegisterServerEvent('irp-hunting:removeloadout')
AddEventHandler('irp-hunting:removeloadout', function()
    TriggerClientEvent('inventory:removeItem', source, '100416529', 1)
end)