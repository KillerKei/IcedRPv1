irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj)
	irpCore = obj
end)

RegisterServerEvent('chickenpayment:pay')
AddEventHandler('chickenpayment:pay', function()
local _source = source
local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.addMoney(math.random(85,100))
end)