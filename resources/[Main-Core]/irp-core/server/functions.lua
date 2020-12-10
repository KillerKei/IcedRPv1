irpCore.Trace = function(str)
	if Config.EnableDebug then
		print('irpCore> ' .. str)
	end
end

irpCore.SetTimeout = function(msec, cb)
	local id = irpCore.TimeoutCount + 1

	SetTimeout(msec, function()
		if irpCore.CancelledTimeouts[id] then
			irpCore.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	irpCore.TimeoutCount = id

	return id
end

irpCore.ClearTimeout = function(id)
	irpCore.CancelledTimeouts[id] = true
end

irpCore.RegisterServerCallback = function(name, cb)
	irpCore.ServerCallbacks[name] = cb
end

irpCore.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if irpCore.ServerCallbacks[name] ~= nil then
		irpCore.ServerCallbacks[name](source, cb, ...)
	else
		print('irp-core: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

irpCore.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- User accounts
	for i=1, #xPlayer.accounts, 1 do
		if irpCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] ~= xPlayer.accounts[i].money then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_accounts SET money = @money WHERE identifier = @identifier AND name = @name', {
					['@money']      = xPlayer.accounts[i].money,
					['@identifier'] = xPlayer.identifier,
					['@name']       = xPlayer.accounts[i].name
				}, function(rowsChanged)
					cb()
				end)
			end)

			irpCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] = xPlayer.accounts[i].money
		end
	end
	
	-- Job, loadout and position
	table.insert(asyncTasks, function(cb)
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade, loadout = @loadout, position = @position WHERE identifier = @identifier', {
			['@job']        = xPlayer.job.name,
			['@job_grade']  = xPlayer.job.grade,
			['@loadout']    = json.encode(xPlayer.getLoadout()),
			['@position']   = json.encode(xPlayer.getLastPosition()),
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			cb()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		RconPrint('\27[32m[irp-core] [Saving Player]\27[0m ' .. xPlayer.name .. "^7\n")

		if cb ~= nil then
			cb()
		end
	end)
end

irpCore.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = irpCore.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = irpCore.GetPlayerFromId(xPlayers[i])
			irpCore.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('\27[32m[irp-core] [Saving All Players]\27[0m' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

irpCore.StartDBSync = function()
	function saveData()
		irpCore.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

irpCore.GetPlayers = function()
	local sources = {}

	for k,v in pairs(irpCore.Players) do
		table.insert(sources, k)
	end

	return sources
end


irpCore.GetPlayerFromId = function(source)
	return irpCore.Players[tonumber(source)]
end

irpCore.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(irpCore.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

irpCore.RegisterUsableItem = function(item, cb)
	irpCore.UsableItemsCallbacks[item] = cb
end

irpCore.UseItem = function(source, item)
	irpCore.UsableItemsCallbacks[item](source)
end

irpCore.GetItemLabel = function(item)
	if irpCore.Items[item] ~= nil then
		return irpCore.Items[item].label
	end
end

irpCore.CreatePickup = function(type, name, count, label, player)
	local pickupId = (irpCore.PickupId == 65635 and 0 or irpCore.PickupId + 1)

	irpCore.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count
	}

	TriggerClientEvent('irp:pickup', -1, pickupId, label, player)
	irpCore.PickupId = pickupId
end

irpCore.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if irpCore.Jobs[job] and irpCore.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end