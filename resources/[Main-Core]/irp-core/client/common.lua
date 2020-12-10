AddEventHandler('irp:getSharedObject', function(cb)
	cb(irpCore)
end)

function getSharedObject()
	return irpCore
end
