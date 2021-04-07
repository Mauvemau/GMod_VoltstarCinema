local clAFK = false

local function AFKHud()
	local tall = ScrH() * .08

	if(clAFK)then
		draw.RoundedBox(0, 0, ScrH() - tall, ScrW(), tall, Color(255, 50, 50, 80))
		draw.SimpleText("YOU ARE AFK", "chsh_afk_font", (ScrW() * .5), ScrH() - (tall * .5), Color(255, 255, 255), 1, 1)
	end
end
hook.Add("HUDPaint", "chsh_afk_hud", AFKHud)

local function SetSelfAFK(afk)
	local textcolor = Color(200, 200, 200, 255)
	local redcolor = Color(255, 50, 50 , 255)

	local ply = LocalPlayer()
	
	if(afk)then
		clAFK = true
		chat.AddText(team.GetColor(ply:Team()), "You", textcolor, " are now ", redcolor, "AFK")
	else
		clAFK = false
		chat.AddText(team.GetColor(ply:Team()), "You", textcolor, " are no longer ", redcolor, "AFK")
	end

end

local function SetAFK(ply, afk)
	local textcolor = Color(200, 200, 200, 255)
	local redcolor = Color(255, 50, 50 , 255)
	
	if(afk)then
		chat.AddText(team.GetColor(ply:Team()), ply:Name(), textcolor, " is now ", redcolor, "AFK")
	else
		chat.AddText(team.GetColor(ply:Team()), ply:Name(), textcolor, " is no longer ", redcolor, "AFK")
	end
end

net.Receive("chch_announce_afk", function()
	local ply = net.ReadEntity()
	local afk = net.ReadBool()
	
	if(!IsValid(ply) || !ply:IsPlayer()) then return end
	
	ply.AFK = afk
	
	if(ply:SteamID() != LocalPlayer():SteamID())then
		SetAFK(ply, afk)
	else
		SetSelfAFK(afk)
	end
end)