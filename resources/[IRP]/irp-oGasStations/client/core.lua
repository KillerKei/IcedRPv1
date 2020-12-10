isLoggedIn = true
PlayerJob = {}

irpCore = nil
Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end
end)