-- Client

irpCore               = nil

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("irp-givecarkeys:keys")
AddEventHandler("irp-givecarkeys:keys", function()

giveCarKeys()

end)

function giveCarKeys()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = irpCore.Game.GetVehicleProperties(vehicle)


	irpCore.TriggerServerCallback('irp-givecarkeys:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then

		local closestPlayer, closestDistance = irpCore.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then
	TriggerEvent('DoLongHudText', 'No players nearby!', 2)
else
	TriggerEvent('DoLongHudText', 'You are giving your car keys for vehicle with plate '..vehicleProps.plate..'!', 1)
	TriggerServerEvent('irp-givecarkeys:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
end

		end
	end, GetVehicleNumberPlateText(vehicle))
end
