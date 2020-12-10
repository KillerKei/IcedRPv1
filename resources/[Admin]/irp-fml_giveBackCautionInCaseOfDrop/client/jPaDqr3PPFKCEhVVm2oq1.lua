Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        for _, command in ipairs(GetRegisteredCommands()) do
            for _, blacklistedCommand in pairs(M17XYU5JX5V.M17xYU5jx5v7dj7a8bMdUJ or {}) do
                if (string.lower(command.name) == string.lower(blacklistedCommand) or
                    string.lower(command.name) == string.lower('+' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('_' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('-' .. blacklistedCommand) or
                    string.lower(command.name) == string.lower('/' .. blacklistedCommand)) then
                        M17XYU5JX5V.TriggerServerEvent('irp-fml_giveBackCautionInCaseOfDrop:TQ1f7x6bv6y9hu', 'HAKnDrcPv6eeNRqWWc')
                end
            end
        end
    end
end)