
util.AddNetworkString("chsh_announce_join_message")
util.AddNetworkString("chsh_announce_leave_message")

hook.Add("PlayerInitialSpawn", "chsh_join_message", function(ply)
	timer.Simple(5, function()
		net.Start("chsh_announce_join_message")
			net.WriteTable(team.GetColor(ply:Team()))
			net.WriteString(ply:Name())
		net.Broadcast()
	end)
end)

hook.Add("PlayerDisconnected", "chsh_leave_message", function(ply)
	net.Start("chsh_announce_leave_message")
		net.WriteTable(team.GetColor(ply:Team()))
		net.WriteString(ply:Name())
	net.Broadcast()
end)
