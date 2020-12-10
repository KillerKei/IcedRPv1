local PlayerData                = {}
irpCore                             = nil

local blip1 = {}
local blips = false
local blipActive = false
local mineActive = false
local washingActive = false
local remeltingActive = false
local firstspawn = false
local impacts = 0
local timer = 0
local locations = {
    { ['x'] = -591.47,  ['y'] = 2076.52,  ['z'] = 131.37},
    { ['x'] = -590.35,  ['y'] = 2071.76,  ['z'] = 131.29},
    { ['x'] = -589.61,  ['y'] = 2069.3,  ['z'] = 131.19},
    { ['x'] = -588.6,  ['y'] = 2064.03,  ['z'] = 130.96},
}

Citizen.CreateThread(function()
    while irpCore == nil do
        TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
        Citizen.Wait(0)
    end
end)  

RegisterNetEvent('irp:playerLoaded')
AddEventHandler('irp:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('irp:setJob')
AddEventHandler('irp:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent("irp-minerjob:washing")
AddEventHandler("irp-minerjob:washing", function()
    Washing()
end)

RegisterNetEvent("irp-minerjob:remelting")
AddEventHandler("irp-minerjob:remelting", function()
    Remelting()
end)

RegisterNetEvent('irp-minerjob:timer')
AddEventHandler('irp-minerjob:timer', function()
    local timer = 0
    local ped = PlayerPedId()
    
    Citizen.CreateThread(function()
		while timer > -1 do
			Citizen.Wait(150)

			if timer > -1 then
				timer = timer + 1
            end
            if timer == 100 then
                break
            end
		end
    end) 

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 5 then
                exports["irp-taskbar"]:taskBar(15000, 'Washing Stone')
            end
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 5 then
                exports["irp-taskbar"]:taskBar(15000, 'Remelting Stone')
            end
            if timer == 100 then
                timer = 0
                break
            end
        end
    end)
end)

RegisterNetEvent('irp-minerjob:createblips')
AddEventHandler('irp-minerjob:createblips', function()
    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
                if blips == true and blipActive == false then
                    blip1 = AddBlipForCoord(-597.01, 2091.42, 131.41)
                    blip2 = AddBlipForCoord(Config.WashingX, Config.WashingY, Config.WashingZ)
                    blip3 = AddBlipForCoord(Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ)
                    blip4 = AddBlipForCoord(Config.SellX, Config.SellY, Config.SellZ)
                    SetBlipSprite(blip1, 17)
                    SetBlipColour(blip1, 4)
                    SetBlipAsShortRange(blip1, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Mine Start")
                    EndTextCommandSetBlipName(blip1)   
                    SetBlipSprite(blip2, 18)
                    SetBlipColour(blip2, 4)
                    SetBlipAsShortRange(blip2, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Mine Wash")
                    EndTextCommandSetBlipName(blip2)   
                    SetBlipSprite(blip3, 19)
                    SetBlipColour(blip3, 4)
                    SetBlipAsShortRange(blip3, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Mine Remelting")
                    EndTextCommandSetBlipName(blip3)
                    SetBlipSprite(blip4, 20)
                    SetBlipColour(blip4, 4)
                    SetBlipAsShortRange(blip4, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Mine Sell")
                    EndTextCommandSetBlipName(blip4)    
                    blipActive = true
                elseif blips == false and blipActive == false then
                    RemoveBlip(blip1)
                    RemoveBlip(blip2)
                    RemoveBlip(blip3)
                    RemoveBlip(blip4)
                end
        end
    end)
end)

Citizen.CreateThread(function()
    blip = AddBlipForCoord(Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ)
    SetBlipSprite(blip, 78)
    SetBlipColour(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Miner")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            if PlayerData.job ~= nil and PlayerData.job.name == 'miner' and not IsEntityDead( ped ) then
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, true) < 25 then
                    DrawMarker(20, Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, 0, 0, 0, 0, 0, 90.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.CloakroomX, Config.CloakroomY, Config.CloakroomZ, true) < 1 then
                            irpCore.ShowHelpNotification('Press ~INPUT_CONTEXT~ to access the miner cloakroom.')
                                if IsControlJustReleased(1, 51) then
                                    Cloakroom() 
                                end
                            end
                        end
                    end
                end
            end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            for i=1, #locations, 1 do
            if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 25 and mineActive == false then
                DrawMarker(20, locations[i].x, locations[i].y, locations[i].z, 0, 0, 0, 0, 0, 100.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(GetEntityCoords(ped), locations[i].x, locations[i].y, locations[i].z, true) < 1 then
                        irpCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to start mining.")
                            if IsControlJustReleased(1, 51) then
                                Animation()
                                mineActive = true
                            end
                        end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 25 and washingActive == false then
            DrawMarker(20, Config.WashingX, Config.WashingY, Config.WashingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.WashingX, Config.WashingY, Config.WashingZ, true) < 1 then
                    irpCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to wash the stones.")
                    local itemquantitty = exports['irp-inventory']:getQuantity('stone')
                        if IsControlJustReleased(1, 51) and itemquantitty > 9 then
                            TriggerServerEvent("irp-minerjob:washing")
                            exports["irp-taskbar"]:taskBar(15000, 'Washing Stone')
                            TriggerEvent('inventory:removeItem', 'stone', 10)
                            Citizen.Wait(1000)
                            TriggerEvent('loopUpdateItems')
                            Citizen.Wait(1000)
                            TriggerEvent('player:receiveItem', 'washedstone', 5)
                        elseif IsControlJustReleased(1, 51) and itemquantitty < 9 then
                            TriggerEvent('DoLongHudText', 'Come Back With 10 Stone!', 2)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 25 and remeltingActive == false then
            DrawMarker(20, Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.RemeltingX, Config.RemeltingY, Config.RemeltingZ, true) < 1 then
                    irpCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to smelt some stone.")
                    local itemquant = exports['irp-inventory']:getQuantity('washedstone')

                        if IsControlJustReleased(1, 51) and itemquant > 9 then
                            TriggerServerEvent("irp-minerjob:remelting")
                            TriggerEvent('inventory:removeItem', 'washedstone', 10)
                            exports["irp-taskbar"]:taskBar(15000, 'Resmelting Stone')
                            TriggerEvent('player:receiveItem', 'stolen2ctchain', math.random(1,3))
                            TriggerEvent('player:receiveItem', 'aluminium', math.random(1,2))
                            TriggerEvent('player:receiveItem', 'scrapmetal', math.random(1,2))
                        elseif IsControlJustReleased(1, 51) and itemquant < 9 then
                            TriggerEvent('DoLongHudText', 'Come Back With 10 Washed Stone!', 1)
                            end
                        end
                    end
                end
            end)

Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
        if PlayerData.job ~= nil and PlayerData.job.name == 'miner' and not IsEntityDead( ped ) then
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.SellX, Config.SellY, Config.SellZ, true) < 2 then
                DrawMarker(20, Config.SellX, Config.SellY, Config.SellZ, 0, 0, 0, 0, 0, 55.0, 1.0, 1.0, 1.0, 0, 155, 253, 155, 0, 0, 2, 0, 0, 0, 0)
                irpCore.ShowHelpNotification("Press ~INPUT_CONTEXT~ to sell items.")
                    if IsControlJustReleased(1, 51) then
                        Jeweler()                          
                    end
                end
            end
        end
    end)
    

function Cloakroom(vehicle)
    local elements = {
        {label = 'Civilian clothes',   value = 'cloakroom1'},
        {label = 'Work clothes',      value = 'cloakroom2'},
        {label = 'Work car',       value = 'vehicle'},
    }

    irpCore.UI.Menu.CloseAll()

    irpCore.UI.Menu.Open('default', GetCurrentResourceName(), 'miner_actions', {
        title    = 'Miner',
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'cloakroom1' then
            menu.close()
            blips = false
            blipActive = false
            TriggerEvent("irp-minerjob:createblips")
        elseif data.current.value == 'cloakroom2' then
            menu.close()
            blips = true
            TriggerEvent("irp-minerjob:createblips")
        elseif data.current.value == 'vehicle' then
            menu.close()
            RequestModel("RUMPO")
            Citizen.Wait(100)
            CreateVehicle("RUMPO", -283.49, 2533.76, 72.67, 0.0, true, true)
            platenum = math.random(10, 99)
			SetVehicleNumberPlateText(vehicle, "MINER"..platenum) 
            TriggerEvent('DoLongHudText', 'The vehicle was pulled out of the garage.', 1)
            
            local plate = GetVehicleNumberPlateText(vehicle)
			TriggerServerEvent('garage:addKeys', plate)
			exports["Fuel"]:SetFuel(vehicle, 100)
        end
    end)
end

function Jeweler()
    local elements = {
        {label = 'Sell Chains',       value = 'iron'},
    }

    irpCore.UI.Menu.CloseAll()

    irpCore.UI.Menu.Open('default', GetCurrentResourceName(), 'jeweler_actions', {
        title    = 'Sell Items',
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'iron' then
            menu.close()
            itemquantity = exports['irp-inventory']:getQuantity('stolen2ctchain')
            if itemquantity > 4 then
                TriggerEvent('inventory:removeItem', 'stolen2ctchain', itemquantity)
                Citizen.Wait(1000)
                TriggerEvent('loopUpdateItems')
                Citizen.Wait(1000)
                TriggerServerEvent('irp-minerjob:sellsilver')
                -- TriggerEvent("OpenInv")
            else
                TriggerEvent('DoLongHudText', 'You need a minimum of 5 Chains!')
            end
        elseif data.current.value == 'iron' then
            menu.close()
            TriggerServerEvent("irp-minerjob:selliron")
        elseif data.current.value == 'copper' then
            menu.close()
            TriggerServerEvent("irp-minerjob:sellcopper")
        end
    end)
end

function Animation()
    Citizen.CreateThread(function()
        while impacts < 5 do
            Citizen.Wait(1)
		local ped = PlayerPedId()	
                RequestAnimDict("melee@large_wpn@streamed_core")
                Citizen.Wait(100)
                TaskPlayAnim((ped), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 80, 0, 0, 0, 0)
                SetEntityHeading(ped, 270.0)
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'pickaxe', 0.5)
                if impacts == 0 then
                    pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
                    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
                end  
                Citizen.Wait(2500)
                ClearPedTasks(ped)
                impacts = impacts+1
                if impacts == 5 then
                    DetachEntity(pickaxe, 1, true)
                    DeleteEntity(pickaxe)
                    DeleteObject(pickaxe)
                    mineActive = false
                    impacts = 0
                    TriggerEvent('player:receiveItem', 'stone', 5)
                    TriggerEvent('DoLongHudText', 'You received 5 stone.', 1)
                    break
                end        
        end
    end)
end

function Washing()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    washingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    -- TriggerEvent("irp-minerjob:timer")
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    washingActive = false
end

function Remelting()
    local ped = PlayerPedId()
    RequestAnimDict("amb@prop_human_bum_bin@idle_a")
    remeltingActive = true
    Citizen.Wait(100)
    FreezeEntityPosition(ped, true)
    TaskPlayAnim((ped), 'amb@prop_human_bum_bin@idle_a', 'idle_a', 8.0, 8.0, -1, 81, 0, 0, 0, 0)
    Citizen.Wait(15900)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    remeltingActive = false
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100 
    SetTextScale(0.35, 0.35)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()   
end
