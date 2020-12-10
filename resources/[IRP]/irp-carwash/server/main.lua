irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

irpCore.RegisterServerCallback('irp-carwash:canAfford', function(source, cb)
	local xPlayer = irpCore.GetPlayerFromId(source)

	if Config.EnablePrice then
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeMoney(Config.Price)
			TriggerClientEvent("banking:removeBalance", Config.Price)
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end)