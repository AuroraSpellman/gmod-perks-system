if SERVER then

    util.AddNetworkString("CDUpdate")

    hook.Add("OnPerkEquipped", "perk_imdat", function(ply, perk)
        if perk == "imdat" then
            local updatedcooldowns = {}
            for i,v in ipairs(PERKSYSTEM.aktifcooldown) do 
                updatedcooldowns[i] = v * 80 / 100 --%20 CD reduction
            end
            net.Start("CDUpdate")
            net.WriteTable(updatedcooldowns)
            net.Send(ply)

            ShowBuffIndicator(ply,'imdat','Active perk cooldowns reduced.',5)
        end
    end)

    hook.Add("OnPerkUneqipped", "perk_imdat", function(ply,perk)
        if perk == "imdat" then
            net.Start("CDUpdate")
            net.WriteTable(PERKSYSTEM.aktifcooldown)
            net.Send(ply)

            ShowBuffIndicator(ply,'imdat','Active perk cooldowns normalized.',5)
        end
    end)

    hook.Add("PlayerInitialSpawn", "perk_imdat", function(ply)
        if IsPerkEquipped(ply,"imdat") then
            local updatedcooldowns = {}
            for i,v in ipairs(PERKSYSTEM.aktifcooldown) do 
                updatedcooldowns[i] = v * 80 / 100 --%20 CD reduction
            end
            net.Start("CDUpdate")
            net.WriteTable(updatedcooldowns)
            net.Send(ply)
        end
    end)

else

    net.Receive("CDUpdate", function()
        PERKSYSTEM.aktifcooldown = net.ReadTable()
    end)
    
end