
local function InitPlayTime(ply, t)
	local delay = 1
	ply.PlayTime = t
	if(ply == LocalPlayer())then
		timer.Create("chsh_playtime_counter_cl", delay, 0, function()
			if(ply == nil)then return end
			ply.PlayTime = ply.PlayTime + delay
		end)
	end
end
net.Receive("chsh_update_playtime", function()
	local ply = net.ReadEntity()
	local t = net.ReadString()
	InitPlayTime(ply, t)
end)