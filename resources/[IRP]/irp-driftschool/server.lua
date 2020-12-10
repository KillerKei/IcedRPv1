irpCore = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('irp-driftschool:takemoney')
AddEventHandler('irp-driftschool:takemoney', function(money)
    local source = source
    local xPlayer = irpCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        TriggerClientEvent("banking:removeBalance", money)
        TriggerClientEvent('irp-driftschool:tookmoney', source, true)
    else
        TriggerClientEvent('DoLongHudText', source, 'Not enough money', 2)
    end
end)