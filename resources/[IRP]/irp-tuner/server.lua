irpCore = nil
TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

irpCore.RegisterUsableItem("tunerchip",function(source)
    local _source = source
    TriggerClientEvent('tuner:open', _source)
end)