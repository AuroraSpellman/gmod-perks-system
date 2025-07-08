hook.Add( "EntityTakeDamage", "perk_kanicen", function( target, dmginfo ) 

    local ply = dmginfo:GetAttacker()

    if ply:IsPlayer() and target:IsPlayer() then
        if IsPerkEquipped(ply,"kanicen") then
            local yenican = math.Clamp(ply:Health()+math.Round((dmginfo:GetDamage()*.1)), 1, ply:GetMaxHealth())
            ply:SetHealth( yenican )
            ShowBuffIndicator(ply,'kanicen','"..math.Round((dmginfo:GetDamage()*.1)).." health stolen.',4)
        end
    end

end)
