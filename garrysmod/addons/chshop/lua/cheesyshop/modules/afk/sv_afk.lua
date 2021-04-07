util.AddNetworkString("chch_announce_afk")

local function SetAFK(ply, afk)
	ply.AFK = afk
	net.Start("chch_announce_afk")
		net.WriteEntity(ply)
		net.WriteBool(afk)
	net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "chsh_init_afk", function(ply)
	ply.NextAFK = CurTime() + GetConVar("chsh_afk_time"):GetInt()
end)

hook.Add("Think", "chsh_handle_afk", function()
	local players = player.GetAll()
	for k, ply in pairs(players)do
		if(ply:IsConnected() and ply:IsFullyAuthenticated())then
		
			if(!ply.NextAFK)then
				ply.NextAFK = CurTime() + GetConVar("chsh_afk_time"):GetInt()
			end
			
			local afktime = ply.NextAFK
			if(CurTime() >= afktime) and (!ply.AFK)then
				SetAFK(ply, true)
			end
		
		end
	end

end)

hook.Add("KeyPress", "chsh_player_moved", function(ply, key)
	ply.NextAFK = CurTime() + GetConVar("chsh_afk_time"):GetInt()
	
	if(ply.AFK)then
		SetAFK(ply, false)
	end
end)
hook.Add("PlayerSay", "chsh_afk_player_spoke", function(ply, text)
	ply.NextAFK = CurTime() + GetConVar("chsh_afk_time"):GetInt()
	
	if(ply.AFK)then
		SetAFK(ply, false)
	end
end)

concommand.Add("chsh_set_afk", function(ply, cmd, args)
	if(ply.AFK)then return end
	SetAFK(ply, true)
end)