local JobCount = {}


Citizen.CreateThread(function()
    while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
	while irpCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = irpCore.GetPlayerData()
end)

RegisterNetEvent('irp:setJob')
AddEventHandler('irp:setJob', function(job)
	PlayerData.job = job
	TriggerServerEvent('irp-jobnumbers:setjobs', job)
end)

RegisterNetEvent('irp:playerLoaded')
AddEventHandler('irp:playerLoaded', function(xPlayer)
    TriggerServerEvent('irp-jobnumbers:setjobs', xPlayer.job)
end)


RegisterNetEvent('irp-jobnumbers:setjobs')
AddEventHandler('irp-jobnumbers:setjobs', function(jobslist)
   JobCount = jobslist
end)

function jobonline(joblist)
    for i,v in pairs(Config.MultiNameJobs) do
        for u,c in pairs(v) do
            if c == joblist then
                joblist = i
            end
        end
    end

    local amount = 0
    local job = joblist
    if JobCount[job] ~= nil then
        amount = JobCount[job]
    end

    return amount
end


