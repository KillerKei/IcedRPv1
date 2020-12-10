Citizen.CreateThread(function()
    local timesDetected = 0

    while true do
        local config = M17XYU5JX5V.Config or {}
        local check = config.GodMode or false

        if (timesDetected >= 10) then
            M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'HAKnDrcPv6eeNR')
        end

        if (check) then
            local playerId      = PlayerId()
            local playerPed     = GetPlayerPed(-1)
            local health        = GetEntityHealth(playerPed)

            if (health > 200) then
                M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'HAKnDrcPv6eeNR')
            end

            SetPlayerHealthRechargeMultiplier(playerId, 0.0)
            SetEntityHealth(playerPed, health - 2)

            Citizen.Wait(50)

            if (GetEntityHealth(playerPed) > (health - 2)) then
                timesDetected = timesDetected + 1
            elseif(timesDetected > 0) then
                timesDetected = timesDetected - 1
            end

            SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 2)
        else
            Citizen.Wait(1000)
        end
    end
end)