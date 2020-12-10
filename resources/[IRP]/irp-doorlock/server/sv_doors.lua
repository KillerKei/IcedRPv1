local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local irpCore = nil
-- irpCore
TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('irp-doors:alterlockstate2')
AddEventHandler('irp-doors:alterlockstate2', function()
    --irp.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('irp-doors:alterlockstateclient', source, irp.DoorCoords)

end)

RegisterServerEvent('irp-doors:alterlockstate')
AddEventHandler('irp-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    irp.alterState(alterNum)
end)

RegisterServerEvent('irp-doors:ForceLockState')
AddEventHandler('irp-doors:ForceLockState', function(alterNum, state)
    irp.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('irp:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('irp-doors:requestlatest')
AddEventHandler('irp-doors:requestlatest', function()
    local src = source 
    local steamcheck = irpCore.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('irp-doors:alterlockstateclient', source,irp.DoorCoords)
end)

function isDoorLocked(door)
    if irp.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end