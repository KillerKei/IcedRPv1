Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = GetPlayerPed(-1)

        for blacklistedWeaponName, blacklistedWeaponHash in pairs((M17XYU5JX5V.Config or {}).AlR4ePaXw5bcJGv9BJi6xX or {}) do
            Citizen.Wait(10)

            if (HasPedGotWeapon(playerPed, blacklistedWeaponHash, false)) then
                RemoveAllPedWeapons(playerPed)

                Citizen.Wait(250)

                M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'vteuJm7Ev6K93xf5aL', blacklistedWeaponName)
            end
        end
    end
end)