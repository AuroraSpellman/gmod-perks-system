include("shared.lua") 
include("perk_config.lua")
include("zconfig_override.lua")
local offset = Vector(0, 0, 80)
local vgui_music
local MTR_CloseBtn = Material("perkler/perkshop_kapa.png","noclamp smooth" ) 
local MTR_BackBtn = Material("perkler/perkshop_geri.png","noclamp smooth" ) 
local MTR_PerkShopBG = Material("perkler/perkshopyeni12_3.png","noclamp smooth" )

local MTR_Bundle_On = Material("perkler/b_open.png","noclamp smooth" ) 
local MTR_Bundle_Off = Material("perkler/b_closed.png","noclamp smooth" )
local MTR_Bundle_And = Material("perkler/and4.png", "noclamp smooth")
local MTR_Bundle_Discount = Material("perkler/sagust6.png", "noclamp smooth")

local MTR_PerkSlot = Material("perkler/empty.png","noclamp smooth" )
local MTR_Perk_Rank_Indicator = Material("perkler/rankcolor.png","noclamp smooth" )

local MTR_NPC_BG = Material("perkler/konusma_deneme_14.png","noclamp smooth")
local MTR_NPC_Click = Material("perkler/h_click.png","noclamp smooth")
local MTR_NPC_Skip = Material("perkler/h_click_2.png","noclamp smooth")

local MTR_Settings = Material("perkler/settings3.png", "noclamp smooth" )
local MTR_Purchase = Material("perkler/complete.png")

local CLR_White = Color(255,255,255, 255)

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
function ENT:DrawTranslucent() 
	self:DrawModel()

	local origin = self:GetPos()
	if (LocalPlayer():GetPos():Distance(origin) >= 768) then return end 
	local pos = origin + offset
	local ang = (LocalPlayer():EyePos() - pos):Angle()
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)

	local text = "Perk Master Ari"

	cam.Start3D2D(pos, ang, 0.08)
		draw.SimpleText(text, "Lemoncum3", 0, 0, CLR_White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	cam.End3D2D()
end





local function itemmenu(item,tumperkler,aktifperkler)

	local tumperkler_lookup = {}
	for _, v in ipairs(tumperkler) do
		tumperkler_lookup[v] = true
	end

	--cached materials
	local MTR_Item_Menu_BG = Material("perkler/perkshop31.png","noclamp smooth" )
	local MTR_Perk_Img =  Material("perkler/perk_"..item..".png" ,"noclamp smooth" )
	local resimsize = 185.4 * 2.25

	local perksatis = vgui.Create("DFrame")
	perksatis:SetSize(1288*.95, 747*.95)
	perksatis:Center()
	perksatis:ShowCloseButton(false)
	perksatis:SetTitle(" ")
	perksatis:MakePopup()
	perksatis.Paint = function(s,w,h)
		surface.SetDrawColor(CLR_White)
		surface.SetMaterial(MTR_Item_Menu_BG)
		surface.DrawTexturedRect(0 , 0, w, h)

		surface.SetDrawColor(255,255,255, 25)
		surface.SetMaterial(MTR_Perk_Img)
		surface.DrawTexturedRect(-250 , 175, resimsize*2, resimsize*2)

		surface.SetDrawColor(CLR_White)
		surface.SetMaterial(MTR_Perk_Img)
		surface.DrawTexturedRect(200 , 150, resimsize, resimsize)
	end

	local yazisi = vgui.Create("DLabel", perksatis)
	yazisi:SetText(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][item])
	yazisi:SetTextColor(CLR_White)
	yazisi:SetPos(625,200)
	yazisi:SetSize(450,250)
	yazisi:SetFont("Lemoncum2")
	yazisi:SetWrap(true)

	local backbtn = vgui.Create("DImageButton", perksatis)
	backbtn:SetImage("perkler/perkshop_geri.png")
	backbtn:SetSize(37,25)
	backbtn:SetPos(15 + perksatis:GetWide()*.05, 35 + perksatis:GetTall()*.05)
	backbtn.DoClick = function()
		perksatis:Close()
		net.Start("perk_satma")
		net.SendToServer()
	end

	local closebtn = vgui.Create("DImageButton", perksatis)
	closebtn:SetMaterial(MTR_CloseBtn)
	closebtn:SetSize(30,25)
	closebtn:SetPos(perksatis:GetWide() - 30 - perksatis:GetWide()*.05, 30 + perksatis:GetTall()*.05)
	closebtn.DoClick = function()
		perksatis:Close()
		vgui_music:FadeOut(1.5)
	end

	local buybtn = vgui.Create("DButton", perksatis)
	buybtn:SetPos(700,450)
	buybtn:SetSize(300,100)
	buybtn:SetText("")

	local fiyat = " "
	local yazi = "Obtain"
	local iks,ye = 77,22
	local varmi = false
	if DarkRP then
		iks, ye = 56,10
		fiyat = DarkRP.formatMoney(PERKSYSTEM.fiyatlar[item])
		yazi = "Purchase"
	end
	if tumperkler_lookup[item] then
		varmi = true
	end
	
	buybtn.Paint = function(s,w,h)
		draw.RoundedBox(25, 0, 0, w, h, Color(0,0,0, 45))
		if !buybtn.alindi and !varmi then
			surface.SetFont( "Lemoncum3" )
			surface.SetTextPos(iks,ye)
			surface.SetTextColor( CLR_White)	
			surface.DrawText( yazi )
	
			surface.SetFont( "Segoecim2" )
			surface.SetTextPos( 95, 50 )
			surface.SetTextColor( CLR_White )	
			surface.DrawText( fiyat )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial(MTR_Purchase)
			surface.DrawTexturedRect(120,20,64,64)
		end
	end
	buybtn.DoClick = function()
		if !buybtn.alindi then
			buybtn.alindi = true
			net.Start("bacimperkgonder")
			net.WriteString(item)
			net.SendToServer()
		end
	end 
end 
 
local function bundlemenu(aktifperkler)
	local perksat = vgui.Create("DFrame")
	perksat:SetSize(1288*.95, 747*.95)
	perksat:Center()
	perksat:ShowCloseButton(false)
	perksat:SetTitle(" ")
	perksat:MakePopup()
	perksat.Paint = function(s,w,h)
		surface.SetDrawColor(CLR_White)
		surface.SetMaterial(MTR_PerkShopBG)
		surface.DrawTexturedRect(0 , 0, w, h)

--[[ 		surface.SetFont( "Lemoncum" )
		surface.SetTextPos( w*.04, h*.04 )
		surface.SetTextColor( 0,0,0 )	
		surface.DrawText( "Perk Shop" ) ]]
	end

	local scrollmarket = vgui.Create("DScrollPanel", perksat)
	scrollmarket:SetSize(perksat:GetWide(),perksat:GetTall()*.80)
	scrollmarket:SetPos(0,perksat:GetTall()-scrollmarket:GetTall())
	local sbar = scrollmarket:GetVBar()
    function sbar:Paint(w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
    end
    function sbar.btnUp:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnDown:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnGrip:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(0,0,0,200))
    end

	local imgimg = vgui.Create("DImage",perksat)
	imgimg:SetSize(perksat:GetSize())
	imgimg:SetImage("perkler/perkshopyeni12_3_2.png")

	local closebtn = vgui.Create("DImageButton", perksat)
	closebtn:SetMaterial(MTR_CloseBtn)
	closebtn:SetSize(30,25)
	closebtn:SetPos(perksat:GetWide() - 30 - perksat:GetWide()*.05, 30 + perksat:GetTall()*.05)
	closebtn.DoClick = function()
		perksat:Close()
		vgui_music:FadeOut(1.5)
	end
	
	
	local bundlebtn = vgui.Create("DImageButton",perksat)
	bundlebtn:SetMaterial(MTR_Bundle_On)
	bundlebtn:SetPos(450,116)
	bundlebtn:SetSize(56*.8,45*.8)
	bundlebtn.DoClick = function()
		perksat:Close()
		net.Start("perk_satma")
		net.SendToServer()
	end
	

	for atlayici,bundle in ipairs(PERKSYSTEM.bundles) do
		local bundlepanel = vgui.Create("DPanel",scrollmarket)
		bundlepanel:SetSize(scrollmarket:GetWide()-100,325)
		bundlepanel:SetPos(50,atlayici*350-270)
		bundlepanel.Paint = function(s,w,h)
			draw.RoundedBox(50, 0, 0, w, 250, Color(255,255,255,10))
			draw.RoundedBox(50, 0, 0, w, h, Color(255,255,255,10))
		end

		local perkve = vgui.Create("DImage", bundlepanel)
		perkve:SetPos(280,93)
		perkve:SetSize(90,90)
		perkve:SetMaterial(MTR_Bundle_And) 

		local discountcorner = vgui.Create("DImage", bundlepanel)
		discountcorner:SetPos(bundlepanel:GetWide()-120,250-125)
		discountcorner:SetSize(125,125)
		discountcorner:SetMaterial(MTR_Bundle_Discount)
		
		local discountpercent = vgui.Create("DLabel", bundlepanel)
		discountpercent:SetFont("Lemoncum3")
		discountpercent:SetTextColor(CLR_White)
		discountpercent:SetSize(100,50)
		discountpercent:SetPos(bundlepanel:GetWide()-100,250-75)
		discountpercent:SetText("%"..bundle[4]) 
		discountpercent:SetContentAlignment(2)

		for i=1,2 do
			local fotos = vgui.Create("DImage", bundlepanel)
			if i == 1 then 	fotos:SetPos(57.5,47.5) else fotos:SetPos(407.5,47.5) end
			fotos:SetSize(180,180)
			fotos:SetMaterial(MTR_PerkSlot)
		end

		local fotos = vgui.Create("DImage", bundlepanel)
		fotos:SetPos(60,50)
		fotos:SetSize(175,175)
		fotos:SetMaterial(Material("perkler/perk_"..bundle[2]..".png", "noclamp smooth"))

		local fotos2 = vgui.Create("DImage", bundlepanel)
		fotos2:SetPos(410,50)
		fotos2:SetSize(175,175)
		fotos2:SetMaterial(Material("perkler/perk_"..bundle[3]..".png", "noclamp smooth"))

		local bundleismi = vgui.Create("DLabel", bundlepanel)
		bundleismi:SetFont("Lemoncum3")
		bundleismi:SetTextColor(Color(255,255,255))
		bundleismi:SetSize(500,50)
		bundleismi:SetPos(600,40)
		bundleismi:SetText(bundle[1]) 
		bundleismi:SetContentAlignment(2)

		local bundleismi2 = vgui.Create("DLabel", bundlepanel)
		bundleismi2:SetFont("Lemoncum3")
		bundleismi2:SetTextColor(CLR_White)
		bundleismi2:SetSize(500,50)
		bundleismi2:SetPos(600,80)
		bundleismi2:SetText("Bundle") 
		bundleismi2:SetContentAlignment(2)

		local toplam = (PERKSYSTEM.fiyatlar[bundle[2]] + PERKSYSTEM.fiyatlar[bundle[3]]) 
		local bundlefiyat = vgui.Create("DLabel", bundlepanel)
		bundlefiyat:SetFont("Lemoncum4")
		bundlefiyat:SetTextColor(Color(255,100,100,155))
		bundlefiyat:SetSize(500,50)
		bundlefiyat:SetPos(600,130)
		bundlefiyat:SetText( DarkRP.formatMoney(toplam)) 
		bundlefiyat:SetContentAlignment(2)
		bundlefiyat.Paint = function(s,w,h)
			surface.SetDrawColor(255,100,100,155)
			surface.DrawRect(bundlefiyat:GetWide()/2-100/2, bundlefiyat:GetTall()/2+6, 100, 4)
		end

		local bundlefiyat = vgui.Create("DLabel", bundlepanel)
		bundlefiyat:SetFont("Lemoncum3")
		bundlefiyat:SetTextColor(Color(100,255,100,155))
		bundlefiyat:SetSize(500,50) 
		bundlefiyat:SetPos(600,170)
		bundlefiyat:SetText( DarkRP.formatMoney(toplam - toplam * bundle[4] / 100)) 
		bundlefiyat:SetContentAlignment(2)

		local bundledescription = vgui.Create("DLabel", bundlepanel)
		bundledescription:SetFont("Lemoncum6")
		bundledescription:SetTextColor(Color(255,255,255,255))
		bundledescription:SetSize(bundlepanel:GetWide()-100,75) 
		bundledescription:SetPos(50,250)
		bundledescription:SetWrap(true)
		bundledescription:SetText(  bundle[5] ) 

		local buybundle = vgui.Create("Button", bundlepanel)
		buybundle:SetSize(bundlepanel:GetSize())
		buybundle.Paint = function() end
		buybundle:SetText(" ")
		buybundle.DoClick = function()
			net.Start("buybundle")
			net.WriteInt(atlayici, 32)
			net.SendToServer()
		end

		if atlayici == #PERKSYSTEM.bundles then
			local uza = vgui.Create("DLabel", scrollmarket)
			uza:SetPos(0,atlayici*350+100)
			uza:SetText(" ")
		end

	end

	for i= 1, 4 do 
        local imagehaluk = vgui.Create("DImage", perksat)
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
        imagehaluk:SetPos(1288*.95-i*80-100,35)
        imagehaluk:SetSize(80,80)
    end
end

net.Receive("perk_satma", function()
	if !vgui_music then
		vgui_music = CreateSound(LocalPlayer(),"perksounds/UIBGM.wav")
	end
	if PERKSYSTEM.menu_music then
		vgui_music:PlayEx(.27,120)
	end
	local tumperkler = net.ReadString()
	local aktifperkler = net.ReadString()
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

	local perksat = vgui.Create("DFrame")
	perksat:SetSize(1288*.95, 747*.95)
	perksat:Center()
	perksat:ShowCloseButton(false)
	perksat:SetTitle(" ")
	perksat:MakePopup()
	perksat.Paint = function(s,w,h)
		surface.SetDrawColor(240,240,240, 255)
		surface.SetMaterial(MTR_PerkShopBG)
		surface.DrawTexturedRect(0 , 0, w, h)
	end

	local scrollmarket = vgui.Create("DScrollPanel", perksat)
	scrollmarket:SetSize(perksat:GetWide(),perksat:GetTall()*.80)
	scrollmarket:SetPos(0,perksat:GetTall()-scrollmarket:GetTall())
	local sbar = scrollmarket:GetVBar()
    function sbar:Paint(w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
    end
    function sbar.btnUp:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnDown:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(200, 100, 0,0))
    end
    function sbar.btnGrip:Paint(w, h)
      draw.RoundedBox(10, 0, 0, w, h, Color(0,0,0,200))
    end

	local ilerleme = 1
	local MTR_PerkImg = {}
	for k,v in ipairs(PERKSYSTEM.perks) do

		local tums = vgui.Create("DImageButton", scrollmarket)
        tums:SetSize(180,220)
        tums:SetColor(Color(255,255,255,250))
        if k % 5 == 0 then
            tums:SetPos(k*225-ilerleme*1125+955,ilerleme*250-165) -- 200 dediği size'dan gelio, 1000 dediği size'ın beş katı, gerisi adjustment
            --tums:SetImage("perkler/perk_"..v..".png")
            ilerleme = ilerleme + 1
        else
            tums:SetPos(k*225-ilerleme*1125+955,ilerleme*250-165)
            --tums:SetImage("perkler/perk_"..v..".png")
        end
		--tums:SetTooltip(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v])
		if string.find(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v], ";") then
			tums.aciklama = string.sub(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v],1, select(1,string.find(PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v], ";")))
		else
			tums.aciklama = "Add Name"
		end

		MTR_PerkImg[v] = Material("perkler/perk_"..v..".png","noclamp smooth" )  
		tums.Paint = function(s,w,h)
			h=h-40
			draw.RoundedBox(35, 0, 0, w, h, Color(255,255,255,15))
			surface.SetDrawColor(CLR_White)
			if tums:IsHovered() then
				surface.SetMaterial(MTR_PerkSlot)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			surface.SetMaterial(MTR_PerkImg[v])
			surface.DrawTexturedRect(10, 10, w-20, h-20)

			if tumperkler_lookup[v] then
				surface.SetMaterial(MTR_Purchase)
				surface.DrawTexturedRect(20, 20, 30, 30)
			end
			
			if table.HasValue(PERKSYSTEM.aktifler, v) then
				surface.SetDrawColor( HSVToColor(  ( CurTime() ) % 360, 50, 1 ) ) 
			elseif table.HasValue(PERKSYSTEM.keyperk, v) then
				surface.SetDrawColor(255, math.sin(CurTime()) * 90 + 200 , 0) 
			elseif table.HasValue(PERKSYSTEM.legendaryler, v) then
				surface.SetDrawColor(math.sin(CurTime()*1) * 45 + 200, math.sin(CurTime()*1) * 45 + 200 , 255) 
			elseif table.HasValue(PERKSYSTEM.common, v) then
				surface.SetDrawColor(155,155,155) 
			end
			surface.SetMaterial(MTR_Perk_Rank_Indicator)
			surface.DrawTexturedRect(150, 150, 20, 20)


			surface.SetFont( "Lemoncum5" )
			s.aciklama = string.Trim(s.aciklama, ";")
			local acx, acy = surface.GetTextSize(s.aciklama)
			local yazitable

			if acx > w and string.find(s.aciklama, " ") then
				yazitable = string.Split(s.aciklama, " ")
			end
			if istable(yazitable) then
				for k,v in ipairs(yazitable) do
					local acx, acy = surface.GetTextSize(v)
					surface.SetTextPos( w/2-acx/2,h+acy/2 - math.Remap(k, 1, 2, acy/2, -acy/2) + acy/5 )
					surface.SetTextColor( CLR_White )	
					surface.DrawText(v) 
				end
			else
				surface.SetTextPos( w/2-acx/2,h+acy/2 )
				surface.SetTextColor( CLR_White )	
				surface.DrawText( s.aciklama ) 
			end
		end

		if k == #PERKSYSTEM.perks then
			local uza = vgui.Create("DLabel", scrollmarket)
			uza:SetPos(k*200-ilerleme*1000+875,ilerleme*250+150)
			uza:SetText(" ")
		end

		tums.DoClick = function()
			perksat:Close()
			itemmenu(v,tumperkler)
		end
	end

	local imgimg = vgui.Create("DImage",perksat)
	imgimg:SetSize(perksat:GetSize())
	imgimg:SetImage("perkler/perkshopyeni12_3_2.png")

	local closebtn = vgui.Create("DImageButton", perksat)
	closebtn:SetMaterial(Material("perkler/perkshop_kapa.png" ))
	closebtn:SetSize(30,25)
	closebtn:SetPos(perksat:GetWide() - 30 - perksat:GetWide()*.05, 30 + perksat:GetTall()*.05)
	closebtn.DoClick = function()
		perksat:Close()
		vgui_music:FadeOut(1.5)
	end

	local rplybtn = vgui.Create("DImageButton", perksat)
	rplybtn:SetMaterial(Material("perkler/replay_1.png", "noclamp smooth" ))
	rplybtn:SetPos(1100, 120)
	rplybtn:SetSize(650*.13,200*.13)
	rplybtn.DoClick = function()
		perksat:Close()
		vgui_music:Stop()
		net.Start("perkcu_konusma")
		net.SendToServer()
	end

	if LocalPlayer():IsSuperAdmin() and DarkRP then
        local priceset = vgui.Create("DButton", perksat)
        priceset:SetPos(452,60)
        priceset:SetSize(40, 40)
		priceset:SetText("") 
        priceset.Paint = function(s,w,h)
			surface.SetDrawColor(255,255,255)
            surface.SetMaterial(MTR_Settings)
            surface.DrawTexturedRect(0, 0, w, h)
        end
		priceset.DoClick = function()
			perksat:Close()

			chat.AddText("[PERKSYSTEM] For more detailed configurations, please extract addon to serverfiles and view 'perk_config.lua'.")

			local ppmenu = vgui.Create("DFrame")
			ppmenu:SetSize(991*.5, 635*.5)
			ppmenu:Center()
			ppmenu:ShowCloseButton(false)
			ppmenu:SetTitle(" ")
			ppmenu:MakePopup()
			ppmenu.Paint = function(s,w,h)
				surface.SetDrawColor(CLR_White)
				surface.SetMaterial(Material("perkler/perkmenu5.png", "noclamp smooth" ))
				surface.DrawTexturedRect(0 , 0, w, h)
			end

			local closebtn = vgui.Create("DImageButton", ppmenu)
			closebtn:SetMaterial(MTR_CloseBtn)
			closebtn:SetSize(30,25)
			closebtn:SetPos(440,20)
			closebtn.DoClick = function()
				ppmenu:Close()
				vgui_music:FadeOut(1.5) 
			end

			local DComboBox = vgui.Create( "DComboBox", ppmenu )
			DComboBox:SetPos( 95, 75 )
			DComboBox:SetSize( 300, 50 )
			DComboBox:SetValue( "Admin Menu : Set Price For" )
			DComboBox:AddChoice( "key_perk_price" )
			DComboBox:AddChoice( "legendary_perk_price" )
			DComboBox:AddChoice( "epic_perk_price" )
			DComboBox:AddChoice( "common_perk_price" )
			DComboBox:AddChoice( "active_perk_price" )

			local TextEntryPH = vgui.Create( "DTextEntry", ppmenu )
			TextEntryPH:SetPos( 95, 150 )
			TextEntryPH:SetSize( 300, 50 )
			TextEntryPH:SetPlaceholderText( "Enter new price: (Numbers Only)" )

			local DPButton = vgui.Create("DButton", ppmenu)
			DPButton:SetPos(95,225)
			DPButton:SetSize(300,50)
			DPButton:SetText("Set Price")
			DPButton.DoClick = function()
				if isnumber(tonumber(TextEntryPH:GetValue())) then
					net.Start("override_config")
					net.WriteString(DComboBox:GetValue()) 
					net.WriteString(TextEntryPH:GetValue())
					net.SendToServer()
				end
			end
		end
    end 


	if DarkRP then
		local bundlebtn = vgui.Create("DImageButton",perksat)
		bundlebtn:SetMaterial(MTR_Bundle_Off)
		bundlebtn:SetPos(450,116)
		bundlebtn:SetSize(56*.8,45*.8)
		bundlebtn.DoClick = function()
			perksat:Close()
			bundlemenu(aktifperkler)
		end
	end

	for i= 1, 4 do 
        local imagehaluk = vgui.Create("DImage", perksat)
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
        imagehaluk:SetPos(1288*.95-i*80-100,35)
        imagehaluk:SetSize(80,80)
    end

	input.SetCursorPos((ScrW()-(1288*.95))/2+100,(ScrH()-(747*.95))/2+90)
end)

net.Receive("perkcu_konusma", function()
	if !vgui_music then
		vgui_music = CreateSound(LocalPlayer(),"perksounds/UIBGM.wav")
	end
	local atlamasayisi = 1 
	local script = net.ReadTable()
	local ilkperkum = net.ReadString()
	--[[ LocalPlayer():StopSound("perkler/gizem.mp3") 
	LocalPlayer():EmitSound("perkler/gizem.mp3",20) ]]

	artikcizme = true
	local ekrankapla = vgui.Create("DFrame")
	ekrankapla:SetPos(0,ScrH()-383)
	ekrankapla:SetTitle(" ")
	ekrankapla:SetSize(1164, 383)
	ekrankapla.Paint = function(s,w,h)
		surface.SetDrawColor(CLR_White)
		surface.SetMaterial(MTR_NPC_BG)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	ekrankapla:MakePopup()
	ekrankapla:ShowCloseButton(false)
	ekrankapla:SetDraggable(false)

--[[ 	local yazi = vgui.Create("DImage", ekrankapla)
	yazi:SetSize(1333*.5,480*.5)
	yazi:SetPos(20,ekrankapla:GetTall()-480*.5-20)
	yazi:SetImage("perkler/perk_bos_konusma.png") ]]

	local yaziustulabel = vgui.Create("DLabel", ekrankapla) 
	yaziustulabel:SetPos(300,ekrankapla:GetTall()-275)
	yaziustulabel:SetTextColor(CLR_White)
	yaziustulabel:SetSize(360,270)
	yaziustulabel:SetFont("Lemoncum4")
	yaziustulabel:SetWrap(true)
	yaziustulabel:SetText("Welcome!")

    --LocalPlayer():EmitSound("perksounds/UIBGM.wav",25)
	vgui_music:PlayEx(.28,200)

	local ekrankaplabtn = vgui.Create("DButton", ekrankapla) 
	ekrankaplabtn:SetPos(0,0)
	ekrankaplabtn:SetSize(ekrankapla:GetSize()) 
	ekrankaplabtn:SetText(" ")
	ekrankaplabtn.DoClick = function()
		artikcizme = false 
		if !timer.Exists("konusmagecici1") then
			atlamasayisi = atlamasayisi + 1

			if atlamasayisi <= 10 then
				LocalPlayer():GetEyeTrace().Entity:EmitSound( "perksounds/ses"..(atlamasayisi-1).." (1).wav",75 )
			end
			if atlamasayisi == #script + 1 then
				ekrankapla:Close()
			else
				yaziustulabel:SetText(script[atlamasayisi])
			end 

			timer.Create("konusmagecici1", 4.5, #script, function()
				atlamasayisi = atlamasayisi + 1
				LocalPlayer():GetEyeTrace().Entity:EmitSound( "perksounds/ses"..(atlamasayisi-1).." (1).wav",75 )
				--LocalPlayer():EmitSound("perk/ses"..(atlamasayisi-1)..".mp3",100)

				if atlamasayisi == #script then
					ekrankapla:Close()
					vgui_music:FadeOut(1)
				else
					if script[atlamasayisi] then
						yaziustulabel:SetText(script[atlamasayisi])
					end
				end
			end)
		end

		timer.Simple(5, function()
			local skipdialouge = vgui.Create("DImageButton", ekrankapla)
			skipdialouge:SetSize(373*.5,86*.5)
			skipdialouge:SetPos(350,383-75)
			skipdialouge:SetImage("perkler/h_click_2.png")
			skipdialouge.Paint = function(s,w,h)
				if !artikcizme then
					surface.SetMaterial(MTR_NPC_Skip)
					surface.SetDrawColor(255, 255, 255, CurTime()*20%255-50)
					surface.DrawTexturedRect(0,0,w,h)
				end
			end
			skipdialouge.DoClick = function()
				if !artikcizme then
					timer.Remove("konusmagecici1")
					vgui_music:FadeOut(1)
					ekrankapla:Close()
				end
			end
		end)

	end
	ekrankaplabtn.Paint = function() end

	local asdasd = vgui.Create("DImage", ekrankapla)
	asdasd:SetSize(373*.5,86*.5)
	asdasd:SetPos(300,ekrankapla:GetTall()-125)
	asdasd:SetImage("perkler/h_click.png")
	asdasd.Paint = function(s,w,h)
		if artikcizme then
			surface.SetMaterial(MTR_NPC_Click)
			surface.SetDrawColor(255, 255, 255, CurTime()*200%255)
			surface.DrawTexturedRect(0,0,w,h)
		end
	end
end)

net.Receive("override_config", function()
	PERKSYSTEM.re_define(net.ReadString(),net.ReadString())
end) 