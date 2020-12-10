irpCore             = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('mythic_hospital:server:HealSomeShit')
AddEventHandler('mythic_hospital:server:HealSomeShit', function()
    local src = source

	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	local xPlayer = irpCore.GetPlayerFromId(src)
	xPlayer.removeBank(750)
        TriggerClientEvent('irp:showNotification', src, '~w~You Were Billed For ~r~$750 ~w~For Medical Services & Expenses')
end)