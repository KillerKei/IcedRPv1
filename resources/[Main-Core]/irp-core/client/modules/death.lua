Citizen.CreateThread(function()
	local isDead = false

	while true do
		Citizen.Wait(0)

		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				isDead = true

				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
				local killerServerId = NetworkGetPlayerIndexFromPed(killer)
		
				if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
				else
					PlayerKilled()
				end

			elseif not IsPedFatallyInjured(playerPed) then
				isDead = false
			end
		end
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = GetDistanceBetweenCoords(victimCoords, killerCoords, true)

	local data = {
		victimCoords = { x = irpCore.Math.Round(victimCoords.x, 1), y = irpCore.Math.Round(victimCoords.y, 1), z = irpCore.Math.Round(victimCoords.z, 1) },
		killerCoords = { x = irpCore.Math.Round(killerCoords.x, 1), y = irpCore.Math.Round(killerCoords.y, 1), z = irpCore.Math.Round(killerCoords.z, 1) },

		killedByPlayer = true,
		deathCause     = killerWeapon,
		distance       = irpCore.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('irp:onPlayerDeath', data)
	TriggerServerEvent('irp:onPlayerDeath', data)
end

function PlayerKilled()
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())

	local data = {
		victimCoords = { x = irpCore.Math.Round(victimCoords.x, 1), y = irpCore.Math.Round(victimCoords.y, 1), z = irpCore.Math.Round(victimCoords.z, 1) },

		killedByPlayer = false,
		deathCause     = GetPedCauseOfDeath(playerPed)
	}

	TriggerEvent('irp:onPlayerDeath', data)
	TriggerServerEvent('irp:onPlayerDeath', data)
end