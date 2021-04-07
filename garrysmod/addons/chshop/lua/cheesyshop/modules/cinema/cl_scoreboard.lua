
surface.CreateFont( "PlayerCountFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .014,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "TheatersTitleFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .025,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "PlayerNameFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .017,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "PlayerStatsFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .012,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "ProfileButtonFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .012,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "BadgeFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .012,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "TheaterNameFont", {
	font      = "Open Sans Condensed Light",
	size      = ScrW() * .018,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "TheaterStatsFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .011,
	weight    = 200,
	antialias = true
})

surface.CreateFont( "VideoTimeFont", {
	font      = "Open Sans Condensed",
	size      = ScrW() * .01,
	weight    = 200,
	antialias = true
})

--local background = Material( "cheesy_bologna/banner.png" )
--local backgroundLow = Material( "cheesy_bologna/banner_low.png" )
--local logoGlow = Material( "cheesy_bologna/logo_glow_low.png" )
--local logo = Material( "cheesy_bologna/logo.png" )

local pbOpen = false

local theatersID = {}
local cards = {}

local function RemoveGamemodeScoreboard()
	-- Cinema
	if ValidPanel( Gui ) then
		Gui:SetVisible( false )
	end
end

local function UpdateTheaters()

	if(!pbOpen) then return end
	RemoveGamemodeScoreboard()
	local theaterAmount = table.Count(theatersID)
	
	if( theaterAmount > 0 ) then
	
		theater.PollServer()
	
		for i = 0, theaterAmount do
		
			if( cards[i] != nil ) then
			
				cards[i].TheaterName:SetText(cards[i].th:Name())
				cards[i].TheaterStats:SetText(T( cards[i].th:VideoTitle() ))
				cards[i].VideoTime:SetText( cards[i].th:VideoTime() )
			
			end
		
		end
	
	end
	
	if( IsValid(PingMarker) ) then
	
		PingMarker:SetText( LocalPlayer():Ping() )
		
		local pingColor = Color(255, 255, 255, 255)
				
		if(LocalPlayer():Ping() > 300) then
			pingColor = Color(230, 100, 100, 255)
		elseif(LocalPlayer():Ping() > 200) then
			pingColor = Color(230, 170, 10, 255)
		else
			pingColor = Color(255, 255, 255, 255)
		end
		
		PingMarker:SetColor( pingColor )
	
	end

end

local function ChangeLocationSettings( hidden )

	net.Start("change_location_settings")
		net.WriteBool(hidden)
	net.SendToServer()

end

local function OpenSettings()

	if(pbOpen)then
	
		SettingsMenu = vgui.Create("DFrame")
		SettingsMenu:SetSize(ScrW() * .15, ScrH() * .15)
		SettingsMenu:SetPos( ScrW() * .75, ScrH() * .156 )
		SettingsMenu:SetDraggable(false)
		SettingsMenu:SetTitle("")
		SettingsMenu:ShowCloseButton(false)
		
		SettingsMenu.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, menuColor )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 20, 20, 20, 255 ) )
			draw.RoundedBox( 0, 0, 2, w * .1, h * .19, Color( 20, 20, 20, 255 ) )
		end
		
		local wide = SettingsMenu:GetWide()
		local tall = SettingsMenu:GetTall()
		
		local ColorButton = vgui.Create("DButton", SettingsMenu)
		ColorButton:SetSize(wide * .5, tall * .25)
		ColorButton:SetPos(wide * .45, tall * .1 )
		ColorButton:SetFont("PlayerCountFont")
		ColorButton:SetText("Customize Colors")
		ColorButton:SetColor( menuColor )
		
		ColorButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, menuColor )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) )
		end
		
		ColorButton.DoClick = function()
			ColorsMenu()
		end
		
		local LocationSign = vgui.Create("DLabel", SettingsMenu)
		LocationSign:SetSize( wide, tall )
		LocationSign:SetPos( wide * .55, tall * - .01 )
		LocationSign:SetText("Hide Location")
		LocationSign:SetFont("ProfileButtonFont")
		LocationSign:SetColor( Color( 255, 255, 255 ) )
		
		local LocationCheckBox = vgui.Create( "DCheckBoxLabel", SettingsMenu )
		LocationCheckBox:SetPos( wide * .88 , tall * .45)
		LocationCheckBox:SetText("")
		LocationCheckBox:SetValue( LocalPlayer():GetNWBool("LocationHidden") )
		function LocationCheckBox:OnChange( val )
		
			ChangeLocationSettings(val)
		
		end
		
	end

end

local function CloseSettings()
	if( IsValid( SettingsMenu ) )then
	
		SettingsMenu:Remove()
	
	end
end

local function ClosePopUpWindows()

	CloseSettings()

end

local function SetUpTheaterboard()

	if( IsValid(PlayerboardFrame) ) then
	
		local w = PlayerboardFrame:GetWide()
		local h = PlayerboardFrame:GetTall()
		
		table.Empty( theatersID )
		
		for _, th in pairs( theater.GetTheaters() ) do 
			table.insert(theatersID, th:GetLocation() )
		end
		
		local theaterAmount = table.Count(theatersID)
		
		local TheaterPanel = vgui.Create("DScrollPanel", PlayerboardFrame)
		TheaterPanel:SetPos( w * .66, h * .12 )
		TheaterPanel:SetSize( w * .34, h * .85)
		ypos = 0
		
		for i = 1, theaterAmount do
			
			local TheaterCard = vgui.Create("DPanel", TheaterPanel)
			TheaterCard:SetPos( TheaterPanel:GetWide() * 0, ypos)
			TheaterCard:SetSize( TheaterPanel:GetWide() * 1, TheaterPanel:GetTall() * .09 )
			TheaterCard.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, menuColor )
				draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) )
			end
			
			cards[i] = {
			th = theater.GetByLocation(theatersID[i]),
			TheaterName = vgui.Create("DLabel", TheaterCard),		
			TheaterStats = vgui.Create("DLabel", TheaterCard),
			VideoTime = vgui.Create("DLabel", TheaterCard)
			}
			
			cards[i].TheaterName:SetSize(TheaterCard:GetWide() * .92, TheaterCard:GetTall())
			cards[i].TheaterName:SetPos(TheaterCard:GetWide() * .04, TheaterCard:GetTall() * - .2)
			cards[i].TheaterName:SetFont("TheaterNameFont")
			cards[i].TheaterName:SetText(cards[i].th:Name())
			cards[i].TheaterName:SetColor( Color( 255, 255, 255, 255 ) )
			
			cards[i].TheaterStats:SetSize(TheaterCard:GetWide() * .92, TheaterCard:GetTall())
			cards[i].TheaterStats:SetPos(TheaterCard:GetWide() * .04, TheaterCard:GetTall() * .2)
			cards[i].TheaterStats:SetFont("TheaterStatsFont")
			cards[i].TheaterStats:SetText(T( cards[i].th:VideoTitle() ))
			cards[i].TheaterStats:SetColor( Color( 240, 240, 240, 255 ) )
			
			cards[i].VideoTime:SetSize( TheaterCard:GetWide(), TheaterCard:GetTall() )
			cards[i].VideoTime:SetContentAlignment( 6 )
			cards[i].VideoTime:SetPos( TheaterCard:GetWide() * - .04, TheaterCard:GetTall() * - .15 )
			cards[i].VideoTime:SetFont("VideoTimeFont")
			cards[i].VideoTime:SetText("0:00 / 0:00")
			cards[i].VideoTime:SetColor( Color( 200, 200, 200, 200 ) )
			
			ypos = ypos + TheaterCard:GetTall() * 1.05
		
		end
		
	end


end


local function SetUpPlayerboard()
	
	if( IsValid(PlayerboardFrame) ) then
		
		local h = ScrH()
		local w = ScrH() * 1.8
		
		-- Size and variables.
		PlayerboardFrame:SetTitle("")
		PlayerboardFrame:SetSize( w * .495, h * .8 )
		PlayerboardFrame:Center()
		PlayerboardFrame:SetDraggable(false)
		PlayerboardFrame:ShowCloseButton(false)
		--PlayerboardFrame:MakePopup()
		
		theater.PollServer()
		
		local w = PlayerboardFrame:GetWide()
		local h = PlayerboardFrame:GetTall()
		
		menuColorTr = menuColor
		--menuColorTr.a = 60
		
		PlayerboardFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 210 ) )
		end
		
		--[[local TitlePanel = vgui.Create("DPanel", PlayerboardFrame)
		TitlePanel:SetPos( w * 0, h * 0 )
		TitlePanel:SetSize( w * 1 , h * .6 )
		TitlePanel:SetMouseInputEnabled(false)]]
		
		--[[TitlePanel.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 50 )
			surface.SetMaterial( background )
			surface.DrawTexturedRect( 0, -1, w, h + 1 )
		end]]
		
		--[[local TitlePanelReverse = vgui.Create("DPanel", PlayerboardFrame)
		TitlePanelReverse:SetPos( w * 0, h * .65 )
		TitlePanelReverse:SetSize( w * 1 , h * .6 )
		TitlePanelReverse:SetMouseInputEnabled(false)]]
		
		--[[TitlePanelReverse.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 50 )
			surface.SetMaterial( backgroundLow )
			surface.DrawTexturedRect( 0, -1, w, h + 1 )
		end]]
		
		local BG = vgui.Create("DHTML", PlayerboardFrame)
		BG:SetPos(0, 0)
		BG:SetSize(w, h)
		--AddSnowflakes(BG)
		CreateRepeatingWebTextureWithSnowflakes(BG, "https://i.imgur.com/PmEekzU.png") 

		local Title = vgui.Create("DHTML", PlayerboardFrame)
		Title:SetPos( w * .01, h * - .03 )
		Title:SetSize( w * .65 , h * .2 )
		Title:SetMouseInputEnabled(false)
		CreateWebTexturePanel(Title, "https://i.imgur.com/6M2Wk4p.png")
		
		--[[Title.Paint = function( self, w, h )
			surface.SetDrawColor( menuColorTr )
			surface.SetMaterial( logoGlow )
			surface.DrawTexturedRect( 0, -1, w, h + 1 )
			surface.SetDrawColor( menuColor )
			surface.SetMaterial( logo )
			surface.DrawTexturedRect( 0, -1, w, h + 1 )
		end--]]
		
		local TheaterSign = vgui.Create("DLabel", PlayerboardFrame)
		TheaterSign:SetPos( w * .66, h * .04 )
		TheaterSign:SetSize( w * .2 , h * .1 )
		TheaterSign:SetFont("TheatersTitleFont")
		TheaterSign:SetText("Theaters")
		TheaterSign:SetColor( Color(255, 255, 255, 255) )
		
		local players = player.GetAll()
		local currentPlayers = table.Count( players )
		
		local PlayerCount = vgui.Create( "DLabel", PlayerboardFrame )
		PlayerCount:SetPos( w * .525, h * .083 )
		PlayerCount:SetSize( w * .2, h * .1 )
		PlayerCount:SetFont("PlayerCountFont")
		PlayerCount:SetText( "(".. currentPlayers .."/".. game.MaxPlayers() ..") Players" )
		PlayerCount:SetColor( Color( 255, 255, 255, 255 ) )
		
		local MouseSign = vgui.Create( "DLabel", PlayerboardFrame )
		MouseSign:SetContentAlignment( 3 )
		MouseSign:SetPos( w * -.01, h * 0 )
		MouseSign:SetSize( w , h  )
		MouseSign:SetFont("PlayerCountFont")
		MouseSign:SetText( "[Left Click] to enable Mouse" )
		MouseSign:SetColor( Color( 255, 255, 255, 255 ) )
		--[[
		local SettingsButton = vgui.Create( "DButton", PlayerboardFrame )
		SettingsButton:SetPos( w * .9, h * .07 )
		SettingsButton:SetSize( w * .1, h * .04 )
		SettingsButton:SetFont("PlayerCountFont")
		SettingsButton:SetText("Settings")
		SettingsButton:SetColor(menuColor)
		SettingsButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, menuColor )
			draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) )
		end
		SettingsButton.DoClick = function()
			if( !IsValid( SettingsMenu ) ) then
				OpenSettings()
				SettingsButton:SetText("Close")
				SettingsButton:SetColor( Color( 190, 0, 0, 255 ) )
				SettingsButton.Paint = function(self, w, h)
					draw.RoundedBox( 0, 0, 0, w, h, menuColor )
					draw.RoundedBox( 0, 2, 2, w-2, h-4, Color( 20, 20, 20, 255 ) )
				end
			else
				SettingsMenu:Remove()
				SettingsButton:SetText("Settings")
				SettingsButton:SetColor(menuColor)
				SettingsButton.Paint = function(self, w, h)
					draw.RoundedBox( 0, 0, 0, w, h, menuColor )
					draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) )
				end
			end
		end
		]]
		local PlayerPanel = vgui.Create("DScrollPanel", PlayerboardFrame)
		PlayerPanel:SetPos( w * 0, h * .15 )
		PlayerPanel:SetSize( w * .65, h * .85)
		local ypos = 0
		for i = 1, currentPlayers do
		
			local ply = players[i]
			local plyColor = team.GetColor( ply:Team() )
			
			local PlayerCard = vgui.Create("DPanel", PlayerPanel)
			PlayerCard:SetPos( PlayerPanel:GetWide() * 0, ypos)
			PlayerCard:SetSize( PlayerPanel:GetWide() * 1, PlayerPanel:GetTall() * .09 )
			PlayerCard.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, plyColor )
				draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 30, 30, 30, 255 ) )
			end
			
			-- Player Card
			
			local AvatarFrame = vgui.Create( "DButton", PlayerCard )
			AvatarFrame:SetPos( PlayerCard:GetTall() * .1, PlayerCard:GetTall() * .1 )
			AvatarFrame:SetSize( PlayerCard:GetTall() * .8, PlayerCard:GetTall() * .8 )
			AvatarFrame:SetText("")
			AvatarFrame.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, plyColor )
			end
			AvatarFrame.DoClick = function()
				ply:ShowProfile()
			end
			
			local Avatar = vgui.Create( "AvatarImage", AvatarFrame )
			Avatar:SetPos(AvatarFrame:GetWide() * .035, AvatarFrame:GetTall() * .035)
			Avatar:SetSize(AvatarFrame:GetWide() * .95, AvatarFrame:GetTall() * .95)
			Avatar:SetMouseInputEnabled(false)
			Avatar:SetPlayer(ply, 64)
			
			local locationName = "Location: Unknown"
			
			if (ply:GetTheater() == nil) then 
				locationName = "Location: ".. ply:GetLocationName()
			else
				locationName = "Location: ".. ply:GetTheater():Name()
			end
			--[[
			if(ply:GetNWBool("LocationHidden")) then
				locationName = "Location: Hidden"
			end
			]]
			local Level = vgui.Create("DLabel", PlayerCard )
			Level:SetSize( PlayerCard:GetWide(), PlayerCard:GetTall() )
			Level:SetPos( PlayerCard:GetWide() * .11, PlayerCard:GetTall() * .25 )
			Level:SetText( "Level: ".. GetLevel( ply ) .." | Credits: ".. GetCredits( ply ) .." | ".. locationName )
			Level:SetFont( "PlayerStatsFont" )
			Level:SetColor( Color( 140, 140, 140, 255 ) )
			--[[
			local ProfileButton = vgui.Create("DButton", PlayerCard)
			ProfileButton:SetSize( PlayerCard:GetWide() * .15, PlayerCard:GetTall() * .35 )
			ProfileButton:SetPos( PlayerCard:GetWide() * .83, PlayerCard:GetTall() * .04 )
			ProfileButton:SetText( "Profile" )
			ProfileButton:SetFont( "ProfileButtonFont" )
			ProfileButton.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 255 ) )
			end
			ProfileButton.DoClick = function()
				net.Start("OpenAchivMenu")
					net.WriteEntity( ply )
				net.SendToServer()
			end
			]]
			if( ply == LocalPlayer() ) then
			
				PingMarker = vgui.Create("DLabel", PlayerCard)
				PingMarker:SetSize( PlayerCard:GetWide(), PlayerCard:GetTall() )
				PingMarker:SetPos( PlayerCard:GetWide() * .95, PlayerCard:GetTall() * .25 )
				PingMarker:SetFont( "PlayerStatsFont" )
				PingMarker:SetText( --[[LocalPlayer():Ping()]] "000" )
				PingMarker:SetColor( Color(255, 255, 255, 255) )
				
				local pingIcon = vgui.Create( "Material", PlayerCard )
				pingIcon:SetSize( 1, 1 )
				pingIcon:SetPos( PlayerCard:GetWide() * .9, PlayerCard:GetTall() * .5 )
				pingIcon:SetMaterial("cheesy_bologna/ping_ico.png")
				
			end
			
			local Name = vgui.Create("DLabel", PlayerCard)
			Name:SetSize( PlayerCard:GetWide(), PlayerCard:GetTall() )
			Name:SetFont( "PlayerNameFont" )
			Name:SetText( ply:Name() )
			Name:SetColor( Color( 240, 240, 240, 255 ) )
			-- Badge
			Name:SetPos( PlayerCard:GetWide() * .11, PlayerCard:GetTall() * -.19 )
			
			ypos = ypos + PlayerCard:GetTall() * 1.05
			
		end
		
		SetUpTheaterboard()
	
	end

end

local function TogglePlayerboard(toggle)

	menuColor = borderColor

	if(toggle) then
		PlayerboardFrame = vgui.Create("DFrame")
		SetUpPlayerboard()
	else
		if( IsValid(PlayerboardFrame) ) then
			PlayerboardFrame:Remove()
		end
	end

end

hook.Add("ScoreboardShow", "chsh_open_scoreboard", function()

	if(!pbOpen) then
	pbOpen = true
	RemoveGamemodeScoreboard()
	TogglePlayerboard(true)
	end
	
end)

hook.Add("ScoreboardHide", "chsh_close_scoreboard", function()

	pbOpen = false
	ClosePopUpWindows()
	TogglePlayerboard(false)

end)

hook.Add( "KeyPress", "chsh_popup_mouse", function( ply, key )

	if(pbOpen) then

		if( IsValid(PlayerboardFrame) ) then

			if ( key == IN_ATTACK || key == 13 ) then
				
				PlayerboardFrame:MakePopup()
				
			end
		
		end
	
	end
	
end )
hook.Add( "PlayerInitialSpawn", "load_theaters", function() 
	theater.PollServer()
end)

hook.Add( "Tick", "UpdateTheatersThink", UpdateTheaters)