M17XYU5JX5V.CurrentRequestId    = 0
M17XYU5JX5V.ServerCallbacks     = {}
M17XYU5JX5V.ClientCallbacks     = {}
M17XYU5JX5V.ClientEvents        = {}
M17XYU5JX5V.Config              = {}
M17XYU5JX5V.SecurityTokens      = {}

M17XYU5JX5V.RegisterClientCallback = function(name, cb)
    M17XYU5JX5V.ClientCallbacks[name] = cb
end

M17XYU5JX5V.RegisterClientEvent = function(name, cb)
    M17XYU5JX5V.ClientEvents[name] = cb
end

M17XYU5JX5V.TriggerServerCallback = function(name, cb, ...)
    M17XYU5JX5V.ServerCallbacks[M17XYU5JX5V.CurrentRequestId] = cb

    TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:dE4JpEbAw6xdfJZHIk', name, M17XYU5JX5V.CurrentRequestId, ...)

    if (M17XYU5JX5V.CurrentRequestId < 65535) then
        M17XYU5JX5V.CurrentRequestId = M17XYU5JX5V.CurrentRequestId + 1
    else
        M17XYU5JX5V.CurrentRequestId = 0
    end
end

M17XYU5JX5V.TriggerServerEvent = function(name, ...)
    TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:rxORv86yw6d8LqOpMT', name, ...)
end

M17XYU5JX5V.TriggerClientCallback = function(name, cb, ...)
    if (M17XYU5JX5V.ClientCallbacks ~= nil and M17XYU5JX5V.ClientCallbacks[name] ~= nil) then
        M17XYU5JX5V.ClientCallbacks[name](cb, ...)
    end
end

M17XYU5JX5V.TriggerClientEvent = function(name, ...)
    if (M17XYU5JX5V.ClientEvents ~= nil and M17XYU5JX5V.ClientEvents[name] ~= nil) then
        M17XYU5JX5V.ClientEvents[name](...)
    end
end

M17XYU5JX5V.ShowNotification = function(msg)
    AddTextEntry('rxORv86yw6d8LqOpMTlWK', msg)
	SetNotificationTextEntry('rxORv86yw6d8LqOpMTlWK')
	DrawNotification(false, true)
end

M17XYU5JX5V.RequestAndDelete = function(object, detach)
    if (DoesEntityExist(object)) then
        NetworkRequestControlOfEntity(object)

        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(0)
        end

        if (detach) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

RegisterNetEvent('irp-fml_giveBackCautionInCaseOfDrop:fhhY13bnv6Jd1NCOPB6zn')
AddEventHandler('irp-fml_giveBackCautionInCaseOfDrop:fhhY13bnv6Jd1NCOPB6zn', function(requestId, ...)
	if (M17XYU5JX5V.ServerCallbacks ~= nil and M17XYU5JX5V.ServerCallbacks[requestId] ~= nil) then
		M17XYU5JX5V.ServerCallbacks[requestId](...)
        M17XYU5JX5V.ServerCallbacks[requestId] = nil
	end
end)