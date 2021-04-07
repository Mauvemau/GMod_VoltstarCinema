if(SERVER)then
	util.AddNetworkString( "chch_update_teams_on_client" )
end

CHRoles = {}
CHRoles[1] = {
	id = "user",
	color = Color(50, 255, 255, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera"}
}
CHRoles[2] = {
	id = "donator",
	color = Color(255, 77, 169, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera"}
}
CHRoles[3] = {
	id = "moderator",
	color = Color(250, 170, 40, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera", "weapon_physgun"}
}
CHRoles[4] = {
	id = "super mod",
	color = Color(138, 43, 226, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera", "weapon_physgun"}
}
CHRoles[5] = {
	id = "developer",
	color = Color(255, 50, 50, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera", "weapon_physgun"}
}
CHRoles[6] = {
	id = "co-owner",
	color = Color(255, 169, 255, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera", "weapon_physgun"}
}
CHRoles[7] = {
	id = "owner",
	color = Color(50, 255, 50, 255),
	loadout = {"weapon_empty_hands", "weapon_popcorn_small", "weapon_voltstar_camera", "weapon_physgun"}
}
local baseindex = 30

local function SetUpTeams()

	if( CHRoles == nil ) then print( "[CHSHOP](ULX) Error, role table doesn't exist." ) return end
	
	local roleCount = table.Count( CHRoles )
	if( roleCount < 1 ) then print( "[CHSHOP](ULX) Error, role table is empty." ) return end
	print( "[CHSHOP](ULX) ".. roleCount .." teams loaded!" )
	
	for i = 1, roleCount do
		team.SetUp(i + baseindex, CHRoles[i].id, CHRoles[i].color, false)
	end
	print( "[CHSHOP](ULX) Teams successfully created." )

end
hook.Add( "CreateTeams", "create_ch_teams", SetUpTeams)
concommand.Add("chsh_refresh_roles", function()
	if(SERVER) then
		net.Start("chch_update_teams_on_client")
		net.Broadcast()
	end
	SetUpTeams()
end)
net.Receive("chch_update_teams_on_client", function()
	if(CLIENT)then
		SetUpTeams()
	end
end)

print( "Roles uploaded SHARED" )