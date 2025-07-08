hook.Add("EntityTakeDamage", "lutufCheck", function(target,dmginfo)
    
    local ply = dmginfo:GetAttacker()

    if target:IsPlayer() and ply:IsPlayer() then
        if IsPerkEquipped(ply,"lutuf") then
            if target:GetNWBool("canoccur", true) then
                target:Ignite(2.5)

                ShowBuffIndicator(target,'lutuf','Accuracy reduced, engulfed in Seraphic Flames!',2.5)

                timer.Create(target:SteamID().."iamconfusion", 0.25, 10, function()

                    if target:IsValid() then

                        local accuracyOffset = Angle(math.Rand(-5, 5), math.Rand(-5, 5), 0)
                        local currentAngles = target:EyeAngles()

                        target:SetEyeAngles(currentAngles + accuracyOffset)



                        target:SetNWBool("canoccur", false)

                        if timer.RepsLeft(target:SteamID().."iamconfusion") == 0 then
                            timer.Simple(20, function() -- 20 second cooldown until the affect can happen on the same person again.
                                if target:IsValid() then
                                    target:SetNWBool("canoccur", true)
                                end
                            end)
                        end


                    end

                end)

            end
        end
    end

end)