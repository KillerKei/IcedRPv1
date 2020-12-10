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
-- End of Globalisation --
doingactiverun = false
cooldown = false
local timer = 0


function LoadMarkers()


    LoadModel('sultan')
    LoadModel('seashark')
    LoadAnimDict('missheistdockssetup1clipboard@base')

end


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


searchlocs = {
	[1] = { ["x"] = 1101.117, ["y"] = -3102.4, ["z"] = -38.9992 },
}

-- local Positions = {
-- 	['DespawnVeh'] = { ['hint'] = '[E] Delete Vehicle', ['x'] = -769.23773193359, ['y'] = 5595.6215820313, ['z'] = 33.48571395874 }
-- }

function DrawM(hint, type, x, y, z)
	DrawText3Ds(x, y, z + 1, tostring('[E] Delete Vehicle'))
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 5.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
end

function DrawMM(hint, type, x, y, z)
	DrawText3Ds(x, y, z + 1, tostring('[E] Put Vehicle on Cargo Boat'))
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 5.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
end

function DrawMMM(hint, type, x, y, z)
	DrawText3Ds(x, y, z + 1, tostring('[E] Take Car off of Boat and Drop it off.'))
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 25.5, 25.5, 25.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local x,y,z = -227.1659, 6262.183, 31.48919
        local Getmecuh = PlayerPedId()
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local vehicle = GetVehiclePedIsIn(Getmecuh, false)
        if distance <= 5.5 then
            DrawM('[E] Delete Vehicle', 27, -227.1659, 6262.183, 31.48919 - 0.945, 255, 255, 255, 1.5, 15)
        end

        if IsControlJustReleased(0, 38) then
            if distance <= 10.5 then
                if doingactiverun == true then
                    irpCore.Game.DeleteVehicle(vehicle)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local x,y,z = 1732.425, 3314.708, 41.22347
        local Getmecuh = PlayerPedId()
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local vehicle = GetVehiclePedIsIn(Getmecuh, false)
        if distance <= 100.5 then
            if doingactiverun == true then
                TriggerEvent('irp-cartheft:spawnveh2')
                Citizen.Wait(1200000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local x,y,z = 1242.786, -3263.058, 5.532083
        local Getmecuh = PlayerPedId()
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local vehicle = GetVehiclePedIsIn(Getmecuh, false)
        if distance <= 5.5 then
            if doingactiverun == true then
                DrawMM('[E] Put Vehicle on Cargo Boat', 27, 1242.786, -3263.058, 5.532083 - 0.945, 255, 255, 255, 1.5, 15)
                if IsControlJustReleased(0, 38) then
                    if IsPedInVehicle(PlayerPedId(), Richcar) then
                        irpCore.Game.DeleteVehicle(vehicle)
                        TriggerEvent('irp-cartheft:spawnveh3')
                        Citizen.Wait(1000)
                        SetNewWaypoint(4192.31, 4456.618)
                        timer = 1800000 -- CONVERT BACK TO 30 MINS AFTER (1800000)
                        Citizen.Wait(1200000)
                    else
                        TriggerEvent('DoLongHudText', 'Come back with the Stolen Vehicle.')
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local x,y,z = 4192.31, 4456.618, 5.423574
        local Getmecuh = PlayerPedId()
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        local vehicle = GetVehiclePedIsIn(Getmecuh, false)
        if distance <= 90.5 then
            if doingactiverun == true then
                DrawMMM('[E] Take Car off of Boat and Drop it off.', 27, 4192.31, 4456.618, 5.423574 - 0.945, 255, 255, 255, 1.5, 15)
                if IsControlJustReleased(0, 38) then
                    if IsPedInVehicle(PlayerPedId(), Boat) then
                        irpCore.Game.DeleteVehicle(vehicle)
                        Citizen.Wait(100)
                        TriggerEvent('irp-spawnjetski')
                        Citizen.Wait(1000)
                        TriggerServerEvent('irp-cartheft:reward')
                    else
                        TriggerEvent('DoLongHudText', 'Come back with the Stolen Vehicle.')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('irp-spawnjetski')
AddEventHandler('irp-spawnjetski', function()
    irpCore.Game.SpawnVehicle('seashark', vector3(4055.825, 4473.207, 1.73629), 169.79, function(vehicle)
    Jetski = vehicle
    local plate = GetVehicleNumberPlateText(Jetski)
    TriggerServerEvent('garage:addKeys', plate)
    TaskWarpPedIntoVehicle(PlayerPedId() , Jetski, -1)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local Getmecuh = PlayerPedId()
        local x,y,z = -231.3556, 6234.774, 31.4959
        local drawtext = "[~g~E~s~] Order Stolen Vehicle [~g~$2000~s~]"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent('irp-cartheft:checkcooldown',timer)
                if timer < 1 then
                    TriggerEvent('irp-cartheft:task1')
                    Citizen.Wait(2400000) -- CD 
                end
            end
        end
    end
end)

RegisterNetEvent('irp-cartheft:task1')
AddEventHandler('irp-cartheft:task1', function()
    loadAnimDict( "missheistdockssetup1clipboard@base" )
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(5)
    exports["irp-taskbar"]:taskBar(5000,"Searching For an order..")
    Citizen.Wait(10)
    exports["irp-taskbar"]:taskBar(2000,"Vehicle Found..")
    Citizen.Wait(10)
    exports["irp-taskbar"]:taskBar(5000,"Locating Vehicle..")
    Citizen.Wait(10)
    doingactiverun = true
    exports["irp-taskbar"]:taskBar(2000,"Vehicle Located..")
    Citizen.Wait(10)
    ClearPedTasksImmediately(PlayerPedId())
    Citizen.Wait(10)
    TriggerServerEvent('irp-cartheft:price')
    Citizen.Wait(100)
    TriggerEvent('DoLongHudText', 'Head to the GPS Located on your map.')
    SetNewWaypoint(1732.425, 3314.708)
end)


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('irp-cartheft:spawnveh')
AddEventHandler('irp-cartheft:spawnveh', function()
    irpCore.Game.SpawnVehicle('sultan', vector3( -229.0029, 6251.22, 31.48927), 169.79, function(vehicle)
    HuntCar = vehicle
    local plate = GetVehicleNumberPlateText(HuntCar)
    TriggerServerEvent('garage:addKeys', plate)
    TaskWarpPedIntoVehicle(PlayerPedId() , HuntCar, -1)
    end)
end)

RegisterNetEvent('irp-cartheft:spawnveh3')
AddEventHandler('irp-cartheft:spawnveh3', function()
    irpCore.Game.SpawnVehicle('tug', vector3( 1316.715, -3276.565, 5.803882), 350.79, function(vehicle)
    Boat = vehicle
    local plate = GetVehicleNumberPlateText(Boat)
    TriggerServerEvent('garage:addKeys', plate)
    TaskWarpPedIntoVehicle(PlayerPedId() , Boat, -1)
    end)
end)


RegisterNetEvent('irp-cartheft:spawnveh2')
AddEventHandler('irp-cartheft:spawnveh2', function()
    local car = math.random(1,4)

    if car == 1 then
        spawncar = 'adder'
    end
    if car == 2 then
        spawncar = 'reaper'
    end
    if car == 3 then
        spawncar = 'jester2'
    end
    if car == 4 then
        spawncar = 'entityxf'
    end
    irpCore.Game.SpawnVehicle(spawncar, vector3( 1732.425, 3314.708, 41.22347), 169.79, function(vehicle)
        Richcar = vehicle
        local plate = GetVehicleNumberPlateText(Richcar)
        TriggerServerEvent('garage:addKeys', plate)
        local x,y,z = 1242.786, -3263.058, 5.532083
        TriggerEvent("DoLongHudText","Please wait whilst we update your GPS!",1)
        Citizen.Wait(25000)
        TriggerEvent("DoLongHudText","Drive to the Marker on your GPS!",1)
        SetNewWaypoint(1242.786, -3263.058)
    end)
end)