irpCore = nil
TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

local deadPeds = {}

RegisterServerEvent('irp-storerobbery:pedDead')
AddEventHandler('irp-storerobbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('irp-storerobbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('irp-storerobbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('irp-storerobbery:handsUp')
AddEventHandler('irp-storerobbery:handsUp', function(store)
    TriggerClientEvent('irp-storerobbery:handsUp', -1, store)
end)

RegisterServerEvent('irp-storerobbery:pickUp')
AddEventHandler('irp-storerobbery:pickUp', function(store)
    local xPlayer = irpCore.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('DoLongHudText', source, 'You got: $' .. randomAmount, 2) 
    TriggerClientEvent('irp-storerobbery:removePickup', -1, store) 
end)

irpCore.RegisterServerCallback('irp-storerobbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = irpCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = irpCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= Config.Shops[store].cops then
        if not Config.Shops[store].robbed and not deadPeds[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('irp-storerobbery:notif')
AddEventHandler('irp-storerobbery:notif', function(store)
    local src = source
    local xPlayers = irpCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = irpCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('irp-storerobbery:msgPolice', src, store)
            return
        end
    end
end)

RegisterServerEvent('irp-storerobbery:rob')
AddEventHandler('irp-storerobbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    TriggerClientEvent('irp-storerobbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('irp-storerobbery:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('irp-storerobbery:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('irp-storerobbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)
