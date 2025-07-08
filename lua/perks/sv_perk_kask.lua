hook.Add("PlayerSpawn", "perk_kask", function( ply ) 

    if IsPerkEquipped(ply,"kask") then
        ply:SetArmor(ply:Armor()+10)
        ShowBuffIndicator(ply,'kask','+10 armor.',10)
    end

end)