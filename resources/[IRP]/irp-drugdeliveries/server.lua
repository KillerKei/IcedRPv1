irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('drugdelivery:server')
AddEventHandler('drugdelivery:server', function()
    local source = source
    local xPlayer = irpCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= 100 then
        xPlayer.removeMoney(100)
        TriggerClientEvent('drugdelivery:startDealing', source)
        TriggerClientEvent('drugdelivery:client', source)
    else
        TriggerClientEvent('DoLongHudText', source, 'You do not have enough money to start!', 2)
    end
end)

RegisterServerEvent('oxydelivery:server')
AddEventHandler('oxydelivery:server', function(money)
    local source = source
    local xPlayer = irpCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        TriggerClientEvent('oxydelivery:startDealing', source)
        TriggerClientEvent('oxydelivery:client', source)
    else
        TriggerClientEvent('DoLongHudText', source, 'You do not have enough money to start!', 2)
    end
end)

RegisterServerEvent('delmission:completed')
AddEventHandler('delmission:completed', function(money)
    local source = source
    local xPlayer  = irpCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)