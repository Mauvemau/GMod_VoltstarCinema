
local function GivePlayerLoadout(ply, team)

	for i = 1, table.Count(CHRoles) do
		if( team == CHRoles[i].id )then
			local loadout = CHRoles[i].loadout
			
			for i = 1, table.Count(loadout) do
				ply:Give(loadout[i])
			end
		
		end
	end
	
end

local function AssignPlayerTeam(ply)
	local teams = team.GetAllTeams()
	local plyGroup = ply:GetUserGroup()
	
	for k, v in pairs( teams ) do
		local teamName = v.Name
		
		if( teamName == plyGroup ) then
			ply:SetTeam( k )
			GivePlayerLoadout(ply, teamName)
			return
		end
	end

	print( "[CHSHOP](ULX) No teams related to any ULX user group found." )
end
hook.Add( "PlayerSpawn", "assign_ch_team", function( ply ) AssignPlayerTeam(ply) end)

print( "Roles uploaded SERVER" )