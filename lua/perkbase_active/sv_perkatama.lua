util.AddNetworkString("perkverbana")
util.AddNetworkString("StopSpesificParticle")
util.AddNetworkString("perkmenuac")
util.AddNetworkString("perkcikarildi")
util.AddNetworkString("aktifperkkullanildi")
util.AddNetworkString("perktakildi")
util.AddNetworkString("oldubukisi")
util.AddNetworkString("BS_Sifirla")
util.AddNetworkString("RunGesture")
util.AddNetworkString("ShowBuffIndicator")
util.AddNetworkString("UpdateCharges")

local randomstarter = {"kask","imdat"}

hook.Add("PlayerInitialSpawn", "girdinalsanaperk", function(ply) --Initial data setup, give one random common perk if first time creating data.
    if !file.Exists("kisi_perkleri", "DATA") then
        file.CreateDir("kisi_perkleri")
    end

    if !file.Exists("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA") then
        local playeragelen = randomstarter[math.random(1, #randomstarter)]
        file.Write("kisi_perkleri/"..ply:SteamID64().."_perk.txt", playeragelen)
        file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", playeragelen)
        net.Start("perkverbana")
        net.WriteString(playeragelen)
        net.Send(ply)
    else
        net.Start("perkverbana")
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA")) 
        net.Send(ply)
    end
end)

hook.Add("PlayerSay", "takcikarmenusu", function(ply,text) --Player perk menu
    text = string.lower( text )
    if text == "/perkmenu" or text == "/perkler" or text == "/perk" then
        net.Start("perkmenuac")
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA"))
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
        net.Send(ply)
    end
end)

net.Receive("perkmenuac", function(_,ply)

    local nearmerchant = false

    for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 300)) do 
        if v:GetClass() == "npc_perkcu" then
            nearmerchant = true
        end
    end

    if nearmerchant and PERKSYSTEM.merhcant_vault then
        net.Start("perkmenuac")
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA"))
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
        net.Send(ply)
    elseif PERKSYSTEM.merhcant_vault then
        ply:ChatPrint("[PERKS] You need to be near a merchant to acess your vault!")
    else
        net.Start("perkmenuac")
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA"))
        net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
        net.Send(ply)
    end
end)

net.Receive("perkcikarildi", function(_, ply) --Perk Unequipped
    local cikarilan = net.ReadString()
    local astart, aend = string.find(cikarilan, ".png")
    cikarilan = string.sub(cikarilan, 14, astart-1)

    hook.Call("OnPerkUneqipped", GAMEMODE, ply, cikarilan)
    if cikarilan == "hormonlu" then ply:SetNWBool("hormon", false) end

    local aktifleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA")
    if string.find(aktifleri, ",") then
        aktifleri = string.Split(aktifleri, ",")
    end

    if istable(aktifleri) then
        for i,v in ipairs(aktifleri) do
            if v == cikarilan then
                table.remove(aktifleri, i)
            end
        end

        for k,v in ipairs(aktifleri) do
            if #aktifleri > 1 then
                if k == 1 then
                    file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", aktifleri[k])
                else
                    file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..aktifleri[k])
                end
            else
                file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", aktifleri[1])
            end
        end
    else
        file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", " ")
    end

    net.Start("perkverbana")
    net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
    net.Send(ply)

end)

net.Receive("perktakildi", function(_, ply) --Perk Equipped
    local takilan = net.ReadString()
    hook.Call("OnPerkEquipped", GAMEMODE, ply, takilan)

    local tumperkleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    if string.find(tumperkleri, ",") then
        tumperkleri = string.Split(tumperkleri, ",")
    end

    local aktifleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA")
    if string.find(aktifleri, ",") then
        aktifleri = string.Split(aktifleri, ",")
    end

    if istable(tumperkleri) then

        local tumperkleri_lookup = {}
        for _, v in ipairs(tumperkleri) do
            tumperkleri_lookup[v] = true
        end       

        if tumperkleri_lookup[takilan] then
            if istable(aktifleri) then
                if #aktifleri < 4 then
                    file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..takilan)
                end
            else
                if aktifleri != " " then
                    file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..takilan)
                else
                    file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", takilan)
                end
            end
        end
    else
        if tumperkleri == takilan then
            if istable(aktifleri) then
                if #aktifleri < 4 then
                    file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..takilan)
                end
            else
                if aktifleri != " " then
                    file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..takilan)
                else
                    file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", takilan)
                end
            end 
        end
    end

    net.Start("perkverbana")
    net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
    net.Send(ply)

    net.Start("perkmenuac")
    net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA"))
    net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
    net.Send(ply)

end)

function IsPerkEquipped(ply,perk) --Check if perk is equipped by player
    local takilimiki = false
    local takilan = file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA")
    if string.find(takilan, ",") then
        takilan = string.Split(takilan, ",")
    end

    if istable(takilan) then
        for k, v in ipairs(takilan) do
            if v == perk then
                takilimiki = true
            end
        end

        if takilimiki then
            return true
        else
            return false
        end
    else
        if takilan == perk then
            return true
        else
            return false
        end
    end
end

function PerkCount(ply) --Check players perk count
    local takilan = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    if string.find(takilan, ",") then
        takilan = string.Split(takilan, ",")
    end

    if istable(takilan) then
        return #takilan
    else
        return 1
    end
end

function InitialPerk(ply) --Check players first perk
    local takilan = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    if string.find(takilan, ",") then
        takilan = string.Split(takilan, ",")
    end 

    if istable(takilan) then
        return takilan[1]
    else
        return takilan
    end
end

function GivePerk(ply,alinan) --Give perk
	local tumperkleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    if string.find(tumperkleri, ",") then
        tumperkleri = string.Split(tumperkleri, ",")
	end
	
	if istable(tumperkleri) then
        local tumperkleri_lookup = {}
        for _, v in ipairs(tumperkleri) do
            tumperkleri_lookup[v] = true
        end       

		if tumperkleri_lookup[alinan] then
			ply:ChatPrint("You already own this perk.")
		else
			file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..alinan)
		end
	else
		if tumperkleri == alinan then
			ply:ChatPrint("You already own this perk.")
		else
		    file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..alinan)
		end
	end
end

function RemovePerk(ply,alinan) --Remove perk
	local tumperkleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    local tumperkleri1 = file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA")
    if string.find(tumperkleri, ",") then
        tumperkleri = string.Split(tumperkleri, ",")
	end
    if string.find(tumperkleri1, ",") then
        tumperkleri1 = string.Split(tumperkleri1, ",")
    end

	if istable(tumperkleri) then
        local tumperkleri_lookup = {}
        for _, v in ipairs(tumperkleri) do
            tumperkleri_lookup[v] = true
        end       

		if tumperkleri_lookup[alinan] then
			ply:ChatPrint(alinan.." perk'ünüz silindi!")
            for k, v in ipairs(tumperkleri) do
                if k == 1 then
                    if alinan != v then
                        file.Write("kisi_perkleri/"..ply:SteamID64().."_perk.txt", tumperkleri[k])
                    else
                        file.Write("kisi_perkleri/"..ply:SteamID64().."_perk.txt", tumperkleri[k+1])
                    end
                else
                    if alinan != v then
                        if !string.find(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt"), tumperkleri[k]) then
                            file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..tumperkleri[k])
                        end
                    end
                end
            end
		end
	else
		if tumperkleri == alinan then
			ply:ChatPrint(alinan.." perk'ünüz silindi!")
			file.Write("kisi_perkleri/"..ply:SteamID64().."_perk.txt", " ")
		end
	end

      if istable(tumperkleri1) then
        local tumperkleri1_lookup = {}
        for _, v in ipairs(tumperkleri1) do
            tumperkleri1_lookup[v] = true
        end       
		if tumperkleri1_lookup[alinan] then
			ply:ChatPrint(alinan.." perk'ünüz silindi!")
            for k, v in ipairs(tumperkleri1) do
                if k == 1 then
                    if alinan != v then
                        file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", tumperkleri1[k])
                    else
                        file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", tumperkleri1[k+1])
                    end
                else
                    if alinan != v then
                        if !string.find(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt"), tumperkleri1[k]) then
                            file.Append("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", ","..tumperkleri1[k])
                        end
                    end
                end
            end
		end
	else
		if tumperkleri1 == alinan then
			ply:ChatPrint(alinan.." perk'ünüz silindi!")
			file.Write("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", " ")
		end
	end

    net.Start("perkverbana")
    net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
    net.Send(ply)
end

function StopSpesificParticle(ply,particle) --Self explanatory
    net.Start("StopSpesificParticle")
    net.WriteEntity(ply)
    net.WriteString(particle)
    net.Broadcast()
end

function RunGesture(ply,gesture)
    net.Start("RunGesture")
    net.WriteInt(gesture, 32)
    net.WriteEntity(ply)
    net.Broadcast()
end

function IsNotBlocked(pos, player2)
    if not IsValid(player2) then
        return false
    end

    local startPos = pos
    local endPos = player2:EyePos()

    local trace = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = {player1, player2},
        mask = MASK_BLOCKLOS
    })

    return not trace.Hit
end

function PushPlayersAwayFromTarget(targetPos, force, players) 
    if !istable(players) then players = {players} end

    for _, ply in ipairs(players) do
        if ply != targetPlayer then
            local direction = (ply:GetPos() - targetPos):GetNormalized()
            local velocity = direction * force
            ply:SetVelocity(velocity)
        end
    end
end

function ShowBuffIndicator(ply, perk, buff, length)
    net.Start("ShowBuffIndicator")
    net.WriteString(perk)
    net.WriteString(buff)
    net.WriteInt(length,32)
    net.Send(ply)
end

concommand.Add("perk_remove", function(_,cmd,args)
    local biribuldum = 0
    local sonbulunan

    for _,v in ipairs(player.GetAll()) do
        if string.find(string.lower(v:Nick()),string.lower(args[1])) then
            biribuldum = biribuldum + 1
            sonbulunan = v
        end
    end

    for _, v in ipairs(PERKSYSTEM.perks) do
        if v == args[2] then
            if biribuldum == 1 and sonbulunan then
                RemovePerk(sonbulunan, v)
                print("You granted "..sonbulunan:Nick().." a "..PERKSYSTEM.isimler[PERKSYSTEM.lan_config][v].." perk.")
            end 
        end
    end

    if !args[1] or !args[2] then
        print("perk_remove PLYName PerkCode")
    elseif biribuldum == 0 then
        print("No one with the "..args[1].." nick has been found.")
    elseif biribuldum>1 then
        print("Multiple players with "..args[1].." nick has been found.")
    end

end) 

concommand.Add("perk_give", function(_,cmd,args)

    local biribuldum = 0
    local sonbulunan

    for _,v in ipairs(player.GetAll()) do
        if string.find(string.lower(v:Nick()),string.lower(args[1])) then
            biribuldum = biribuldum + 1
            sonbulunan = v
        end
    end

    for _, v in ipairs(PERKSYSTEM.perks) do
        if v == args[2] then
            if biribuldum == 1 and sonbulunan then
                GivePerk(sonbulunan, v)
                print("You granted "..sonbulunan:Nick().." a "..PERKSYSTEM.isimler[PERKSYSTEM.lan_config][v].." perk.")
            end 
        end
    end

    if !args[1] or !args[2] then
        print("perk_give PLYName PerkCode")
    elseif biribuldum == 0 then
        print("No one with the "..args[1].." nick has been found.")
    elseif biribuldum>1 then
        print("Multiple players with "..args[1].." nick has been found.")
    end

end) 

concommand.Add("perk_reset", function(_,cmd,args)
    local biribuldum = 0
    local sonbulunan

    for _,v in ipairs(player.GetAll()) do
        if string.find(string.lower(v:Nick()),string.lower(args[1])) then
            biribuldum = biribuldum + 1
            sonbulunan = v
        end
    end

    if !args[1] then
        print("perk_reset PLYName")
    elseif biribuldum == 0 then
        print("No one with the "..args[1].." nick has been found.")
    elseif biribuldum>1 then
        print("Multiple players with "..args[1].." nick has been found.")
    end

    if biribuldum == 1 and sonbulunan then
        local playeragelen = randomstarter[math.random(1, #randomstarter)]
        file.Write("kisi_perkleri/"..sonbulunan:SteamID64().."_perk.txt", playeragelen)
        file.Write("kisi_perkleri/"..sonbulunan:SteamID64().."_aktifperk.txt", playeragelen)
        net.Start("perkverbana")
        net.WriteString(playeragelen)
        net.Send(sonbulunan)

        print("Player's perks are resetted.")
    end
end)