
local function PrintCommand(ply, str)
	if(!IsValid(ply) || !ply:IsPlayer()) then return end
	
	local gray = Color(200, 200, 200, 255)
	
	chat.AddText(team.GetColor(ply:Team()), ply:Name(), gray, " ".. str)
end
net.Receive("chsh_announce_command", function()
	local ply = net.ReadEntity(ply)
	local str = net.ReadString(str)
	
	PrintCommand(ply, str)
end)