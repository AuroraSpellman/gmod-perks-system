local tumperkler
local aktifperkler
local whichperkisused 
local reuse = true 
local kullanilmakistenen
local activeBuffIndicators = {}
local size = 185.4*.48
local birikmiscan = 0
local zipcharge = 0
local ablaaciyimmi = true
local CLR_White = Color(255,255,255)
local CLR_Grey = Color(150,150,150)

surface.CreateFont("Segoecim", {font = "Segoe UI", size = 20, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Segoecim2", {font = "Segoe UI", size = 40, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum", {font = "LEMON MILK", size = 110, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum2", {font = "LEMON MILK", size = 35, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum3", {font = "LEMON MILK", size = 50, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum4", {font = "LEMON MILK", size = 30, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum5", {font = "LEMON MILK", size = 22, weight = 500, antialias = true, additive = false, outline = false})
surface.CreateFont("Lemoncum6", {font = "LEMON MILK", size = 18, weight = 500, antialias = true, additive = false, outline = false})

game.AddParticles("particles/deathangle.pcf")

function PERKSYSTEM_reverseTable(inputTable)
    local reversedTable = {}
    local length = #inputTable
    
    for i = length, 1, -1 do
        table.insert(reversedTable, inputTable[i])
    end
    
    return reversedTable
end

function ShowBuffIndicator(perk, buff, length,r,g,b,rainbow)
    if !length then length = 5 end
    if !PERKSYSTEM.isimler[PERKSYSTEM.lan_config][perk] then return end
    perk = PERKSYSTEM.isimler[PERKSYSTEM.lan_config][perk]

    for i, indicator in ipairs(activeBuffIndicators) do
        if perk == activeBuffIndicators[i].perk then
            table.remove(activeBuffIndicators, i)
        end
    end

    local indicator = {
        perk = perk,
        buff = buff,
        endTime = CurTime() + length,
        length = length,
        r = r,
        g = g,
        b = b,
        rainbow = rainbow,
    }

    table.insert(activeBuffIndicators, indicator)
end

local function DrawBuffIndicators()
    for i, indicator in ipairs(activeBuffIndicators) do
        local x = ScrW() - size * 0.30
        local y = size * 0.25 + size * 2 + (i * 30) - 15
      
        if PERKSYSTEM.perk_HUD_pos == 1 then
            x = size * 0.30
        elseif PERKSYSTEM.perk_HUD_pos == 3 then
            x = ScrW() - size * 0.30
            y = ScrH() - size * 0.25 - size * 2 - (i * 30)
        end
        
        local font = "Lemoncum6"
        surface.SetFont(font)
        local w, h = surface.GetTextSize(indicator.perk .. ": " .. indicator.buff)
        if PERKSYSTEM.perk_HUD_pos == 2 or PERKSYSTEM.perk_HUD_pos == 3 then
            x = x - w
        end
        local remainingTime = indicator.endTime - CurTime()
        local timeRatio = remainingTime / indicator.length
        local boxWidth = w * timeRatio
        
        if rainbow then
            local hue = (CurTime() * 50) % 360
            local rainbowColor = HSVToColor(hue, 1, 1)
            rainbowColor.a = 100
            draw.RoundedBox(30, x - 2.5, y - 2.5, w + 5, h + 5, rainbowColor)
            rainbowColor.a = 255 
            draw.RoundedBox(30, x - 2.5, y - 2.5, boxWidth + 5, h + 5, rainbowColor)
        else
            draw.RoundedBox(30, x - 2.5, y - 2.5, w + 5, h + 5, Color(indicator.r or 255,indicator.g or 255,indicator.b or 255, 100))
            draw.RoundedBox(30, x - 2.5, y - 2.5, boxWidth + 5, h + 5, Color(indicator.r or 255,indicator.g or 255,indicator.b or 255, 255))
        end
        draw.SimpleText(indicator.perk .. ": " .. indicator.buff, font, x + w, y, Color(0,0,0), TEXT_ALIGN_RIGHT)

        if CurTime() >= indicator.endTime then
            table.remove(activeBuffIndicators, i)
        end
    end
end

hook.Add("HUDPaint", "DrawBuffIndicators", DrawBuffIndicators)

net.Receive("ShowBuffIndicator", function()
    local perk = net.ReadString()
    local buff = net.ReadString()
    local sec = net.ReadInt(32)

    ShowBuffIndicator(perk,buff,sec)
end)

net.Receive("perkverbana", function() --initial receival of perkhud info (Perks in use.)
    aktifperkler = net.ReadString()
    local perkIcons = {}
    local currentaktif = "yok"

    if aktifperkler ~= " " then
        aktifperkler = string.Explode(",", aktifperkler)
        for i = 1, 4 do
            perkIcons[i] = aktifperkler[i] and "perkler/perk_" .. aktifperkler[i] .. ".png" or "perkler/empty.png"

            if table.HasValue(PERKSYSTEM.aktifler, aktifperkler[i]) then
                currentaktif = aktifperkler[i]
            end
        end
    else
        perkIcons = {"perkler/empty.png", "perkler/empty.png", "perkler/empty.png", "perkler/empty.png"}
    end

    if file.Exists("hud_cfg.txt","DATA") then
        PERKSYSTEM.perk_HUD_pos = tonumber(file.Read("hud_cfg.txt","DATA"))
    end

    hook.Add("HUDPaint", "perkciz", function()
        for i = 1, 4 do

            birikmiscan = tonumber(birikmiscan)

            surface.SetDrawColor(CLR_White)
            if string.find(perkIcons[i],currentaktif) then
                if timer.Exists("aktifperkbekleme") then 
                    surface.SetDrawColor(55, 55, 55, 255) 
                elseif string.find(perkIcons[i],"patlartohum") then
                    if birikmiscan<100 then
                        surface.SetDrawColor(CLR_Grey)
                    else
                        surface.SetDrawColor(CLR_White)
                    end
                end
            end

            local ozelsayix = (i * (size/2)) % size
            local ozelsayiy = (i - 1)
            if i == 4 then ozelsayix = size/2
            ozelsayiy = 2 end
            if i == 3 then ozelsayix = size  
            ozelsayiy = 1 end

            surface.SetMaterial(Material(perkIcons[i],"noclamp smooth"))

            local perkposx
            local perkposy
            if PERKSYSTEM.perk_HUD_pos == 1 then
                perkposx = (size*.25 + ozelsayix)
                perkposy = (size*.25 + ozelsayiy * size * .5)
            elseif PERKSYSTEM.perk_HUD_pos == 2 then
                perkposx = (ScrW() - ozelsayix - size - size*.25)
                perkposy = (size*.25 + ozelsayiy * size * .5)
            elseif PERKSYSTEM.perk_HUD_pos == 3 then
                perkposx = (ScrW() - size - size * 0.25 - ozelsayix)
                perkposy = (ScrH() - size * 0.25 - ozelsayiy * size * 0.5 - size)
            else
                perkposx = (size * 0.25 + ozelsayix)
                perkposy =  (ScrH() - size * 0.25 - ozelsayiy * size * 0.5 - size)
            end

            surface.DrawTexturedRect(perkposx, perkposy,size, size)

            surface.SetFont("Lemoncum4")
            if string.find(perkIcons[i],currentaktif) then
                
                if timer.Exists("aktifperkbekleme") then
                    local textX, textY = surface.GetTextSize(math.Round(timer.TimeLeft("aktifperkbekleme")))
                    surface.SetTextPos(perkposx + size/2 - textX/2,  perkposy + size/2- textY/2)
                    surface.SetTextColor(CLR_White)
                    surface.DrawText(math.Round(timer.TimeLeft("aktifperkbekleme")))
                elseif string.find(perkIcons[i],"patlartohum") then
                    local textX, textY = surface.GetTextSize(tostring(birikmiscan))
                    surface.SetTextPos(perkposx + size/2 - textX/2,  perkposy + size/2- textY/2)
                    surface.SetTextColor(CLR_Grey)
                    surface.DrawText(tostring(birikmiscan))
                end
               
            end

            surface.SetFont("Lemoncum5")
            if string.find(perkIcons[i], "zipzip") then
                local textX, textY = surface.GetTextSize(tostring(zipcharge))
                surface.SetTextPos(perkposx + size/4 - textX/2, perkposy + size/2- textY/2)
                surface.SetTextColor(CLR_White)
                surface.DrawText(zipcharge)
            end

        end
    end)

end)

local MTR_Display_BG = Material("perkler/perkmenu5.png","noclamp smooth")
local MTR_Settings = Material("perkler/settings3.png", "noclamp smooth" )
local MTR_PerkSlot = Material("perkler/empty.png","noclamp smooth" )
local MTR_PerkLock = Material("perkler/perkmenulock.png","noclamp smooth" )

net.Receive("perkmenuac", function() --Player perk menu

    if IsValid(perkmenu) then return end

    tumperkler = net.ReadString() 
    aktifperkler = net.ReadString()
    local ilerleme = 1
    local line = 1

    if string.find(aktifperkler, ",") then
        aktifperkler = string.Split(aktifperkler, ",")
    end

    if string.find(tumperkler, ",") then
        tumperkler = string.Split(tumperkler, ",")
    elseif !istable(tumperkler) then
        tumperkler = {tumperkler}
    end

    local tumperkler_lookup = {}
	for _, v in ipairs(tumperkler) do
		tumperkler_lookup[v] = true
	end

    perkmenu = vgui.Create("DFrame")
    perkmenu:SetSize(991*.5, 635*.5)
    perkmenu:SetPos(ScrW()-991*.5+1,ScrH()/2-635*.5/2)
    perkmenu:SetDraggable(false)
    perkmenu:ShowCloseButton(false)
    perkmenu:SetDeleteOnClose(true)
    perkmenu:MakePopup()
    perkmenu:SetTitle("")
    perkmenu.Paint = function(s,w,h)
        surface.SetDrawColor(175, 175, 175, 255)
        surface.SetMaterial( MTR_Display_BG )
        surface.DrawTexturedRect( 0, 0, w, h)
        surface.SetDrawColor(0,0,0, 40)
        surface.DrawRect(perkmenu:GetWide()-35, 0, 35,h)
      
        surface.SetFont("Lemoncum6")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(perkmenu:GetWide()-32,80)
        surface.DrawText("HUD")
    end

    local closebtn = vgui.Create("DImageButton", perkmenu)
	closebtn:SetMaterial(Material("perkler/perkshop_kapa.png" ))
	closebtn:SetSize(25,21)
	closebtn:SetPos(perkmenu:GetWide()-30,10)
	closebtn.DoClick = function()
		perkmenu:Close()
        ablaaciyimmi = true
	end

    local hudsetting = vgui.Create("DComboBox", perkmenu)
    hudsetting:SetPos(perkmenu:GetWide()-30,55)
    hudsetting:SetSize(25, 25)
    hudsetting.Paint = function(s,w,h)
        surface.SetMaterial(MTR_Settings)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    hudsetting:AddChoice("TOPLEFT")
    hudsetting:AddChoice("TOPRIGHT")
    hudsetting:AddChoice("BOTTOMRIGHT")
    hudsetting:AddChoice("BOTTOMLEFT")
    hudsetting.OnSelect = function(_, index, value)
        PERKSYSTEM.perk_HUD_pos = index
        file.Write("hud_cfg.txt",index)
    end

    for i= 1, 4 do 
        local imagehaluk = vgui.Create("DImageButton", perkmenu)
        if istable(aktifperkler) then
            if aktifperkler[i] != nil then
                imagehaluk:SetImage("perkler/perk_"..aktifperkler[i]..".png")
                imagehaluk:SetTooltip(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][aktifperkler[i]])
            else
                imagehaluk:SetImage("perkler/empty.png")
            end
        else
            if i<2 then
                if aktifperkler != " " then
                    imagehaluk:SetImage("perkler/perk_"..aktifperkler..".png")
                    imagehaluk:SetTooltip(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][aktifperkler])
                else
                    imagehaluk:SetImage("perkler/empty.png")
                end
            else
                imagehaluk:SetImage("perkler/empty.png")
            end
        end
        imagehaluk:SetPos(i*90-25,30)
        imagehaluk:SetSize(90,90)
        imagehaluk.DoClick = function(self)
            if self:GetImage() != "perkler/empty.png" then
                net.Start("perkcikarildi")
                net.WriteString(self:GetImage())
                net.SendToServer()
                
                if istable(aktifperkler) then
                    local astart, aend = string.find(self:GetImage(), ".png")
                    cikarilan = string.sub(self:GetImage(), 14, astart-1)
                    table.RemoveByValue(aktifperkler,cikarilan)
                else
                    aktifperkler = " "
                end
            end
            self:SetImage("perkler/empty.png")
        end
    end

    local perksthative = vgui.Create("DScrollPanel", perkmenu)
    perksthative:SetPos(10,130)
    perksthative:SetSize(perkmenu:GetWide()-20,perkmenu:GetTall()-150)
    local sbar = perksthative:GetVBar()
    function sbar:Paint(w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end
    function sbar.btnUp:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnDown:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnGrip:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(0,0,0,100))
    end


    -- Owned and Rarity sorting of perks--
    local reordered = {}
    for k,v in ipairs(PERKSYSTEM.perks) do
        table.insert(reordered, 1, v)
    end
    
    for k,v in ipairs(tumperkler) do
        table.RemoveByValue(reordered, v)
        table.insert(reordered, 1, v) 
    end

    for _,perktable in ipairs(PERKSYSTEM.perkorder) do
        for _, v in ipairs(perktable) do
            if table.HasValue(reordered, v) then
                if table.KeyFromValue(reordered, v) < #tumperkler then
                    table.RemoveByValue(reordered, v)
                    table.insert(reordered,1,v) 
                end
            end
        end
    end

    table.RemoveByValue(reordered, "")
    --------------------------------

    --PrintTable(reordered)

    for k,v in ipairs(reordered) do
        local tums = vgui.Create("DImageButton", perksthative)
        tums:SetSize(185*.5,185*.5)
        if !tumperkler_lookup[v] then
            tums:SetColor(Color(255,255,255,25))
        end
        local value = 130
        if k % 4 == 0 then
            tums:SetPos(k*(value*.8)-ilerleme*(value*.8)*4+value*2.6,ilerleme*(value*.8)-value*.7)
            tums:SetImage("perkler/perk_"..v..".png")
            ilerleme = ilerleme + 1
        else
            tums:SetPos(k*(value*.8)-ilerleme*(value*.8)*4+value*2.6,ilerleme*(value*.8)-value*.7)
            tums:SetImage("perkler/perk_"..v..".png")
        end
        tums:SetTooltip(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v])
                    
        if tumperkler_lookup[v] then
            tums.DoClick = function()
                local kullanimda = false
                local bukdarvar = 0

                if istable(aktifperkler) then
                    for _, aktif in ipairs(aktifperkler) do
                        if aktif == v then
                            kullanimda = true
                            chat.AddText(Color(245, 188, 66), "This perk is already equipped.")
                        elseif table.HasValue(PERKSYSTEM.aktifler, v) and table.HasValue(PERKSYSTEM.aktifler, aktif) then
                            kullanimda = true
                            chat.AddText(Color(245, 188, 66), "Cannot equip more than one active perk.")
                        end
                    end
                else
                    if aktifperkler == v then
                        kullanimda = true
                        chat.AddText(Color(245, 188, 66), "This perk is already equipped.")
                    end
                end

                if not kullanimda then
                    perkmenu:Close()
                    net.Start("perktakildi")
                    net.WriteString(v)
                    net.SendToServer()
                end
            end

            tums.Paint = function(s,w,h)
                if tums:IsHovered() then
                    surface.SetDrawColor( CLR_White )
                    surface.SetMaterial(MTR_PerkSlot) 
                    surface.DrawTexturedRect(0, 0, w, h)
			    end
            end
        else
            tums.Paint = function(self, w, h)
                surface.SetDrawColor( CLR_White )
                surface.SetMaterial( MTR_PerkLock )
                surface.DrawTexturedRect( 0, 0, w, h )
            end
        end
    end

    perkmenu.OnClose = function()
        hook.Remove("Think", "CheckKeyPress")
    end

    ablaaciyimmi = false

    hook.Add("Think", "CheckKeyPress", function()
        if input.IsKeyDown(PERKSYSTEM.perkmenu_key) then
            if not shouldClose then
                perkmenu:Close()
                shouldClose = true

                timer.Simple(0.1, function()
                    ablaaciyimmi = true
                end)
            end
        else
            shouldClose = false
        end
    end)

    input.SetCursorPos( perkmenu:GetPos() )
end)

hook.Add("PlayerButtonDown", "aktifperkkullan", function(ply, button) --Cast active perk
    if !IsFirstTimePredicted() then return end
    if button == PERKSYSTEM.active_perk_key then
        whichperkisused = nil

        if istable(aktifperkler) then
            for k, v in ipairs(PERKSYSTEM.aktifler) do
                if table.HasValue(aktifperkler, v) then
                    if v == "patlartohum" then
                        if birikmiscan >= 100 then
                            whichperkisused = k
                            kullanilmakistenen = v
                        end
                    else
                        whichperkisused = k
                        kullanilmakistenen = v
                    end
                end
            end
        else
            for k, v in ipairs(PERKSYSTEM.aktifler) do 
                if aktifperkler == v then
                    if v == "patlartohum" then
                        if birikmiscan == 100 then
                            whichperkisused = k
                            kullanilmakistenen = v
                        end
                    else
                        whichperkisused = k
                        kullanilmakistenen = v
                    end
                end
            end
        end 

        if whichperkisused then
            if reuse then
                net.Start("aktifperkkullanildi")
                net.WriteString(kullanilmakistenen)
                net.SendToServer()
                ShowBuffIndicator(kullanilmakistenen,PERKSYSTEM.aktifbufftext[whichperkisused],PERKSYSTEM.aktifduration[whichperkisused])--,150,0,150,true)
                reuse = false
                timer.Create("aktifperkbekleme", PERKSYSTEM.aktifcooldown[whichperkisused], 1, function() reuse = true end)
            else
                ply:ChatPrint("Re-use in: "..math.Round(timer.TimeLeft("aktifperkbekleme")))
            end
        end
    elseif button == PERKSYSTEM.perkmenu_key then
        if ablaaciyimmi then
            net.Start("perkmenuac")
            net.SendToServer()
        end
    end
end)

net.Receive("aktifperkkullanildi", function() -- receive Natural Harmony (perk) absorbed damage 

    birikmiscan = net.ReadInt(32)
    birikmiscan = tostring(birikmiscan)

end)

net.Receive("BS_Sifirla",function() --Receive to reuse the active perk when the timer is finished
    reuse = true
end)

net.Receive("StopSpesificParticle", function() --Does what is says
    local person = net.ReadEntity()
    local particlename = net.ReadString()

    person:StopParticlesWithNameAndAttachment(particlename,1)
end)

net.Receive("RunGesture", function(len)
    local gesture = net.ReadInt(32)
    local ply = net.ReadEntity()
    ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, gesture, true)
    --ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
end)

net.Receive("UpdateCharges", function()
    zipcharge = net.ReadInt(32)
end)

local function isLetter(char)
    return string.match(char, "[a-zA-Z]") ~= nil
end

local letterToKeyEnum = {A = KEY_A, B = KEY_B, C = KEY_C, D = KEY_D, E = KEY_E, F = KEY_F, G = KEY_G, H = KEY_H, I = KEY_I, J = KEY_J, K = KEY_K, L = KEY_L, M = KEY_M, N = KEY_N, O = KEY_O, P = KEY_P, Q = KEY_Q, R = KEY_R, S = KEY_S, T = KEY_T, U = KEY_U, V = KEY_V, W = KEY_W, X = KEY_X, Y = KEY_Y, Z = KEY_Z}
concommand.Add("active_perk_key", function(ply, cmd, args )
    if #args[1] == 1 then
        if isLetter(args[1]) and letterToKeyEnum[args[1]:upper()] then
            active_perk_key = letterToKeyEnum[args[1]:upper()]
            print("Perk activation key changed to "..args[1]:upper())
        else
            print("Incorrect usage. Correct usage ex. 'active_perk_key P'")
        end
    else
        print("Incorrect usage. Correct usage ex. 'active_perk_key P'")
    end
end)