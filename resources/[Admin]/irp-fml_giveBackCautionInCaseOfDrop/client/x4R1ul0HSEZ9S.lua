M17XYU5JX5V.RegisterClientEvent('irp-fml_giveBackCautionInCaseOfDrop:fhhY13bnv6Jd', function(newToken)
    if (M17XYU5JX5V.SecurityTokens == nil) then
        M17XYU5JX5V.SecurityTokens = {}
    end

    M17XYU5JX5V.SecurityTokens[newToken.name] = newToken
end)

M17XYU5JX5V.GetResourceToken = function(resource)
    if (resource ~= nil) then
        local securityTokens = M17XYU5JX5V.SecurityTokens or {}
        local resourceToken = securityTokens[resource] or {}
        local token = resourceToken.token or nil

        return token
    end

    return nil
end