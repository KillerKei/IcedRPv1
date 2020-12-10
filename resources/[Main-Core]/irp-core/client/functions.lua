irpCore                           = {}
irpCore.PlayerData                = {}
irpCore.PlayerLoaded              = false
irpCore.CurrentRequestId          = 0
irpCore.ServerCallbacks           = {}
irpCore.TimeoutCallbacks          = {}

irpCore.UI                        = {}
irpCore.UI.HUD                    = {}
irpCore.UI.HUD.RegisteredElements = {}
irpCore.UI.Menu                   = {}
irpCore.UI.Menu.RegisteredTypes   = {}
irpCore.UI.Menu.Opened            = {}

irpCore.Game                      = {}
irpCore.Game.Utils                = {}

irpCore.Scaleform                 = {}
irpCore.Scaleform.Utils           = {}

irpCore.Streaming                 = {}

irpCore.SetTimeout = function(msec, cb)
	table.insert(irpCore.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #irpCore.TimeoutCallbacks
end

irpCore.ClearTimeout = function(i)
	irpCore.TimeoutCallbacks[i] = nil
end

irpCore.IsPlayerLoaded = function()
	return irpCore.PlayerLoaded
end

irpCore.GetPlayerData = function()
	return irpCore.PlayerData
end

irpCore.SetPlayerData = function(key, val)
	irpCore.PlayerData[key] = val
end

irpCore.ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

irpCore.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

irpCore.ShowHelpNotification = function(msg)
	--if not IsHelpMessageBeingDisplayed() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	--end
end

irpCore.TriggerServerCallback = function(name, cb, ...)
	irpCore.ServerCallbacks[irpCore.CurrentRequestId] = cb

	TriggerServerEvent('irp:triggerServerCallback', name, irpCore.CurrentRequestId, ...)

	if irpCore.CurrentRequestId < 65535 then
		irpCore.CurrentRequestId = irpCore.CurrentRequestId + 1
	else
		irpCore.CurrentRequestId = 0
	end
end

irpCore.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

irpCore.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #irpCore.UI.HUD.RegisteredElements, 1 do
		if irpCore.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(irpCore.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	irpCore.UI.HUD.UpdateElement(name, data)
end

irpCore.UI.HUD.RemoveElement = function(name)
	for i=1, #irpCore.UI.HUD.RegisteredElements, 1 do
		if irpCore.UI.HUD.RegisteredElements[i] == name then
			table.remove(irpCore.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

irpCore.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

irpCore.UI.Menu.RegisterType = function(type, open, close)
	irpCore.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

irpCore.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		irpCore.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #irpCore.UI.Menu.Opened, 1 do
			if irpCore.UI.Menu.Opened[i] ~= nil then
				if irpCore.UI.Menu.Opened[i].type == type and irpCore.UI.Menu.Opened[i].namespace == namespace and irpCore.UI.Menu.Opened[i].name == name then
					irpCore.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close ~= nil then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		irpCore.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(irpCore.UI.Menu.Opened, menu)
	irpCore.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

irpCore.UI.Menu.Close = function(type, namespace, name)
	for i=1, #irpCore.UI.Menu.Opened, 1 do
		if irpCore.UI.Menu.Opened[i] ~= nil then
			if irpCore.UI.Menu.Opened[i].type == type and irpCore.UI.Menu.Opened[i].namespace == namespace and irpCore.UI.Menu.Opened[i].name == name then
				irpCore.UI.Menu.Opened[i].close()
				irpCore.UI.Menu.Opened[i] = nil
			end
		end
	end
end

irpCore.UI.Menu.CloseAll = function()
	for i=1, #irpCore.UI.Menu.Opened, 1 do
		if irpCore.UI.Menu.Opened[i] ~= nil then
			irpCore.UI.Menu.Opened[i].close()
			irpCore.UI.Menu.Opened[i] = nil
		end
	end
end

irpCore.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #irpCore.UI.Menu.Opened, 1 do
		if irpCore.UI.Menu.Opened[i] ~= nil then
			if irpCore.UI.Menu.Opened[i].type == type and irpCore.UI.Menu.Opened[i].namespace == namespace and irpCore.UI.Menu.Opened[i].name == name then
				return irpCore.UI.Menu.Opened[i]
			end
		end
	end
end

irpCore.UI.Menu.GetOpenedMenus = function()
	return irpCore.UI.Menu.Opened
end

irpCore.UI.Menu.IsOpen = function(type, namespace, name)
	return irpCore.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

irpCore.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return mugshot, GetPedheadshotTxdString(mugshot)
end

irpCore.Game.Teleport = function(entity, coords, cb)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end

	SetEntityCoords(entity, coords.x, coords.y, coords.z)

	if cb ~= nil then
		cb()
	end
end

irpCore.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		irpCore.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

irpCore.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		irpCore.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

irpCore.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

irpCore.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

irpCore.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		irpCore.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

irpCore.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		irpCore.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

irpCore.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

irpCore.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

irpCore.Game.GetClosestObject = function(filter, coords)
	local objects         = irpCore.Game.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end

irpCore.Game.GetPlayers = function()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

irpCore.Game.GetClosestPlayer = function(coords)
	local players         = irpCore.Game.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

irpCore.Game.GetPlayersInArea = function(coords, area)
	local players       = irpCore.Game.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

irpCore.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

irpCore.Game.GetClosestVehicle = function(coords)
	local vehicles        = irpCore.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

irpCore.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = irpCore.Game.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

irpCore.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

irpCore.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = irpCore.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

irpCore.Game.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

irpCore.Game.GetClosestPed = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = irpCore.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

irpCore.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	return {
		model             = GetEntityModel(vehicle),

		plate             = irpCore.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = irpCore.Math.Round(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = irpCore.Math.Round(GetVehicleEngineHealth(vehicle), 1),

		fuelLevel         = irpCore.Math.Round(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel         = irpCore.Math.Round(GetVehicleDirtLevel(vehicle), 1),
		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleLivery(vehicle)
	}
end

irpCore.Game.SetVehicleProperties = function(vehicle, props)
	SetVehicleModKit(vehicle, 0)

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.bodyHealth ~= nil then
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
	end

	if props.engineHealth ~= nil then
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
	end

	if props.fuelLevel ~= nil then
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
	end

	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
	end

	if props.color1 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras ~= nil then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
end

irpCore.Game.Utils.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x,y)
    local factor = (string.len(text)) / 370
    DrawRect(x,y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 68)
	end
end

RegisterNetEvent('irp:serverCallback')
AddEventHandler('irp:serverCallback', function(requestId, ...)
	irpCore.ServerCallbacks[requestId](...)
	irpCore.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('irp:showNotification')
AddEventHandler('irp:showNotification', function(msg)
	irpCore.ShowNotification(msg)
end)

RegisterNetEvent('irp:showAdvancedNotification')
AddEventHandler('irp:showAdvancedNotification', function(title, subject, msg, icon, iconType)
	irpCore.ShowAdvancedNotification(title, subject, msg, icon, iconType)
end)

RegisterNetEvent('irp:showHelpNotification')
AddEventHandler('irp:showHelpNotification', function(msg)
	irpCore.ShowHelpNotification(msg)
end)

-- SetTimeout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local currTime = GetGameTimer()

		for i=1, #irpCore.TimeoutCallbacks, 1 do
			if irpCore.TimeoutCallbacks[i] then
				if currTime >= irpCore.TimeoutCallbacks[i].time then
					irpCore.TimeoutCallbacks[i].cb()
					irpCore.TimeoutCallbacks[i] = nil
				end
			end
		end
	end
end)
