hook.Add("EntityFireBullets", "Mermi_unlimited", function(ent, data)
    if ent:IsPlayer() then
        if IsPerkEquipped(ent,"ammo") then
            local weapon = ent:GetActiveWeapon()
            if IsValid(weapon) and weapon:IsWeapon() then
                if weapon:GetPrimaryAmmoType() then
                    ShowBuffIndicator(ent,'ammo','Ammo support',0.25)
                    ent:SetAmmo(ent:GetAmmoCount(weapon:GetPrimaryAmmoType()) + 1, weapon:GetPrimaryAmmoType())
                end
            end
        end
    end
end)