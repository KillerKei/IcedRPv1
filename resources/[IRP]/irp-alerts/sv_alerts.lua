RegisterServerEvent("irp-alerts:teenA")
AddEventHandler("irp-alerts:teenA",function(targetCoords)
    TriggerClientEvent('irp-alerts:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:teenB")
AddEventHandler("irp-alerts:teenB",function(targetCoords)
    TriggerClientEvent('irp-alerts:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:teenpanic")
AddEventHandler("irp-alerts:teenpanic",function(targetCoords)
    TriggerClientEvent('irp-alerts:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:fourA")
AddEventHandler("irp-alerts:fourA",function(targetCoords)
    TriggerClientEvent('irp-alerts:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:fourB")
AddEventHandler("irp-alerts:fourB",function(targetCoords)
    TriggerClientEvent('irp-alerts:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:downperson")
AddEventHandler("irp-alerts:downperson",function(targetCoords)
    TriggerClientEvent('irp-alerts:downalert', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:assistancen")
AddEventHandler("irp-alerts:assistancen",function(targetCoords)
    TriggerClientEvent('irp-alerts:assistance', -1, targetCoords)
	return
end)


RegisterServerEvent("irp-alerts:sveh")
AddEventHandler("irp-alerts:sveh",function(targetCoords)
    TriggerClientEvent('irp-alerts:vehiclesteal', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:shoot")
AddEventHandler("irp-alerts:shoot",function(targetCoords)
    TriggerClientEvent('irp-outlawalert:gunshotInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:figher")
AddEventHandler("irp-alerts:figher",function(targetCoords)
    TriggerClientEvent('irp-outlawalert:combatInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:storerob")
AddEventHandler("irp-alerts:storerob",function(targetCoords)
    TriggerClientEvent('irp-alerts:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:houserob")
AddEventHandler("irp-alerts:houserob",function(targetCoords)
    TriggerClientEvent('irp-alerts:houserobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:tbank")
AddEventHandler("irp-alerts:tbank",function(targetCoords)
    TriggerClientEvent('irp-alerts:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("irp-alerts:robjew")
AddEventHandler("irp-alerts:robjew",function()
    TriggerClientEvent('irp-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("irp-alerts:bjail")
AddEventHandler("irp-alerts:bjail",function()
    TriggerClientEvent('irp-alerts:jewelrobbey', -1)
	return
end)