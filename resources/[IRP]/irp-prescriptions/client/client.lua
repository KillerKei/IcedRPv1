-- Globalisation for Framework --
irpCore = nil

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent("irp:getSharedObject", function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("irp:playerLoaded")
AddEventHandler("irp:playerLoaded", function(xPlayer)
	irpCore.PlayerData = xPlayer
end)

RegisterNetEvent("irp:setJob")
AddEventHandler("irp:setJob", function(job)
	irpCore.PlayerData.job = job
end)

rescription = false

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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1163.061,-1477.791, 34.84275
        local drawtext = "[~g~E~s~] Enter Prescription Center"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerEvent('dooranim')
                --TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
                DoScreenFadeOut(400)
                Citizen.Wait(500)
                SetEntityCoords(Getmecuh, 1087.443, -3099.379, -38.99992)
                Citizen.Wait(500)
                DoScreenFadeIn(500)
                prescription = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1087.443, -3099.379, -38.99992
        local drawtext = "[~g~E~s~] Exit Prescription Center"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerEvent('dooranim')
                --TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
                DoScreenFadeOut(400)
                Citizen.Wait(500)
                SetEntityCoords(Getmecuh, 1163.061,-1477.791, 34.84275)
                Citizen.Wait(500)
                DoScreenFadeIn(500)
                prescription = false
            end
        end
    end
end)

searchlocs = {
	[1] = { ["x"] = 1101.117, ["y"] = -3102.4, ["z"] = -38.9992 },
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1101.117, -3102.4, -38.9992
        local drawtext = "[~g~E~s~] Search"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 and prescription == true then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) and prescription == true then
                exports["irp-taskbar"]:taskBar(10000,"Searching For a Prescription..",false,false)
                TriggerEvent('irp-prescriptions:reward')
                Citizen.Wait(100)
                TriggerEvent("DoLongHudText","Go to another Search Point or wait 1 minute before continuing.",1)
                Citizen.Wait(30000)
            end
        end
    end
end)

RegisterNetEvent('irp-prescriptions:reward')
AddEventHandler('irp-prescriptions:reward', function()
    Citizen.Wait(1000)
    local finished = exports["irp-taskbarskill"]:taskBar(math.random(1200,1400),math.random(15,20))
    if finished == 100 then
        TriggerServerEvent('irp-prescriptions:payout')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1103.261, -3102.325, -38.9992
        local drawtext = "[~g~E~s~] Search"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 and prescription == true then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) and prescription == true then
                exports["irp-taskbar"]:taskBar(10000,"Searching For a Prescription..",false,false)
                TriggerEvent('irp-prescriptions:reward')
                Citizen.Wait(100)
                TriggerEvent("DoLongHudText","Go to another Search Point or wait 1 minute before continuing.",1)
                Citizen.Wait(30000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1104.753, -3102.327, -38.992
        local drawtext = "[~g~E~s~] Search"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 and prescription == true then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) and prescription == true then
                exports["irp-taskbar"]:taskBar(10000,"Searching For a Prescription..",false,false)
                TriggerEvent('irp-prescriptions:reward')
                Citizen.Wait(100)
                TriggerEvent("DoLongHudText","Go to another Search Point or wait 1 minute before continuing.",1)
                Citizen.Wait(30000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1088.429, -3101.153, -38.9992
        local drawtext = "[~g~E~s~] Order Prescriptions"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerEvent("DoLongHudText","Order Arriving in 1 Minute.",1)
                Citizen.Wait(1000) -- change back to 60 seconds after.
                prescription = true
                TriggerEvent("DoLongHudText","Head to Shelves at the back and Search for some Prescriptions.",1)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1091.182, -3098.111, -38.9995
        local drawtext = "[~g~E~s~] Clear Shelves"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 and prescription == true then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) and prescription == true then
                TriggerEvent("DoLongHudText","Shelves Cleared, you may leave.",1)
                Citizen.Wait(1000) -- change back to 60 seconds after.
                prescription = false
                TriggerEvent("DoLongHudText","Drop the medical bags off at pillbox!",1)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 307.0092, -595.1996, 43.28403
        local drawtext = "[~g~E~s~] Call for a Receptionist"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerEvent("DoLongHudText","Receptionist En Route!",2)
                Citizen.Wait(1000) -- DO NOT EDIT
                TriggerEvent("police:assistance")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Getmecuh = PlayerPedId()
        local x,y,z = 306.5433, -597.4069, 43.28402
        local drawtext = "[~g~E~s~] Sell Medical Bags"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 and irpCore.GetPlayerData().job.name == 'police' or irpCore.GetPlayerData().job.name == 'ambulance' then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) and irpCore.GetPlayerData().job.name == 'police' or irpCore.GetPlayerData().job.name == 'ambulance' then
                exports["irp-taskbar"]:taskBar(10000,"Selling Medical Bags..",false,false)
                quantity = exports['irp-inventory']:getQuantity('MedicalBag')
                price = quantity*80
                Citizen.Wait(1000)
                TriggerEvent('inventory:removeItem', 'MedicalBag', quantity)
                Citizen.Wait(1000)
                TriggerEvent('loopUpdateItems')
                TriggerServerEvent('irp-prescriptions:pay', price)
                TriggerEvent("DoLongHudText","You hear voices in your head saying: Sell them for 30 Each (You make Profit!)",2)
            end
        end
    end
end)