util.AddNetworkString("chsh_change_nColor")
util.AddNetworkString("chsh_change_pColor")
util.AddNetworkString("chsh_change_wColor")

local function ChangeNameColor(ply, color)

end

-- Player Color
local function ChangePlayerColor(ply, color)
	ply:SetPlayerColor(Vector(color))
end
net.Receive("chsh_change_pColor", function(len, ply) 
	local col = Vector(net.ReadString())
	ChangePlayerColor(ply, col)
end)

-- Weapon Color
local function ChangeWeaponColor(ply, color)
	ply:SetWeaponColor(color)
end
net.Receive("chsh_change_wColor", function(len, ply) 
	local col = Vector(net.ReadString())
	ChangeWeaponColor(ply, col)
end)

local function InitColors(ply)
	local pColor = Vector(ply:GetInfo("cl_playercolor"))
	local wColor = Vector(ply:GetInfo("cl_weaponcolor"))
	
	ply:SetPlayerColor(pColor)
	if wColor:Length() == 0 then
		wColor = Vector( 0.001, 0.001, 0.001 )
	end
	ply:SetWeaponColor(wColor)
end
hook.Add("PlayerSpawn", "chsh_setcolors", function(ply)
	timer.Simple(1, function()
		InitColors(ply)
	end)
end)
