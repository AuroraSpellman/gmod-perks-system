
hook.Add( "EntityTakeDamage", "perk_deler", function( target, dmginfo ) -- key

    local ply = dmginfo:GetAttacker()
    local sekti = false

    if ply:IsPlayer() and target:IsPlayer() then
        if IsPerkEquipped(ply,"deler") then
            for k,v in ipairs(ents.FindInSphere(target:GetPos(), 200)) do
                if v:IsPlayer() and v != ply and v != target then
                    if dmginfo:GetDamage() < 100 and !sekti then
                        
                        v:TakeDamage(dmginfo:GetDamage()*.5)--,ply,ply)
                        ParticleEffectAttach("[4]arcs_electric_1", 2, v, 1)
                        timer.Simple(0.5, function()
                            StopSpesificParticle(v,"[4]arcs_electric_1")
                        end)
                        ShowBuffIndicator(v,'deler','DMG bounced to you from a nearby player.',5)
                        ShowBuffIndicator(ply,'deler','DMG bounced to a nearby playher.',5)

                        sekti = true

                    end
                end
            end

            if !sekti then
                target:TakeDamage(dmginfo:GetDamage()*.1)
                ShowBuffIndicator(ply,'deler','No-one to bounce, %10 dmg boost.',5)
            end
        end
    end

end)