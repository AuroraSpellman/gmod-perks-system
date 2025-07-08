hook.Add( "EntityTakeDamage", "perk_becerikli", function( target, dmginfo ) 
    local ply = dmginfo:GetAttacker()
    if ply:IsPlayer() then
        if IsPerkEquipped(ply,"becerikli") then
            local ilk = dmginfo:GetDamage()
            dmginfo:ScaleDamage( tonumber("1."..math.random(2, 4)) )
            local son = dmginfo:GetDamage()

            if math.floor(son-ilk) > 0 then
                ShowBuffIndicator(ply,'becerikli','+"..math.floor(son-ilk).." damage support.',2)
            end
        end
    end
end)