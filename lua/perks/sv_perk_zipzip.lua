hook.Add("ScalePlayerDamage", "perk_zipzip_activate", function(_,hgroup,dmginfo )
    local ply = dmginfo:GetAttacker()
    if ply:IsPlayer() then
        if hgroup == 1 then
            if IsPerkEquipped(ply,"zipzip") then
                
                ShowBuffIndicator(ply,'zipzip','Charge earned!',2)
                local newcharge = ply:GetPData("JCharges",0) + 3

                if newcharge>=12 then
                    newcharge = 12
                    ShowBuffIndicator(ply,'zipzip','Max charge!',2)
                end
                
                ply:SetPData("JCharges",newcharge)
                net.Start("UpdateCharges")
                net.WriteInt(ply:GetPData("JCharges",0), 32)
                net.Send(ply)
            end
        end
    end
end) 

local function DoubleJump(ply)
    local currentCharges = ply:GetPData("JCharges",0)

    if tonumber(currentCharges) >= 1 then
        ply:SetPData("JCharges", currentCharges - 1)
        ply:EmitSound("perksounds/jump.wav")

        net.Start("UpdateCharges")
        net.WriteInt(tonumber(currentCharges) - 1, 32)
        net.Send(ply)

        ShowBuffIndicator(ply,'zipzip','Jump!',1)

        local velocity = ply:GetVelocity()
        local additionalJumpForce = 300 
        local adjuster = 0 
        velocity.z = additionalJumpForce
        local forward = ply:EyeAngles():Forward()
        local right = ply:EyeAngles():Right()
        forward.z = 0
        right.z = 0
        forward:Normalize()
        right:Normalize()
        velocity = velocity + (forward * adjuster)
        ply:SetVelocity(velocity)
    end
end

hook.Add("KeyPress", "perk_zipzip_doublejump", function(ply, key)
    if key == IN_JUMP and !ply:IsOnGround() and ply:GetMoveType() != MOVETYPE_NOCLIP then
        if IsPerkEquipped(ply,"zipzip") then
            DoubleJump(ply)
        end
    end
end)
