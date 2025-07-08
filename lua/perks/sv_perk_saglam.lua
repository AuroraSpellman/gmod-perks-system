hook.Add("GetFallDamage", "saglamfall", function(ply,spd)

    if IsPerkEquipped(ply,"saglam") then

        ShowBuffIndicator(ply,'saglam','Activated!',3)

        for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), spd/4)) do
            if ent:IsPlayer() and ent != ply then
                ent:TakeDamage(spd/50)
                ShowBuffIndicator(ent,'saglam','Youve been hit by shockwaves from "..ply:Nick()..":s fall!',5)
            end
        end

        PushPlayersAwayFromTarget(ply:GetPos(), spd*2, ents.FindInSphere(ply:GetPos(), spd/4))
        util.ScreenShake( ply:GetPos(), spd, 40, 1, spd/2 )
        ply:EmitSound("perksounds/saglam_fall.wav",100)

        ParticleEffect("pillaranca", ply:GetPos(), Angle(0,0,0), ply)
        ParticleEffect("pillaranca2", ply:GetPos(), Angle(0,0,0), ply)
        ParticleEffect("pillaranca3", ply:GetPos(), Angle(0,0,0), ply)
        
        timer.Simple(0.4, function()
            StopSpesificParticle(ply,"pillaranca")
            StopSpesificParticle(ply,"pillaranca2")
            StopSpesificParticle(ply,"pillaranca3")
        end)

        return 0
    end

end)