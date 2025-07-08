hook.Add( "EntityTakeDamage", "perk_xp", function( target, dmginfo ) -- key

    local ply = dmginfo:GetAttacker()

    if ply:IsPlayer() then

        if IsPerkEquipped(ply,"xp") then
            if ply:GetNWInt("xpcombocount",1) != 0 then
                dmginfo:ScaleDamage( 1 + ply:GetNWInt("xpcombocount",0)/20) 
            end
        end

    end

end)

hook.Add( "PlayerDeath", "XPComboPerk", function( ply,ent1,ent2 )
    if ent2:IsPlayer() then
        local ply = ent2
        if IsPerkEquipped(ply,"xp") then
            ply:SetNWInt("xpcombocount", ply:GetNWInt("xpcombocount", 0)+1)

            ShowBuffIndicator(ply,'xp','"..(ply:GetNWInt("xpcombocount", 0)).."X COMBO: %"..(((1/20)*ply:GetNWInt("xpcombocount", 0))*100).." damage increase!',30)

            if timer.Exists(ply:SteamID().."xpcombocount") then
                timer.Remove(ply:SteamID().."xpcombocount")
            end

            timer.Create(ply:SteamID().."xpcombocount", 30, 0, function()
                ply:SetNWInt("xpcombocount", 0)
            end)
        end
    end
end )  