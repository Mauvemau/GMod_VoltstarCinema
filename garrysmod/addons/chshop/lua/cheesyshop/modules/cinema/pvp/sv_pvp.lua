util.AddNetworkString("PVPAnnounce")

PVP = {}

PVP._enabled = true
PVP._corner1 = Vector( -4305.6030273438, 2413.7021484375, -3484.123046875 )
PVP._corner2 = Vector( 3543.3884277344, 8505.3095703125, -37.686325073242 )
PVP._players = {}
PVP._timer = 1;

local timerino = CurTime() + PVP._timer

PVP._blacklist = {
"models/captainbigbutt/vocaloid/chibi_miku_ap.mdl",
"models/player/dewobedil/umaru/umaru.mdl",
"models/player/zombie_soldier.mdl",
"models/player/dewobedil/maid_dragon/kanna/default_p.mdl",
"models/cyanblue/kemonofriends/tsuchinoko/tsuchinoko.mdl"
}

function PVP:IsInZone( victim )
	local entities = ents.FindInBox( self._corner1, self._corner2 )
	local isIn = false
	
	
	for i = 1, #entities do
		if ( entities[ i ] == victim ) then
			isIn = true
		end
	end
	
	return isIn
end

function PVP:GetPlayers()
	local entities = ents.FindInBox( self._corner1, self._corner2 )
	local players = {}
	
	table.foreach(entities, function( key, value)
		if( value:IsPlayer() ) then
			table.insert(players, value)
		end
	end)

	return players
end


function PVP:Announce(msg, id, global)
	
	if(!global) then
		
		local players = self:GetPlayers()
		
		table.foreach(players, function(key, value)
			net.Start("PVPAnnounce")
			net.WriteString(msg)
			net.WriteString(id)
			net.Send(value)
		end)
		
	else
		net.Start("PVPAnnounce")
		net.WriteString(msg)
		net.Broadcast()
	end
end

function FillPlayers()

	PVP._players = PVP:GetPlayers()

end

function ArmNewPlayers()

	local actualPlayers = PVP:GetPlayers()
	
	if(table.Count(actualPlayers) < 1) then return end
	
	for i = 1, table.Count(actualPlayers) do
		
		--Ajust Scale
		
		if( actualPlayers[i]:GetModelScale() != 1 ) then
			actualPlayers[i]:SetModelScale( 1, 0 )
		end
		
		if(!table.HasValue(PVP._players, actualPlayers[i]) ) then
			
			if( IsValid(actualPlayers[i]) ) then
				print(actualPlayers[i]) 
				
				
				--Check if model is blacklisted
				if( table.HasValue( PVP._blacklist, actualPlayers[i]:GetModel() ) ) then
						actualPlayers[i]:Kill()
						REWARDS:AnnounceVideoRewards(actualPlayers[i], "That playermodel is too small! To make things fair please use a regular sized playermodel.")
				else
				
					--Equip weapon
					actualPlayers[i]:StripWeapons()
					actualPlayers[i]:Give( "zck_snowballswep", false )
					
					
				end
				
			end
		
		end
	
	end

end

function StripPlayers()

	local plys = player.GetAll()
	
	for i = 1, table.Count(plys) do
	
		if(!table.HasValue( PVP._players, plys[i] )) then
		
			local ply = plys[i]
			
			if( ply:HasWeapon( "zck_snowballswep" ) ) then
			
				ply:StripWeapon("zck_snowballswep")
			
			end
		end
	end
end

function PVP:CheckStreak(ply)

	if( self:GetKills(ply) == 3 ) then
		self:Announce(ply:Name() .." is on a 3 kill streak!", "1" , false)
		ACH:UnlockAchievement(ply, 4)
	end
	if( self:GetKills(ply) == 6 ) then
		self:Announce(ply:Name() .." is on a 6 kill streak!", "1" , false)
		ACH:UnlockAchievement(ply, 15)
	end
	if( self:GetKills(ply) == 12 ) then
		self:Announce(ply:Name() .." is on a epic kill streak!", "1" , false)
		ACH:UnlockAchievement(ply, 18)
	end

end

function PVP:ResetKills( ply )

	ply:SetNWInt( "PVPKills", 0 )

end

function PVP:AddKill( ply )

	ply:SetNWInt( "PVPKills", ply:GetNWInt( "PVPKills" ) + 1 )
	self:CheckStreak(ply)

end

function PVP:GetKills( ply )

	return ply:GetNWInt( "PVPKills" )

end

function PVP:SetKills( ply, kills )

	ply:SetNWInt( "PVPKills", kills )

end

hook.Add( "PlayerInitalSpawn", "InitPVP", function(len, ply)

	PVP:SetKills(ply, 0)

end)

hook.Add( "Think", "ArenaTimer", function()

	if(CurTime() > timerino) then
		timerino = CurTime() + PVP._timer
		ArmNewPlayers()
		FillPlayers()
		StripPlayers()
	end

end)

hook.Add("PlayerShouldTakeDamage", "chsh_dangerzone", function(ply, attacker)
	if(PVP:IsInZone(ply)) and (PVP:IsInZone(attacker)) then
		return true
	else
		return false
	end
end)


