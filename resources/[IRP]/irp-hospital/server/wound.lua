local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('irp-hospital:server:SyncInjuries')
AddEventHandler('irp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)