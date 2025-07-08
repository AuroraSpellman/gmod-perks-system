hook.Add( "EntityTakeDamage", "perk_aynaxdxd", function( target, dmginfo )
    local ply = dmginfo:GetAttacker()
    if ply:IsPlayer() and target:IsPlayer() then
        if IsPerkEquipped(target,"aynaxdxd") and ply != target then 
            if dmginfo:GetDamage() < 100 and !ply:HasGodMode() then
                ShowBuffIndicator(ply,'aynaxdxd',math.Round((dmginfo:GetDamage()*.25))..' damage reflected back to you!',3)
                ply:TakeDamage(math.Round((dmginfo:GetDamage()*.25)))--,target,target)
                
                target:EmitSound("perksounds/mirrored.wav",50)

                ParticleEffectAttach("aes_spawer", 2, target, 1)
                timer.Simple(0.2, function()
                    StopSpesificParticle(target,"aes_spawer") 
                end)
            end
        end
    end
end)