
irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(job)
	local xPlayer = irpCore.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setJob(job, 0)
    end
    
end)