AddCSLuaFile("zconfig_override.lua")

 
function PERKSYSTEM.re_define(data,name)
    local common_perk_price 
    local epic_perk_price
    local legendary_perk_price 
    local key_perk_price
    local active_perk_price
    if name == "common_perk_price" then
        common_perk_price = tonumber(data)
    elseif name == "epic_perk_price" then
        epic_perk_price = tonumber(data)
    elseif name == "legendary_perk_price" then
        legendary_perk_price = tonumber(data)
    elseif name == "key_perk_price" then 
        key_perk_price = tonumber(data)
    elseif name == "active_perk_price" then
        active_perk_price = tonumber(data)
    end
    for k,v in ipairs(PERKSYSTEM.perks) do 
        if !PERKSYSTEM.individual_pricing[v] then
            if table.HasValue(PERKSYSTEM.legendaryler, v) then
                if legendary_perk_price then
                    PERKSYSTEM.fiyatlar[v] = legendary_perk_price
                end
            elseif table.HasValue(PERKSYSTEM.epicler, v)then
                if epic_perk_price then
                    PERKSYSTEM.fiyatlar[v] = epic_perk_price
                end
            elseif table.HasValue(PERKSYSTEM.aktifler, v) then
                if active_perk_price then
                    PERKSYSTEM.fiyatlar[v] = active_perk_price
                end
            elseif table.HasValue(PERKSYSTEM.keyperk, v) then
                if key_perk_price then
                    PERKSYSTEM.fiyatlar[v] = key_perk_price
                end
            else
                if common_perk_price then
                    PERKSYSTEM.fiyatlar[v] = common_perk_price
                end
            end 
        end
    end

end

if SERVER then

    util.AddNetworkString("override_config")

    if !file.Exists("perkler", "DATA") then
        file.CreateDir("perkler")
    end

    function PERKSYSTEM.distrubite_perk_prices(ply)
        local txts = file.Find( "perkler/*.txt", "DATA" )

        if istable(txts) then
            for _, v in ipairs(txts) do

                local data = file.Read("perkler/"..v, "DATA")

                v = string.Split(v, ".")
                v = v[1]

                print(ply:Nick())
                net.Start("override_config") 
                net.WriteString(data)
                net.WriteString(v)
                net.Send(ply)

                PERKSYSTEM.re_define(data,v)
            end
        end
    end

    net.Receive("override_config", function(len,ply)
        if ply:IsSuperAdmin() then

            local v1 = net.ReadString() 
            local data = net.ReadString()

            file.Write("perkler/"..v1..".txt", data)
            PERKSYSTEM.distrubite_perk_prices(ply)
            ply:ChatPrint(v1 .. " has changed to ".. data)
        end
    end) 

end