hook.Add( "EntityTakeDamage", "perk_dost", function( target, dmginfo ) -- key

    local ply = dmginfo:GetAttacker()

    if ply:IsPlayer() then
        if IsPerkEquipped(ply,"dost") then
            local gucarttirici = 0
            for k, v in ipairs(ents.FindInSphere(ply:GetPos(), 600)) do
                if v:IsPlayer() and v != ply  and v != target then
                    gucarttirici = gucarttirici + 1
                end
            end

            print(gucarttirici)
            if gucarttirici > 0 then
                dmginfo:ScaleDamage(1 + ((1/20)*gucarttirici)) 
                ShowBuffIndicator(ply,'dost','"..gucarttirici.." people around. %"..(1/20*gucarttirici*100).." damage increase!',3)
            end
        end
    end

end)