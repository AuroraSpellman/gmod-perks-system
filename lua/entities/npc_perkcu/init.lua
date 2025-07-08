AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("perk_config.lua")
include("zconfig_override.lua")

util.AddNetworkString("perk_satma")
util.AddNetworkString("bacimperkgonder")
util.AddNetworkString("perkcu_konusma")
util.AddNetworkString("buybundle")

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD) 
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)

	if !file.Exists("kisi_perkleri/konusanlar.txt", "DATA") then
		file.Write("kisi_perkleri/konusanlar.txt", "STEAM_0:0:0")
	end
end  
  
function ENT:AcceptInput(inpt, activator, caller)
	if (inpt == "Use" and activator:IsPlayer()) then

		PERKSYSTEM.distrubite_perk_prices(activator)

		if !string.find(file.Read("kisi_perkleri/konusanlar.txt","DATA"), activator:SteamID()) then --PerkCount(activator) == 1 and
			net.Start("perkcu_konusma") 
			net.WriteTable(PERKSYSTEM.konusmalar[PERKSYSTEM.lan_config])
			net.WriteString(InitialPerk(activator))
			net.Send(activator)
			file.Append("kisi_perkleri/konusanlar.txt", "\n"..activator:SteamID())
		else
			net.Start("perk_satma")
			net.WriteString(file.Read("kisi_perkleri/"..activator:SteamID64().."_perk.txt", "DATA"))
       	 	net.WriteString(file.Read("kisi_perkleri/"..activator:SteamID64().."_aktifperk.txt", "DATA"))
			net.Send(activator)
		end
		
	end
end

net.Receive("perkcu_konusma", function(_,ply)
	net.Start("perkcu_konusma") 
	net.WriteTable(PERKSYSTEM.konusmalar[PERKSYSTEM.lan_config])
	net.WriteString(InitialPerk(ply))
	net.Send(ply)
end)

net.Receive("perk_satma", function(len,ply)
	net.Start("perk_satma")
	net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA"))
	net.WriteString(file.Read("kisi_perkleri/"..ply:SteamID64().."_aktifperk.txt", "DATA"))
	net.Send(ply)
end)

net.Receive("bacimperkgonder", function(len, ply)
	local alinan = net.ReadString()

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
			ply:ChatPrint("You already own this perk!")
		else
			if ChargeAndPrint(ply,PERKSYSTEM.fiyatlar[alinan],true) then
				file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..alinan)
			end
		end
	else
		if tumperkleri == alinan then
			ply:ChatPrint("You already own this perk!")
		else
			if ChargeAndPrint(ply,PERKSYSTEM.fiyatlar[alinan],true) then
				file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..alinan)
			end
		end
	end
end)

net.Receive("buybundle", function(len,ply)
	local alinan = net.ReadInt(32)

	local perk1 = PERKSYSTEM.bundles[alinan][2]
	local perk2 = PERKSYSTEM.bundles[alinan][3]
	local toplam = (PERKSYSTEM.fiyatlar[perk1] + PERKSYSTEM.fiyatlar[perk2]) 
	toplam = toplam - toplam * PERKSYSTEM.bundles[alinan][4] / 100

	local tumperkleri = file.Read("kisi_perkleri/"..ply:SteamID64().."_perk.txt", "DATA")
    if string.find(tumperkleri, ",") then
        tumperkleri = string.Split(tumperkleri, ",")
	end
	if !istable(tumperkleri) then tumperkleri = {tumperkleri} end

	local tumperkleri_lookup = {}
	for _, v in ipairs(tumperkleri) do
		tumperkleri_lookup[v] = true
	end
	
	
	if tumperkleri_lookup[perk1] or tumperkleri_lookup[perk2] then
		ply:ChatPrint("You already own at least one of these perks!")
	else
		if ChargeAndPrint(ply,toplam,true) then
			file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..perk1)
			file.Append("kisi_perkleri/"..ply:SteamID64().."_perk.txt", ","..perk2)
		end
	end
end)

function ChargeAndPrint(ply, fiyat, perkmu) --global perklerde de kullanilio
	
	if !DarkRP then 
		if perkmu then
			ply:ChatPrint("Sucessfully Obtained!")
		end
		return true
	else
		if ply:canAfford(fiyat) then
			ply:addMoney(-fiyat)
			if perkmu then
				ply:ChatPrint("Purchase Sucessful!")
			end
			return true
		else
			ply:ChatPrint("INSUFFICENT FUNDS!")
			return false
		end
	end
	
end
