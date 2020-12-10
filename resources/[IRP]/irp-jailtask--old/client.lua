-- Globalisation of framework --

irpCore = nil

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
end)

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
                        TriggerEvent('DoLongHudText', 'Remember, 800 Reputation and the guards will let you out!', 2)
                        Citizen.Wait(5000)
                    end
                end       
            end
        end
    end
end)