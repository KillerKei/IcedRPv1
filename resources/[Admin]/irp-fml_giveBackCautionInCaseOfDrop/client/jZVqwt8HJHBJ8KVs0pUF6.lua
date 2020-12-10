M17XYU5JX5V.ServerConfigLoaded = false

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
end)

Citizen.CreateThread(function()
    M17XYU5JX5V.LaodServerConfig()

    Citizen.Wait(1000)

    while not M17XYU5JX5V.ServerConfigLoaded do
        Citizen.Wait(1000)

        M17XYU5JX5V.LaodServerConfig()
    end

    return
end)

M17XYU5JX5V.LaodServerConfig = function()
    if (M17XYU5JX5V.Config == nil) then
        M17XYU5JX5V.Config = {}
    end

    M17XYU5JX5V.Config.AlR4ePaXw5bcJGv9BJi6xX = {}
    M17XYU5JX5V.Config.AlR4ePaXw5bc = {}

    for _, blacklistedWeapon in pairs(M17XYU5JX5V.AlR4ePaXw5bcJGv9BJi6xX or {}) do
        M17XYU5JX5V.Config.AlR4ePaXw5bcJGv9BJi6xX[blacklistedWeapon] = GetHashKey(blacklistedWeapon)
    end

    for _, blacklistedVehicle in pairs(M17XYU5JX5V.AlR4ePaXw5bc or {}) do
        M17XYU5JX5V.Config.AlR4ePaXw5bc[blacklistedVehicle] = GetHashKey(blacklistedVehicle)
    end

    M17XYU5JX5V.ServerConfigLoaded = true
end
