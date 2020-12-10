irpCore = nil

Citizen.CreateThread(function()
	while irpCore == nil do
		TriggerEvent('irp:getSharedObject', function(obj) irpCore = obj end)
		Citizen.Wait(0)
	end

	while irpCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = irpCore.GetPlayerData()
end)

RegisterNetEvent('irp-fines:Anim')
AddEventHandler('irp-fines:Anim', function()
	RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
end)