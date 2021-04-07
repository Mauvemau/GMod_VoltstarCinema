
net.Receive("chsh_announce_join_message", function(len)
	local color = net.ReadTable()
	local name = net.ReadString()
	chat.AddText(color, name, Color(255, 255, 255, 255), " has joined ", Color(255, 50, 50, 255), "★Voltstar Cinema★")
end)

net.Receive("chsh_announce_leave_message", function(len)
	local color = net.ReadTable()
	local name = net.ReadString()
	chat.AddText(color, name, Color(255, 255, 255, 255), " has left the server.")
end)