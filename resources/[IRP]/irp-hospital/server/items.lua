irpCore               = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

----
irpCore.RegisterUsableItem('gauze', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gauze', 1)

	TriggerClientEvent('irp-hospital:items:gauze', source)
end)

irpCore.RegisterUsableItem('bandaids', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandaids', 1)

	TriggerClientEvent('irp-hospital:items:bandage', source)
end)

irpCore.RegisterUsableItem('firstaid', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firstaid', 1)

	TriggerClientEvent('irp-hospital:items:firstaid', source)
end)

irpCore.RegisterUsableItem('vicodin', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vicodin', 1)

	TriggerClientEvent('irp-hospital:items:vicodin', source)
end)

irpCore.RegisterUsableItem('ifak', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ifak', 1)

	TriggerClientEvent('irp-hospital:items:ifak', source)
end)

irpCore.RegisterUsableItem('hydrocodone', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hydrocodone', 1)

	TriggerClientEvent('irp-hospital:items:hydrocodone', source)
end)

irpCore.RegisterUsableItem('morphine', function(source)
	local xPlayer = irpCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)

	TriggerClientEvent('irp-hospital:items:morphine', source)
end)
