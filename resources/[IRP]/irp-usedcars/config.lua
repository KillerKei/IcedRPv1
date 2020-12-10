vehsales = {}

vehsales.Version = '1.0.10'

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj; end)
Citizen.CreateThread(function(...)
  while not irpCore do
    TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj; end)
    Citizen.Wait(0)
  end
end)