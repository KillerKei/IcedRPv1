irpCore                = nil

TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)

RegisterServerEvent('towtruck:giveCash')
AddEventHandler('towtruck:giveCash', function(cash)
  local source = source
  local xPlayer  = irpCore.GetPlayerFromId(source)
  xPlayer.addMoney(cash)
end)

RegisterServerEvent('irp-imp:mechCar')
AddEventHandler('irp-imp:mechCar', function(plate)
	local user = irpCore.GetPlayerFromId(source)
    local characterId = user.identifier
	garage = 'Impound Lot'
	state = 'Normal Impound'
	MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage, state = @state WHERE plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
end)