irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('carfill:checkmoney')
AddEventHandler('carfill:checkmoney', function(cash)
    local source = source
    local xPlayer = irpCore.GetPlayerFromId(source)
    if cash > 0 then
        xPlayer.removeMoney(cash)
    end
end)