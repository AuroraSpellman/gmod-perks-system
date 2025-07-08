hook.Add("PlayerDeath", "perk_elveda_check", function(ply,inf,ent)
    if ent:IsPlayer() and ent != ply then
        if IsPerkEquipped(ply,"elveda") then

            local pos = ply:GetPos()
            ParticleEffect("elc_strong_thunderhull", pos, Angle(0,0,0)) 
            EmitSound(Sound("perksounds/zapzap.wav"), pos, 0, CHAN_AUTO, 1 , 100)
            ShowBuffIndicator(ply,'elveda','Initiated',4)
            timer.Create(ply:SteamID().."_zapper", 0.75, 4, function()
                for _,v in ipairs(ents.FindInSphere(pos, 500)) do
                    if v:IsPlayer() and v != ply then
                        if IsNotBlocked(pos, v) then
                            ShowBuffIndicator(v,'elveda','Affected',4)
                            v:TakeDamage(6)
                        end
                    end
                end

                if timer.RepsLeft(ply:SteamID().."_zapper") == 2 then
                    ParticleEffect("elc_strong_thunderhull", pos, Angle(0,0,0)) 
                end
            end)

        end
    end
end)



