irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

AddEventHandler('irp:playerLoaded', function(source)
	TriggerEvent('irp-license:getLicenses', source, function(licenses)
		TriggerClientEvent('irp-dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('irp-dmvschool:addLicense')
AddEventHandler('irp-dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('irp-license:addLicense', _source, type, function()
		TriggerEvent('irp-license:getLicenses', _source, function(licenses)
			TriggerClientEvent('irp-dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('irp-dmvschool:pay')
AddEventHandler('irp-dmvschool:pay', function(price)
	local _source = source
	local xPlayer = irpCore.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('DoLongHudText', _source, 'You paid $'.. irpCore.Math.GroupDigits(price) .. ' to the DMV school', 1)
end)
