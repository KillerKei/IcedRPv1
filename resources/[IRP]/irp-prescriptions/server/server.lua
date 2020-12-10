irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)


RegisterServerEvent('irp-prescriptions:payout')
AddEventHandler('irp-prescriptions:payout', function()
    local _source = source
    local rnd = math.random(1,4)
    if rnd == 4 then
        TriggerClientEvent('player:receiveItem', _source,'bandage', math.random(1,3))
    end
    TriggerClientEvent('player:receiveItem', _source,'MedicalBag', math.random(1,4))
end)

RegisterServerEvent('irp-prescriptions:pay')
AddEventHandler('irp-prescriptions:pay', function(price)
	local _source = source
	local xPlayer = irpCore.GetPlayerFromId(_source)
	local payamount = 50
	local payout = math.random(2,4)
    xPlayer.addMoney(tonumber(price))
    TriggerClientEvent('DoLongHudText', _source, 'You received $'.. price ..' from this stop!', 1)
end)

