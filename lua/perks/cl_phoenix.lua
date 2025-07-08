local phoenixgoster

net.Receive("phoenixbasla", function()
    phoenixgoster = true
end)

net.Receive("phoenixbit", function()
    phoenixgoster = false
end)

hook.Add("HUDPaint", "phoenix", function()
    if phoenixgoster then
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(Material("perkler/ankakey_re6.png"))
        local YSize = 730*.4
        surface.DrawTexturedRect(0, ScrH()/2 - YSize/2 ,1764*.4, YSize) 
    end
end)


hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if  name == "CHudDamageIndicator" then
		return false
	end
end )