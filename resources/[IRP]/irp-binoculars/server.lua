irpCore               = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

irpCore.RegisterUsableItem('binoculars', function(source)
    local xPlayer = irpCore.GetPlayerFromId(source)
    local drill = xPlayer.getInventoryItem('binoculars')

    TriggerClientEvent('binoculars:Activate', source)
end)