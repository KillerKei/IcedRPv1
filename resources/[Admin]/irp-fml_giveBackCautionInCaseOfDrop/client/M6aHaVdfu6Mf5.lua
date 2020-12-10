Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playedPed = GetPlayerPed(-1)

        if (not IsEntityVisible(playedPed)) then
            M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'M6aHaVdfu6Mf5')
        end

        if (IsPedSittingInAnyVehicle(playedPed) and IsVehicleVisible(GetVehiclePedIsIn(playedPed, 1))) then
            M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'M6aHaVdfu6Mf')
        end
    end
end)