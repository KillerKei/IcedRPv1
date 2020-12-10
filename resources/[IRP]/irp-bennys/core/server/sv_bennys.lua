irpCore = nil
TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('irp-bennys:attemptPurchase')
AddEventHandler('irp-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = irpCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('irp-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('irp-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('irp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('irp-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('irp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('irp-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('irp-bennys:updateRepairCost')
AddEventHandler('irp-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)