local holdingup = false
local bank = ""
local secondsRemaining = 0
local blipRobbery = nil

irpCore = nil

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)


end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_robcargo:currentlyrobbing')
AddEventHandler('esx_robcargo:currentlyrobbing', function()
	holdingup = true
	cargo = robb
	-- secondsRemaining = 30
	local rng = math.random(1, 3)
	

	if math.random(1, 3) == rng then 
		TriggerEvent('DoLongHudText', 'Your Crowbar bent out of shape!', 1)
		-- exports['mythic_notify']:DoHudText('error', 'Your Crowbar bent out of shape!')
		TriggerEvent("inventory:removeItem", "2227010557", 1)
	   end

	TriggerEvent('esx_robcargo:freezePlayer', true)
	local playerPed = GetPlayerPed(-1)

	irpCore.Streaming.RequestAnimDict('missheistfbi3b_ig7', function()
		TaskPlayAnim(playerPed, 'missheistfbi3b_ig7', 'lift_fibagent_loop', 8.0, -8, -1, 49, 0, 0, 0, 0)
		-- TriggerEvent('police:CargoRobbery')
	end)
	local player = PlayerPedId()
	local playerVeh = GetVehiclePedIsIn(player, false)
	TriggerEvent("hud-display-item","2227010557","Used")
	local finished = exports["irp-taskbar"]:taskBar(30000,"Breaking Into Cargo Truck",false,false,playerVeh)
	if (finished == 100) then
		ClearPedTasksImmediately(PlayerPedId())
		TriggerEvent('esx_robcargo:freezePlayer', false)
		local finished2 = exports["irp-taskbarskill"]:taskBar(math.random(1000,1500),math.random(15,20))
		if finished2 == 100 then
			local finished3 = exports["irp-taskbarskill"]:taskBar(math.random(1000,2500),math.random(15,20))
			if finished3 == 100 then
				TriggerServerEvent('irp_cargorobbery:success')
				TriggerEvent('esx_robcargo:robberycomplete')
			end
		else
			TriggerEvent('DoLongHudText', 'You failed to crack the door open, try again later', 1)
			TriggerEvent('esx_robcargo:robberycomplete')
		end
	end

end)



RegisterNetEvent('esx_robcargo:freezePlayer')
AddEventHandler('esx_robcargo:freezePlayer', function(freeze)
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)



RegisterNetEvent('esx_robcargo:toofarlocal')
AddEventHandler('esx_robcargo:toofarlocal', function(robb)
	holdingup = false
	irpCore.ShowNotification(_U('robbery_cancelled'))
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('esx_robcargo:robberycomplete')
AddEventHandler('esx_robcargo:robberycomplete', function()
	holdingup = false

	secondsRemaining = 0
	incircle = false
end)


RegisterCommand('check', function()

	TriggerServerEvent('esx_robcargo:checkCrow')
end)


RegisterNetEvent('esx_robcargo:getData')
AddEventHandler('esx_robcargo:getData', function(_hasCrow)
	
	local hasCrow = _hasCrow
		if hasCrow == true then
			--exports['mythic_notify']:DoHudText('success', 'HasCrow is True!')
			DrawText3Ds(119.02, -883.76, 31.12, "[E] - Rob ATM")
			
		else 
			TriggerEvent('DoLongHudText', 'HasCrow is False!', 1)
			-- exports['mythic_notify']:DoHudText('error', 'HasCrow is False!')
		end
end)



function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 200)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingup == true then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
	end
end)

--[[
Citizen.CreateThread(function()
	for k,v in pairs(Banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 255)--156
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 75)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('bank_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)
]]--
incircle = false
hasCrow = false



Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(Cargos)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if holdingup == false then

					
			
					--DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then

						--TriggerServerEvent('esx_robcargo:checkCrow')

					--[[
						- The above event was disabled due to consistent checking of items in Citizen.Thread.
						- In order to fix we need set functions every time the person walks within the circle
						- Once inCircle = true, execute above function to get whether or not  
					]]--

						
						if (incircle == false) then
							--DisplayHelpText(_U('press_to_rob') .. v.nameofbank)
						end
						incircle = true
						if IsControlJustReleased(1, 47) then
							if exports["irp-inventory"]:hasEnoughOfItem("2227010557",1,false) then
								TriggerEvent('esx_robcargo:currentlyrobbing')
							else 
								TriggerEvent('DoLongHudText', 'You need a crowbar!', 1)
								-- exports['mythic_notify']:DoHudText('error', 'How do I break in?')
							end
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup == true then

			--drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('robbery_of') .. secondsRemaining .. _U('seconds_remaining'), 255, 255, 255, 255)

			-- local pos2 = Cargos[cargo].position

			if(Vdist(pos.x, pos.y, pos.z) > 7.5)then
				Citizen.Wait(5000)
			end
		end

		Citizen.Wait(0)
	end
end)
