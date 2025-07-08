hook.Add( "EntityTakeDamage", "perk_birlikte", function( target, dmginfo ) -- key

    local ply = target

    if ply:IsPlayer() then
        if IsPerkEquipped(ply,"birlikte") then
            local gucarttirici = 0
            for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do
                if v:IsPlayer() and v != ply  and v != target then
                    gucarttirici = gucarttirici + 1
                end
            end

            if gucarttirici > 0 then
                local dmg = dmginfo:GetDamage() 
                dmg = dmg - (dmg * 5 / 100)
                dmginfo:SetDamage(dmg) 
                ShowBuffIndicator(ply,'birlikte','"..gucarttirici.." people around. %"..(1/20*gucarttirici*100).." damage dodged!',3)
            end
        end
    end

end) 