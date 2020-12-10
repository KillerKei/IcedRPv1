irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('irp-uberkdshfksksdhfskdjjob:pay')
AddEventHandler('irp-uberkdshfksksdhfskdjjob:pay', function(amount)
	local _source = source
	local xPlayer = irpCore.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
	TriggerClientEvent('chatMessagess', _source, '', 4, 'You got payed $' .. amount)
end)
