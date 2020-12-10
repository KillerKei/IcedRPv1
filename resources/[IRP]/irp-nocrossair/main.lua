Citizen.CreateThread( function()
    while true do 
        if HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE')) then

        elseif not HasPedGotWeapon(PlayerPedId(), GetHashKey('WEAPON_SNIPERRIFLE')) then
            HideHudComponentThisFrame( 14 )		
        end
		Citizen.Wait( 0 )
    end 
end)