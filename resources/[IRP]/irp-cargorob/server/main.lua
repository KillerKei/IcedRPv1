local irpCore = nil

local CoolDownTimerATM = {}

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent("irp_cargorobbery:success")
AddEventHandler("irp_cargorobbery:success",function()
	local xPlayer = irpCore.GetPlayerFromId(source)
    local reward = math.random(500,1000)
	xPlayer.addMoney(reward)
	TriggerClientEvent("DoLongHudText","You received $" ..reward.. "cash",2)
end)