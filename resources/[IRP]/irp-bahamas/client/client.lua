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
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = -1390.771,-597.9096, 30.31956
        local drawtext = "[~g~E~s~] Go Behind the Counter"
        local plyCoords = GetEntityCoords(Getmecuh)
        local job2 = irpCore.GetPlayerData().job.name
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            DrawText3Ds(x,y,z, drawtext) 
            if job2 == 'police' or 'bahama' then
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('dooranim')
                --TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
                    DoScreenFadeOut(400)
                    Citizen.Wait(500)
                    SetEntityCoords(Getmecuh, -1390.585, -600.3056, 30.31958)
                    Citizen.Wait(500)
                    DoScreenFadeIn(500)
                    prescription = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = -1390.585, -600.3056, 30.31958
        local drawtext = "[~g~E~s~] Go to the other side of the counter"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerEvent('dooranim')
                --TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
                DoScreenFadeOut(400)
                Citizen.Wait(500)
                SetEntityCoords(Getmecuh, -1390.771,-597.9096, 30.31956)
                Citizen.Wait(500)
                DoScreenFadeIn(500)
                prescription = false
            end
        end
    end
end)

local blip = AddBlipForCoord(-1388.7, -586.4099, 30.21915)
SetBlipSprite (blip, 121)
SetBlipDisplay(blip, 2)
SetBlipScale  (blip, 0.8)
SetBlipColour (blip, 27)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString('Bahama Mamas')
EndTextCommandSetBlipName(blip)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = -1385.058, -606.3868, 30.31955
        local job = irpCore.GetPlayerData().job.name
        local drawtext = "[~g~E~s~] Open Stash"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local Lol = 'Bahamas'
        if distance <= 1.2 then
            if job == "bahama" or 'police' then
                DrawText3Ds(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("server-inventory-open", "1", "storage-"..Lol)
                --TriggerEvent('InteractSound_CL:PlayOnOne', 'DoorOpen', 0.8)
                end
            end
        end
    end
end)

searchlocs = {
	[1] = { ["x"] = 1101.117, ["y"] = -3102.4, ["z"] = -38.9992 },
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = -1386.716, -608.8032, 30.31957
        local drawtext = "[~g~E~s~] Browse Stock"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local job3 = irpCore.GetPlayerData().job.name
        if job3 == 'bahama' or 'police' then
            if distance <= 0.8 then
                DrawText3Ds(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                    exports["irp-taskbar"]:taskBar(500,"Checking Stock..",false,false)
                    TriggerEvent("server-inventory-open", "181", "Shop")
                end
            end
        end
    end
end)
