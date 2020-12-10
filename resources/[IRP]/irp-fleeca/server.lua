irpCore = nil
TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
cooldownglobal = 0

RegisterServerEvent("irp-fleeca:startcheck")
AddEventHandler("irp-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = irpCore.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = irpCore.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    local xPlayer = irpCore.GetPlayerFromId(_source)

    if copcount >= fleeca.mincops then
        if not globalonaction == true then
            local cooldownglobalnew = cooldownglobal
            if (os.time() - fleeca.cooldown) > cooldownglobalnew then
                globalonaction = true
                TriggerClientEvent('inventory:removeItem', _source, 'thermite', 1)
                TriggerClientEvent("irp-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("irp-fleeca:policenotify", -1, bank)
                    return
                else
                    TriggerClientEvent("irp-fleeca:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((fleeca.cooldown - (os.time() - cooldownglobal)) / 60)..":"..math.fmod((fleeca.cooldown - (os.time() - cooldownglobal)), 60))
                end
            else
            TriggerClientEvent("irp-fleeca:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("irp-fleeca:outcome", _source, false, "There is not enough police in the city.")
    end
end)

RegisterServerEvent("irp-fleeca:lootup")
AddEventHandler("irp-fleeca:lootup", function(var, var2)
    TriggerClientEvent("irp-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("irp-fleeca:openDoor")
AddEventHandler("irp-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("irp-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("irp-fleeca:startLoot")
AddEventHandler("irp-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("irp-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("irp-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("irp-fleeca:stopHeist")
AddEventHandler("irp-fleeca:stopHeist", function(name)
    TriggerClientEvent("irp-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("irp-fleeca:rewardCash")
AddEventHandler("irp-fleeca:rewardCash", function()
    local xPlayer = irpCore.GetPlayerFromId(source)
    local reward = math.random(1, 2)
    local mathfunc = math.random(200)
    local payout = math.random(2,4)
    if mathfunc == 15 then
      TriggerClientEvent('player:receiveItem', source, 'goldbar', payout)
    end
    TriggerClientEvent("player:receiveItem", source, "band", reward)
end)

RegisterServerEvent("irp-fleeca:setCooldown")
AddEventHandler("irp-fleeca:setCooldown", function(name)
    cooldownglobal = os.time()
    globalonaction = false
    -- fleeca.Banks[name].onaction = false
    TriggerClientEvent("irp-fleeca:resetDoorState", -1, name)
end)

irpCore.RegisterServerCallback("irp-fleeca:getBanks", function(source, cb)
    cb(fleeca.Banks)
end)