surface.CreateFont( "NameTagFont", {
	font = "Open Sans Condensed",
	size = 32,
	weight = 1000,
	antialias = true,
} )

surface.CreateFont( "TitleFont", {
	font = "Arial",
	size = 15,
	weight = 1000,
	antialias = true,
} )

local function RemoveGamemodeNameplates()
	hook.Remove( "PostDrawTranslucentRenderables", "DrawPlayerNames" ) --  Remove Cinema nameplates.
end

local function DrawName( ply, opacityScale )

	if !IsValid(ply) or !ply:Alive() then return end
	
	RemoveGamemodeNameplates()
	
	local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
	if ( dist >= 120 ) then return end -- no need to draw anything if the player is far away
	
	local name = "  " .. string.upper( ply:GetName() )
	
	local plyPos = ply:GetPos() + Vector(0, 0, 52)
	
	local plyScreenPos = plyPos:ToScreen()
	
	cam.Start2D()
	draw.SimpleText( name, "NameTagFont", tonumber( plyScreenPos.x - 5) , tonumber( plyScreenPos.y ), team.GetColor( ply:Team() ), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER)
	draw.SimpleText( GetTitle(ply), "TitleFont", tonumber( plyScreenPos.x - 1 ) , tonumber( plyScreenPos.y + 20 ), Color(255,255,255,200), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER)
	cam.End2D()
	
end

local HUDTargets = {}
local fadeTime = 2
hook.Add( "PostDrawTranslucentRenderables", "chsh_draw_names", function()

	-- Don't render names while we're sitting down
	if GetConVar("cinema_drawnames") and !GetConVar("cinema_drawnames"):GetBool() then return end
	if !LocalPlayer().InTheater then return end
	if theater.Fullscreen then return end
	if IsValid( LocalPlayer():GetVehicle() ) then return end

	-- Draw lower opacity and recently targetted players in theater
	if LocalPlayer():InTheater() then

		for ply, time in pairs(HUDTargets) do

			if time < RealTime() then
				HUDTargets[ply] = nil
				continue
			end

			-- Fade over time
			DrawName( ply, 0.11 * ((time - RealTime()) / fadeTime) )

		end

		local tr = util.GetPlayerTrace( LocalPlayer() )
		local trace = util.TraceLine( tr )
		if (!trace.Hit) then return end
		if (!trace.HitNonWorld) then return end
		
		-- Keep track of recently targetted players
		if trace.Entity:IsPlayer() then
			HUDTargets[trace.Entity] = RealTime() + fadeTime
		elseif trace.Entity:IsVehicle() and
			IsValid(trace.Entity:GetOwner()) and
			trace.Entity:GetOwner():IsPlayer() then
			HUDTargets[trace.Entity:GetOwner()] = RealTime() + fadeTime
		end

	else -- draw all players names

		for _, ply in pairs( player.GetAll() ) do

			-- Don't draw name if either player is not in theater and the other is, etc.
			if (LocalPlayer():InTheater() and !ply:InTheater()) or
				(!LocalPlayer():InTheater() and ply:InTheater()) then
				continue
			end

			if ply != LocalPlayer() then
				DrawName( ply )
			end
		end

	end
	
end )
