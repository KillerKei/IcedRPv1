irpCore = nil

cooldownglobalnew = 0

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)


-- RegisterServerEvent('irp-cartheft:payout')
-- AddEventHandler('irp-cartheft:payout', function()
--     local _source = source
--     local rnd = math.random(1,4)
--     if rnd == 4 then
--         TriggerClientEvent('player:receiveItem', _source,'bandage', math.random(1,3))
--     end
--     TriggerClientEvent('player:receiveItem', _source,'MedicalBag', math.random(1,4))
-- end)

RegisterServerEvent('irp-cartheft:reward')
AddEventHandler('irp-cartheft:reward', function()
	local _source = source
	local xPlayer = irpCore.GetPlayerFromId(_source)
    local payout = math.random(12500,15000)
    xPlayer.addMoney(tonumber(payout))
    TriggerClientEvent('DoLongHudText', _source, 'You received $'.. payout ..' from this job!', 1)
    Citizen.Wait(2000)
    TriggerClientEvent('DoLongHudText', _source, 'Have fun, come back later.. Maybe!', 1)
end)

RegisterServerEvent('irp-cartheft:checkcooldown')
AddEventHandler('irp-cartheft:checkcooldown', function(timer)
    cooldownglobal = os.time()
    local cooldownglobalnew = cooldownglobal
    timer = (os.time() - timer)
    if timer > 30000 then
        TriggerClientEvent('irp-cartheft:task1')
    else
        TriggerClientEvent('DoLongHudText', _source, 'Please Come back in 30 minutes')
    end
end)
        

RegisterServerEvent('irp-cartheft:price')
AddEventHandler('irp-cartheft:price', function()
	local _source = source
	local xPlayer = irpCore.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= 2000 then
        xPlayer.removeMoney(2000)
        price = true
        TriggerClientEvent('irp-cartheft:spawnveh', _source)
    else
        TriggerClientEvent('DoLongHudText', _source, 'You need $2,000 to start this mission', 1)
        price = false
    end
end)

