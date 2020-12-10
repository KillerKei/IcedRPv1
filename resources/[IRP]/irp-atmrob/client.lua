-------------------------------------
------- Created by Hamza#1234 -------
------------------------------------- 

irpCore = nil
local timing, isPlayerWhitelisted = math.ceil(1 * 60000), false

local Device
local copsOnline
local RobbingATM = false
local HackingATM = false

local streetName
local _

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
	while irpCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = irpCore.GetPlayerData()
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('irp:playerLoaded')
AddEventHandler('irp:playerLoaded', function(xPlayer)
	irpCore.PlayerData = xPlayer
end)

RegisterNetEvent('irp:setJob')
AddEventHandler('irp:setJob', function(job)
	irpCore.PlayerData.job = job
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

-- Outlaw message:
RegisterNetEvent('irp_atmRobbery:outlawNotify')
AddEventHandler('irp_atmRobbery:outlawNotify', function(alert)
	if isPlayerWhitelisted then
		TriggerEvent('chat:addMessage', { args = { "^5 Dispatch: " .. alert }})
	end
end)

-- Refresh police online:
function refreshPlayerWhitelisted()	
	if not irpCore.PlayerData then
		return false
	end

	if not irpCore.PlayerData.job then
		return false
	end

	if Config.PoliceDatabaseName == irpCore.PlayerData.job.name then
		return true
	end

	return false
end

-- Core Thread Function:
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(7)	
		local pos = GetEntityCoords(PlayerPedId())
		if not RobbingATM then
			if not HackingATM then
				for k,v in pairs(Config.ATMs) do
					if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.x, v.y, v.z, true) <= 1.5 then
						-- DrawText3Ds(v.x,v.y,v.z, "Press ~g~[G]~s~ to ~r~Rob~s~ the ~y~ATM~s~")
						if IsControlJustPressed(0, 47) then
							startRobbingATM()					
							break;	
						end
					end
				end
			end
		end	
	end
end)

-- Starting ATM Robbery:
function startRobbingATM()
	irpCore.TriggerServerCallback("irp_atmRobbery:isRobbingPossible", function(cooldownATM)
		if not cooldownATM then
			irpCore.TriggerServerCallback('irp_atmRobbery:getOnlinePoliceCount', function(policeCount)
				if policeCount then
					local lol = 1
					if exports['irp-inventory']:hasEnoughOfItem('usbdevice', 1) then
						local luck = math.random(1,3)
						if luck == 3 then
							TriggerEvent("inventory:removeItem", "usbdevice", 1)
							TriggerEvent("DoLongHudText","You have fried your USB!",2)
						end
						if luck ~= 3 then
							RobbingATM = true
							TriggerServerEvent("irp_atmRobbery:CooldownATM")
							FreezeEntityPosition(player,true)
							local player = PlayerPedId()
							local playerPos = GetEntityCoords(player)
								
							-- animation 1:
							local animDict = "random@atmrobberygen@male"
							local animName = "idle_a"
							
							RequestAnimDict(animDict)
							while not HasAnimDictLoaded(animDict) do
								Citizen.Wait(0)
							end
							if Config.PoliceNotfiyEnabled == true then
								TriggerServerEvent('irp_atmRobbery:PoliceNotify',playerPos,streetName)
							end
							exports["irp-taskbar"]:taskBar(20000,"Connecting Device",false,false)
							-- exports['progressBars']:startUI(12000, "CONNECTING DEVICE")
							Citizen.Wait(100)
							TaskPlayAnim(player,animDict,animName,3.0,0.5,-1,31,1.0,0,0)
							TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
							TriggerEvent("mhacking:show")
							TriggerEvent("mhacking:start",4,40,hackingEvent)
							HackingATM = true
						else
							RobbingATM = false
						end
					else
						TriggerEvent("DoLongHudText","Come Back With a USB Device",2)
					end
				else
					RobbingATM = false
				end
			end)
		else
			RobbingATM = false
		end
	end)
end


-- Hacking Event:
function hackingEvent(success)
	local player = PlayerPedId()
    FreezeEntityPosition(player,false)
    TriggerEvent('mhacking:hide')
	if success then
		local finished = exports["irp-taskbarskill"]:taskBar(math.random(1000,1500),math.random(15,20))
		if finished == 100 then
			TriggerServerEvent("irp_atmRobbery:success")	
		else
			print("COME BACK LATER")
		end
		TriggerEvent("DoLongHudText","You Successfully Hacked he ATM",2)
        -- irpCore.ShowNotification("You ~g~successfully~s~ hacked the ~y~ATM~s~")
	else
		TriggerEvent("DoLongHudText","You Failed To Hack The ATM",2)
		-- irpCore.ShowNotification("You ~r~failed~s~ to hack the ~y~ATM~s~!")
	end
	ClearPedTasks(player)
	ClearPedSecondaryTask(player)	
	RobbingATM = false
	HackingATM = false
end

-- Poliec Alert:
RegisterNetEvent('irp_atmRobbery:OutlawBlipSettings')
AddEventHandler('irp_atmRobbery:OutlawBlipSettings', function(targetCoords)
	if isPlayerWhitelisted and Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)

		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)

			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- Draw 3D text Function:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

