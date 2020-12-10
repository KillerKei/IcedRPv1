rep = 0
RegisterServerEvent('irp-jailtask:idiot')
AddEventHandler('irp-jailtask:idiot', function()
    local _source = source
    print('ID : ', _source, 'This Idiot Tried To Abuse A Bug')
end)

RegisterServerEvent('irp-jailtask:receptionist')
AddEventHandler('irp-jailtask:receptionist', function()
    local _source = source
    TriggerClientEvent('player:receiveItem', _source, "ppapers", math.random(1,2))
end)

RegisterServerEvent('irp-jailtask:removehehe')
AddEventHandler('irp-jailtask:removehehe', function()
    TriggerClientEvent("inventory:removeItem",source, "ppapers", 1)
    rep = rep +25
    TriggerClientEvent('DoLongHudText', source, 'Thanks! Here\'s +25 Reputation. Reputation is Currently: ' ..rep)
    if rep == 800 then
        TriggerClientEvent('irp-jail:unJailPlayer', source)
    end
end)
