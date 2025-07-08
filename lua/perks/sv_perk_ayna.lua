hook.Add("EntityTakeDamage", "CanHavli", function( target, dmginfo ) 

    local ply = dmginfo:GetAttacker()

    if target:IsPlayer() then
        if IsPerkEquipped(target,"ayna") then
            if !target:GetNWBool("fastafboi") and !target:GetNWBool("tetiklendi") and target:Health() > dmginfo:GetDamage() and (target:Health()-dmginfo:GetDamage()) < 25 then
                target:SetNWInt("InitWalkSpeed",target:GetWalkSpeed()) -- 400
                target:SetNWInt("InitRunSpeed",target:GetRunSpeed()) -- 600
                target:SetRunSpeed(target:GetRunSpeed()+200)
                target:SetWalkSpeed(target:GetWalkSpeed()+200)
                target:SetNWBool("fastafboi",true)
                target:SetNWBool("tetiklendi",true)

                local trail = util.SpriteTrail(target, 0, Color(168, 50, 98), false, 75, 0, 1.5, 1 / ( 75 ) * 0.5,"trails/plasma.cmt")

                ShowBuffIndicator(target,'ayna','Health below 25, temporary speed boost.',10)
                timer.Create(target:SteamID().."fastafboi", 10, 1, function()
                    if target:IsValid() then
                        target:SetNWBool("fastafboi", false)
                        target:SetWalkSpeed(target:GetNWInt("InitWalkSpeed",400))
                        target:SetRunSpeed(target:GetNWInt("InitRunSpeed",600))
                    else
                        timer.Remove(target:SteamID().."fastafboi")
                    end

                    SafeRemoveEntity(trail)
                end)
            elseif !target:GetNWBool("fastafboi") and (target:Health()-dmginfo:GetDamage()) >= 25 then
                target:SetNWBool("tetiklendi",false)
            end
        end
    end

end)