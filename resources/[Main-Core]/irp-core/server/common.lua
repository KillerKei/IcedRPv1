irpCore                      = {}
irpCore.Players              = {}
irpCore.UsableItemsCallbacks = {}
irpCore.Items                = {}
irpCore.ServerCallbacks      = {}
irpCore.TimeoutCount         = -1
irpCore.CancelledTimeouts    = {}
irpCore.LastPlayerData       = {}
irpCore.Pickups              = {}
irpCore.PickupId             = 0
irpCore.Jobs                 = {}

AddEventHandler('irp:getSharedObject', function(cb)
	cb(irpCore)
end)

function getSharedObject()
	return irpCore
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			irpCore.Items[result[i].name] = {
				label     = result[i].label,
				limit     = result[i].limit,
				rare      = (result[i].rare       == 1 and true or false),
				canRemove = (result[i].can_remove == 1 and true or false),
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		irpCore.Jobs[result[i].name] = result[i]
		irpCore.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if irpCore.Jobs[result2[i].job_name] then
			irpCore.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('irp-core: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(irpCore.Jobs) do
		if next(v.grades) == nil then
			irpCore.Jobs[v.name] = nil
			print(('irp-core: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)

AddEventHandler('irp:playerLoaded', function(source)
	local xPlayer         = irpCore.GetPlayerFromId(source)
	local accounts        = {}
	local items           = {}
	local xPlayerAccounts = xPlayer.getAccounts()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	irpCore.LastPlayerData[source] = {
		accounts = accounts,
		items    = items
	}
end)

RegisterServerEvent('irp:clientLog')
AddEventHandler('irp:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterServerEvent('irp:triggerServerCallback')
AddEventHandler('irp:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	irpCore.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('irp:serverCallback', _source, requestId, ...)
	end, ...)
end)
