surface.CreateFont( "LeaderboardTitleFont", {
	font      = "Open Sans Condensed",
	size      = 40,
	weight    = 900,
	antialias = true
})

surface.CreateFont( "LeaderboardFont", {
	font      = "Open Sans Condensed",
	size      = 30,
	weight    = 900,
	antialias = true
})

-- Medieval Location --
--local leaderboardPos = {
--Vector(-1052.5, -2327.5, -1108.5)

-- Default Map Location --
local leaderboardPos = {
	Vector(280.5, -2168.5, -1084.5)

}

local txtLevel = "Loading..."
local txtPlaytime = "Loading..."


hook.Add("PostDrawOpaqueRenderables", "DrawLeaderboards", function()

	cam.Start3D2D( leaderboardPos[1], Angle(0, -90, 90), 0.2)
		draw.RoundedBox( 0, -140, -30, 500, 372, Color( 0, 0, 0, 220) )
		draw.DrawText( "Level Leaderboard", "LeaderboardTitleFont", -10, -15, borderColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( txtLevel, "LeaderboardFont", -110, 20, Color( 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT )
		
		draw.RoundedBox( 0, 435, -30, 500, 372, Color( 0, 0, 0, 220) )
		draw.DrawText( "Playtime Leaderboard", "LeaderboardTitleFont", 585, -15, borderColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( txtPlaytime, "LeaderboardFont", 465, 20, Color( 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT )
	cam.End3D2D()
	
end)


net.Receive( "chsh_refresh_leaderboards", function()
	txtLevel = net.ReadString()
	txtPlaytime = net.ReadString()
end) 