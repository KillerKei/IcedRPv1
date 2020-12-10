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

-- IRP CAR THEFT JOB --
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

-- END OF IRP CAR THEFT --

-- Jail task --

ObtainedBox = false

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
        Citizen.Wait(8)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1775.238,2593.294, 45.723
        local drawtext = "[E] To Clean Dishes"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 1.2 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                RequestAnimDict("mp_car_bomb")
                TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 1800000,49, 0, 0, 0, 0)
                TriggerEvent('irp-jailtask:aidsthing')
                Citizen.Wait(5000)
                ClearPedTasks(PlayerPedId(-1))
                --FUNCTION
            end
        end
    end
end)

RegisterNetEvent('irp-jailtask:aidsthing')
AddEventHandler('irp-jailtask:aidsthing', function()
    local finished = exports["irp-taskbarskill"]:taskBar(math.random(1200,2000),math.random(15,20))
    if finished == 100 then
        local finished2 = exports["irp-taskbarskill"]:taskBar(math.random(1300,2000),math.random(15,20))
        if finished2 == 100 then
            local itemhehe = math.random(1,3)
            if itemhehe == 3 then
                TriggerEvent( "player:receiveItem", "shitlockpick", 1 )
                ClearPedTasks(PlayerPedId(-1))
            elseif itemhehe == 2 then
                TriggerEvent( "player:receiveItem", "shitlockpick", 1 )
                ClearPedTasks(PlayerPedId(-1))
            elseif itemhehe == 1 then
                TriggerEvent('DoLongHudText', 'You did a poor job at scrubbing the dishes', 2)
                ClearPedTasks(PlayerPedId(-1))
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1687.548,2553.782, 45.5649
        local drawtext = "[E] To Break Into Container"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            DrawText3Ds(x,y,z, drawtext) 
            if IsControlJustReleased(0, 38) then
                if exports['irp-inventory']:hasEnoughOfItem('shitlockpick', 1) then
                    local myluck = math.random(1,3)
                    if myluck == 1 or 2 then
                        if ObtainedBox == true then
                            TriggerServerEvent('irp-jailtask:idiot')
                            TriggerEvent("inventory:removeItem","shitlockpick", 1)
                            Citizen.Wait(1000)
                            TriggerEvent('loopUpdateItems')
                            Citizen.Wait(1000)
                        end
                        TriggerEvent("inventory:removeItem","shitlockpick", 1)  
                        Citizen.Wait(1000)
                        TriggerEvent('loopUpdateItems')
                        Citizen.Wait(1000)
                        FreezeEntityPosition(GetPlayerPed(-1),true)
                        RequestAnimDict('missheistfbi3b_ig7')
                        TaskPlayAnim(Getmecuh, 'missheistfbi3b_ig7', 'lift_fibagent_loop', 8.0, -8, 5000, 49, 0, 0, 0, 0)
                        Citizen.Wait(5500)
                        FreezeEntityPosition(GetPlayerPed(-1), false)
                        TriggerEvent("attachItem","crate01")
                        RequestAnimDict("anim@heists@box_carry@")
                        TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
                        Citizen.Wait(500)
                        TriggerEvent('DoLongHudText', 'Find a place where you can throw the box!', 1)
                        ObtainedBox = true        --FUNCTION
                    else
                        TriggerEvent("inventory:removeItem","shitlockpick", 1)  
                        Citizen.Wait(1000)
                        TriggerEvent('loopUpdateItems')
                        Citizen.Wait(1000)
                        FreezeEntityPosition(GetPlayerPed(-1),true)
                        RequestAnimDict('missheistfbi3b_ig7')
                        TaskPlayAnim(Getmecuh, 'missheistfbi3b_ig7', 'lift_fibagent_loop', 8.0, -8, 5000, 49, 0, 0, 0, 0)
                        Citizen.Wait(5000)
                        ClearPedTasks(PlayerPedId(-1))
                        TriggerEvent('DoLongHudText', 'You couldn\'t find anything, have another crack', 2)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1771.402,2593.952, 45.72358
        local drawtext = "[E] Place Box On Floor"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            -- ObtainedBox = true
            if ObtainedBox == true then
                DrawText3Ds(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                    RequestAnimDict("anim@heists@narcotics@trash")
                    TaskPlayAnim(PlayerPedId(-1), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
                    Citizen.Wait(500)
                    ClearPedTasks(GetPlayerPed(-1))
                    TriggerEvent("destroyProp") 
                    ObtainedBox = false
                    Citizen.Wait(2000)
                    TriggerEvent('DoLongHudText', 'Look in the box.. There may be something you need to take to reception')
                    FreezeEntityPosition(GetPlayerPed(-1),true)
                    RequestAnimDict("mp_car_bomb")
                    TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 1800000,49, 0, 0, 0, 0)
                    Citizen.Wait(4000)
                    ClearPedTasks(PlayerPedId(-1))
                    FreezeEntityPosition(GetPlayerPed(-1),false)
                    Citizen.Wait(1000)
                    TriggerServerEvent('irp-jailtask:receptionist')
                end        --FUNCTION
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1788.798,2595.644, 45.71716
        local drawtext = "[E] Give Receptionist Item"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            if ObtainedBox == false then
                DrawText3Ds(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                    if exports['irp-inventory']:hasEnoughOfItem('ppapers', 1) then
                     --FUNCTION
                        RequestAnimDict("anim@heists@narcotics@trash")
                        TaskPlayAnim(PlayerPedId(-1), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
                        Citizen.Wait(1500)
                        ClearPedTasks(PlayerPedId(-1))
                        TriggerServerEvent('irp-jailtask:removehehe')
                        Citizen.Wait(1500)
                        TriggerEvent('DoLongHudText', 'Remember, 400 Reputation and the guards will let you out!', 2)
                        Citizen.Wait(5000)
                    end
                end       
            end
        end
    end
end)

-- end of jail task --


-- vu job --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local Getmecuh = PlayerPedId()
        local x,y,z = 1788.798,2595.644, 45.71716
        local drawtext = "[E] Start Dancing"
        local plyCoords = GetEntityCoords(Getmecuh)
        local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z,x,y,z,false)
        if distance <= 0.8 then
            if ObtainedBox == false then
                DrawText3Ds(x,y,z, drawtext) 
                if IsControlJustReleased(0, 38) then
                     --FUNCTION
                end       
            end
        end
    end
end)

