surface.CreateFont( "BlacklistName", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .021,
	weight    = 900,
	antialias = true
})

local blacklist = {}

net.Receive("UpdateClientBlacklist", function()

	tbl = net.ReadTable()
	
	blacklist = tbl

end)

function IsBlacklisted( ply )

	plyID = ply:SteamID()
	
	if(plyID == "NULL") then
		plyID = "BOT"
	end
	
	PrintTable(blacklist)
	print("ID: ".. plyID)
	
	return table.HasValue(blacklist, plyID)

end

function BlacklistPlayer( thID, ply, val )

	net.Start("BlacklistPlayer")
		net.WriteString(thID)
		net.WriteEntity(ply)
		net.WriteBool(val)
	net.SendToServer()
	
end

function OpenBlacklist()
	
	local menuColor = GetUIColor( LocalPlayer() )
	
	local th = LocalPlayer():GetTheater()
	
	if(!th) then return end
	
	local thID = th:GetLocation()
	
	if(th:GetOwner() == nil) then
		chat.AddText(Color( 255, 20, 20 ), "Theater has no owner.")
	return end
	
	if( !LocalPlayer():IsAdmin() && th:GetOwner() != LocalPlayer() ) then return end
	
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() * 0.3 , ScrH() * 0.2 )
	Frame:SetSize( ScrW() * 0.4, ScrH() * 0.6 )
	Frame:SetTitle( "Blacklist" )
	Frame:SetVisible( true )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) -- Draw a red box instead of the frame
	end
	
	local scroll = vgui.Create("DScrollPanel", Frame)
	scroll:SetPos( 0, Frame:GetTall() * .06 )
	scroll:SetSize( Frame:GetWide(), Frame:GetTall() * .93)
	local ypos = 0
	table.foreach(player.GetAll(), function( key, value)
	
		if ( !IsValid(value) ) then return end
		
		if ( value == LocalPlayer() ) then return end
		
		local ply = value
		
		local blacklisted = IsBlacklisted(ply)
		
		local PlayerPanel = vgui.Create("DPanel", scroll)
		PlayerPanel:SetPos( Frame:GetWide() * .005, ypos)
		PlayerPanel:SetSize( Frame:GetWide() * .99, Frame:GetTall() * .1 )
		if(blacklisted) then
			PlayerPanel.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(255, 20, 20) )
				draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) ) -- 35
			end
		else
			PlayerPanel.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(100, 100, 100) )
				draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) ) -- 35
			end
		end
		
		local Name = vgui.Create( "DLabel", PlayerPanel )
		Name:SetPos( PlayerPanel:GetWide() * .015, PlayerPanel:GetTall() * -.05 )
		Name:SetSize( PlayerPanel:GetWide(), PlayerPanel:GetTall() )
		Name:SetFont( "BlacklistName" )
		Name:SetText( ply:Name() )
		if(blacklisted) then
			Name:SetColor( Color(255, 20, 20) )
		else
			Name:SetColor( Color(100, 100, 100) )
		end
		
		local BlacklistBox = vgui.Create( "DCheckBoxLabel", PlayerPanel )
		BlacklistBox:SetPos( PlayerPanel:GetWide() * .935, PlayerPanel:GetTall() * .35 )
		BlacklistBox:SetText("")
		BlacklistBox:SetValue(blacklisted)
		if(blacklisted) then BlacklistPlayer(thID, ply, true) end
		function BlacklistBox:OnChange( val )
		
			BlacklistPlayer(thID, ply, val)
		
			if(val) then
				PlayerPanel.Paint = function(self, w, h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(255, 20, 20) )
					draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) ) -- 35
				end
				Name:SetColor( Color(255, 20, 20) )
			else
				PlayerPanel.Paint = function(self, w, h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(100, 100, 100) )
					draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) ) -- 35
				end
				Name:SetColor( Color(100, 100, 100) )
			end
		
		end
		
		ypos = ypos + PlayerPanel:GetTall() * 1.05
		
	end)


end