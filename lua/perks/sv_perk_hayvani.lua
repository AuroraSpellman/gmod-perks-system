hook.Add("OnEntityWaterLevelChanged", "perk_hayvani", function(ply,old,new)
    if ply:IsPlayer() then
        if IsPerkEquipped(ply,"hayvani") then
            if old < new then
                if new == 1 then 
                    ShowBuffIndicator(ply,'hayvani','Initiated.',1)
                    ParticleEffectAttach("jug_p3",1, ply, 1)
                    ply:SetNWInt("oldrunspeed", ply:GetRunSpeed())
                    ply:SetNWInt("oldwalkspeed", ply:GetWalkSpeed())
                    ply:SetRunSpeed( ply:GetRunSpeed()+ 500)
                    ply:SetWalkSpeed(ply:GetWalkSpeed()+ 500)
                    timer.Create("perk_hayvani_"..ply:SteamID(), 2, 0, function()
                        if IsPerkEquipped(ply,"hayvani") then
                            ply:SetHealth(math.Clamp(4+ply:Health(), 1, ply:GetMaxHealth()))
                            ShowBuffIndicator(ply,'hayvani','Water heals.',2)
                        end
                    end)
                end
            end
        end

        if new == 0 then
            StopSpesificParticle(ply,"jug_p3")
            ply:SetRunSpeed(ply:GetNWInt("oldrunspeed", 450))
            ply:SetWalkSpeed(ply:GetNWInt("oldwalkspeed", 300))
            if timer.Exists("perk_hayvani_"..ply:SteamID()) then
                timer.Remove("perk_hayvani_"..ply:SteamID())
            end
        end
    end
end)