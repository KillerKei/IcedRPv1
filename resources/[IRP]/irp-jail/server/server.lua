irpCore                = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterCommand("jail", function(src, args, raw)

	local xPlayer = irpCore.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)
				
				if args[3] ~= nil then
					GetRPName(jailPlayer, function(Firstname, Lastname)
						TriggerClientEvent('chat:addMessage', -1, {template = '<div class="chat-message jail"><b> {0}:</b> {1}</div>', args = { "DOC | ",  Firstname .. " " .. Lastname .. " has been jailed for " .. jailTime .. " months" } })
					end)
				end
			else
				TriggerClientEvent('DoLongHudText', src, "This time is invalid!", 2)
			end
		else
			TriggerClientEvent('DoLongHudText', src, "This ID is not online!", 2)
		end
	else
		TriggerClientEvent('DoLongHudText', src, "You are not an officer!", 2)
	end
end)

RegisterCommand("unjail", function(src, args)

	local xPlayer = irpCore.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent('DoLongHudText', "This ID is not online!", 2)
		end
	else
		TriggerClientEvent('DoLongHudText', "You are not an officer!", 2)
	end
end)

RegisterServerEvent("irp-jail:dumbAss")
AddEventHandler("irp-jail:dumbAss", function(targetSrc, jailTime, jailReason)
	local src = source
	local targetSrc = tonumber(targetSrc)

	JailPlayer(targetSrc, jailTime)
	TriggerClientEvent('DoLongHudText', src, GetPlayerName(targetSrc) .. " Jailed for " .. jailTime .. " minutes!", 1)
end)

RegisterServerEvent("irp-jail:unJailPlayer")
AddEventHandler("irp-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = irpCore.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end

	TriggerClientEvent('DoLongHudText', src, xPlayer.name .. " Unjailed!", 1)
end)

RegisterServerEvent("irp-jail:updateJailTime")
AddEventHandler("irp-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("irp-jail:prisonWorkReward")
AddEventHandler("irp-jail:prisonWorkReward", function()
	local src = source

	local xPlayer = irpCore.GetPlayerFromId(src)

	xPlayer.addMoney(math.random(13, 21))
	TriggerClientEvent("banking:addBalance", 13, 21)

	TriggerClientEvent('DoLongHudText', src, "Thanks, here's some cash for food!", 1)
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("irp-jail:dumbAss", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("irp-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = irpCore.GetPlayerFromId(src)
	if xPlayer ~= nil then
		local Identifier = xPlayer.identifier

		MySQL.Async.execute(
       		"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        	{
				['@identifier'] = Identifier,
				['@newJailTime'] = tonumber(jailTime)
			}
		)
	end
end

function GetRPName(playerId, data)
	local Identifier = irpCore.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

irpCore.RegisterServerCallback("irp-jail:retrievePrisoner", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

irpCore.RegisterServerCallback("irp-jail:retrieveTime", function(source, cb)

	local src = source

	local xPlayer = irpCore.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)