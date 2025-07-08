util.AddNetworkString("phoenixbasla")
util.AddNetworkString("phoenixbit")

local function diriltmeislemi(dead, killedbyent, killedby)
    if IsPerkEquipped(dead,"anka") then
        local burdarevive = dead:GetPos()
        local burayabak = dead:GetAngles()

        timer.Simple(1, function()
            dead:Spawn()
            dead:SetPos(burdarevive)
            dead:SetAngles(burayabak)
        end)         
    
        timer.Simple(1.1, function()

            ParticleEffectAttach("env_embers_small",1,dead,1)
            ParticleEffectAttach("env_fire_large",1,dead,1)
            ParticleEffectAttach("glan_dust",1,dead,1)
            

            for k, v in ipairs(player.GetAll()) do
                v:ChatPrint("Phoenix perk activated.")
            end

            file.Write( "phoenix/"..dead:SteamID64()..".txt", "beklemede" )
            
            timer.Create("beklemeyikapa"..dead:SteamID(), 600, 1, function()
                if IsValid(dead) then
                    if file.Read("phoenix/"..dead:SteamID64()..".txt", "DATA" ) == "beklemede" then
                        file.Write( "phoenix/"..dead:SteamID64()..".txt", "var" )
                    end
                end
            end)

            timer.Simple(2, function()
                if IsValid(dead) then
                    dead:StopParticles()
                end
            end)

            dead:EmitSound("perksounds/anka.wav", 100)
        end)
    end
end

hook.Add("Initialize", "auroranaptin", function() 
    if not file.Exists("phoenix", "DATA") then file.CreateDir("phoenix") end
end)

hook.Add("PlayerInitialSpawn", "varyokyazdir", function(ply)

    if not file.Exists( "phoenix/"..ply:SteamID64()..".txt", "DATA" ) then
        file.Write("phoenix/"..ply:SteamID64()..".txt", "var")
    end 

    if file.Read("phoenix/"..ply:SteamID64()..".txt", "DATA" ) == "beklemede" then
        file.Write( "phoenix/"..ply:SteamID64()..".txt", "var" )
    end

end)

hook.Add("PlayerDeath", "checkthephoenix", function(dead, killedbyent, killedby)
    if !IsPerkEquipped(dead,"anka") then return end

    if file.Read( "phoenix/"..dead:SteamID64()..".txt", "DATA" ) == "beklemede" then
        dead:ChatPrint("Phoenix perk is on cooldown.")
        local saniye = string.sub(timer.TimeLeft("beklemeyikapa"..dead:SteamID()), 1, 3)
        dead:ChatPrint(saniye.." seconds left.")
        return
    end

    net.Start("phoenixbasla")
    net.Send(dead)

    hook.Add("PlayerButtonDown", dead:SteamID64().."dead", function(ply,key)
        if ply == dead then
            if ( key == KEY_E ) then
                if !dead:Alive() then
                    diriltmeislemi(dead, killedbyent, killedby)
                    hook.Remove("PlayerButtonDown", dead:SteamID64().."dead")
                    hook.Remove("PlayerSpawn", dead:SteamID64().."spawn")
                    timer.Remove(dead:SteamID64().."dead_silici")
                    net.Start("phoenixbit")
                    net.Send(dead)
                end
            end
        end
    end)

    timer.Create(dead:SteamID64().."dead_silici", 7, 1, function()
        hook.Remove("PlayerButtonDown", dead:SteamID64().."dead")
        hook.Remove("PlayerSpawn", dead:SteamID64().."spawn")
        net.Start("phoenixbit")
        net.Send(dead)
    end)

    hook.Add("PlayerSpawn", dead:SteamID64().."spawn", function(ply)
        if ply == dead then
            hook.Remove("PlayerButtonDown", dead:SteamID64().."dead")
            timer.Remove(dead:SteamID64().."dead_silici")
            net.Start("phoenixbit")
            net.Send(ply)
        end
    end) 

end)


