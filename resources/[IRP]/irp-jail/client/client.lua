local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

irpCore = nil

PlayerData = {}

local jailTime = 0

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end

	while irpCore.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = irpCore.GetPlayerData()

	LoadTeleporters()
end)

RegisterNetEvent("irp:playerLoaded")
AddEventHandler("irp:playerLoaded", function(newData)
	PlayerData = newData

	Citizen.Wait(25000)

	irpCore.TriggerServerCallback("irp-jail:retrieveTime", function(inJail, newJailTime)
		if inJail then

			jailTime = newJailTime

			JailLogin()
		end
	end)
end)

RegisterNetEvent("irp:setJob")
AddEventHandler("irp:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("irp-jail:openJailMenu")
AddEventHandler("irp-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("irp-jail:dumbAss")
AddEventHandler("irp-jail:dumbAss", function(newJailTime)
	jailTime = newJailTime

	Cutscene()
end)

RegisterNetEvent("irp-jail:unJailPlayer")
AddEventHandler("irp-jail:unJailPlayer", function()
	jailTime = 0

	UnJail()
end)

function JailLogin()
	Cutscene()

	TriggerEvent('DoLongHudText', 'You were jailed previously, you are now back', 1)
end

function UnJail()
	InJail()

	irpCore.Game.Teleport(PlayerPedId(), vector4(1858.23, 2606.11, 45.67, 96.83))

	irpCore.TriggerServerCallback('irp-skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	TriggerEvent('DoLongHudText', "You are released, stay calm outside! Good LucK!", 1)
end

RegisterNetEvent('irp-jailbreak:UpdateTime')
AddEventHandler('irp-jailbreak:UpdateTime', function()
	jailTime = 0
	TriggerServerEvent("irp-jail:updateJailTime", 0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if jailTime > 0 then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), 1858.23, 2606.11, 45.67, true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), 402.91567993164, -996.75970458984, -99.000259399414, true)
			if distance > 1000 then
				if distance2 > 1000 then
					TriggerEvent('irp-jailbreak:UpdateTime')
				end
			end
		end
	end
end)

function InJail()

	--Jail Timer--

	Citizen.CreateThread(function()

		while jailTime > 0 do

			jailTime = jailTime - 1

			TriggerEvent('chat:addMessage', {template = '<div class="chat-message jail"><b> {0}</b> {1}</div>', args = { "DOC | : ",  "You have " .. jailTime .. " months remaining" } })

			TriggerServerEvent("irp-jail:updateJailTime", jailTime)

			if jailTime == 0 then
				UnJail()

				TriggerServerEvent("irp-jail:updateJailTime", 0)
			end

			Citizen.Wait(60000)
		end

	end)
end

	--Jail Timer--


function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do
			
			local sleepThread = 500

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do

				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 7.5 then

					sleepThread = 5

					irpCore.Game.Utils.DrawText3D(v, "[E] Open Door", 0.4)

					if DistanceCheck <= 1.0 then
						if IsControlJustPressed(0, 38) then
							TeleportPlayer(v)
						end
					end
				end
			end

			Citizen.Wait(sleepThread)

		end
	end)
end

function PackPackage(packageId)
	local Package = Config.PrisonWork["Packages"][packageId]

	LoadModel("prop_cs_cardbox_01")

	local PackageObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), Package["x"], Package["y"], Package["z"], true)

	PlaceObjectOnGroundProperly(PackageObject)

	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, false)

	local Packaging = true
	local StartTime = GetGameTimer()

	while Packaging do
		
		Citizen.Wait(1)

		local TimeToTake = 60000 * 1.20 -- Minutes
		local PackPercent = (GetGameTimer() - StartTime) / TimeToTake * 100

		if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_BUM_BIN") then
			DeleteEntity(PackageObject)

			TriggerEvent('DoLongHudText', "Canceled!", 1)

			Packaging = false
		end

		if PackPercent >= 100 then

			Packaging = false

			DeliverPackage(PackageObject)

			Package["state"] = false
		else
			irpCore.Game.Utils.DrawText3D(Package, "Packaging... " .. math.ceil(tonumber(PackPercent)) .. "%", 0.4)
		end
		
	end
end

function DeliverPackage(packageId)
	if DoesEntityExist(packageId) then
		AttachEntityToEntity(packageId, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)

		ClearPedTasks(PlayerPedId())
	else
		return
	end

	local Packaging = true

	LoadAnim("anim@heists@box_carry@")

	while Packaging do

		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
			TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if not IsEntityAttachedToEntity(packageId, PlayerPedId()) then
			Packaging = false
			DeleteEntity(packageId)
		else
			local DeliverPosition = Config.PrisonWork["DeliverPackage"]
			local PedPosition = GetEntityCoords(PlayerPedId())
			local DistanceCheck = GetDistanceBetweenCoords(PedPosition, DeliverPosition["x"], DeliverPosition["y"], DeliverPosition["z"], true)

			irpCore.Game.Utils.DrawText3D(DeliverPosition, "[E] Leave Package", 0.4)

			if DistanceCheck <= 2.0 then
				if IsControlJustPressed(0, 38) then
					DeleteEntity(packageId)
					ClearPedTasksImmediately(PlayerPedId())
					Packaging = false

					TriggerServerEvent("irp-jail:prisonWorkReward")
				end
			end
		end

	end

end

function OpenJailMenu()
	irpCore.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Prison Menu",
			align    = 'center',
			elements = {
				{ label = "Jail Closest Person", value = "jail_closest_player" },
				{ label = "Unjail Person", value = "unjail_player" }
			}
		}, 
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			irpCore.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Jail Time (minutes)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
					TriggerEvent('DoLongHudText', "The time needs to be in minutes!", 2)
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = irpCore.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		TriggerEvent('DoLongHudText', "No players nearby!", 2)
					else
						irpCore.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Jail Reason"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								TriggerEvent('DoLongHudText', "You need to put something here!", 2)
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = irpCore.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
									TriggerEvent('DoLongHudText', "No players nearby!", 2)
								else
								  	TriggerServerEvent("irp-jail:dumbAss", GetPlayerServerId(closestPlayer), jailTime, reason)
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			irpCore.TriggerServerCallback("irp-jail:retrievePrisoner", function(playerArray)

				if #playerArray == 0 then
					TriggerEvent('DoLongHudText', "Your jail is empty!", 1)
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Prisoner: " .. playerArray[i].name .. " | Jail Time: " .. playerArray[i].jailTime .. " minutes", value = playerArray[i].identifier })
				end

				irpCore.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Unjail Player",
						align = "center",
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("irp-jail:unJailPlayer", action)

					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function(data, menu)
		menu.close()
	end)	
end

