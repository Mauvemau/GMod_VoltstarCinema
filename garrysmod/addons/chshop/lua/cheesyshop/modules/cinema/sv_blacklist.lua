
util.AddNetworkString("THKickPlayer")
util.AddNetworkString("BlacklistPlayer")
util.AddNetworkString("UpdateClientBlacklist")

function KickOut(ply)

	if( ply:IsAdmin() ) then return end
	
	ply:SetPos( Vector(-828, -582, 1365) )
	
	if(!ply:Alive()) then
		ply:Spawn()
	end
	
end

net.Receive("THKickPlayer", function( len, ply )

	local victim = net.ReadEntity()
	
	if(ply:GetTheater() == nil) then return end
	if(victim:GetTheater() == nil) then return end
	
	if(ply:GetLocation() == victim:GetLocation()) then
		KickOut(victim)
	end

end)

local function SendModifiedBlacklist(thID, ply)

	local th = theater.GetByLocation(thID)
	local blacklist = th:GetBlacklist()
	
	net.Start("UpdateClientBlacklist")
		net.WriteTable( blacklist )
	net.Send(ply)

end

local function AddPlayer(thID, plyID)

	local th = theater.GetByLocation(thID)
	
	--if(!IsValid(th)) then print("Invalid Theater") return end
	
	local blacklist = th:GetBlacklist()
	
	if(table.HasValue(blacklist, plyID)) then print("Player already in blacklist") return end
	
	table.insert(blacklist, plyID)
	
	th:SetBlacklist(blacklist)
	
	print( "Blacklisted [".. plyID .."] from ".. th:Name() )

end

local function RemovePlayer(thID, plyID)

	local th = theater.GetByLocation(thID)
	
	--if(!IsValid(th)) then print("Invalid Theater") return end
	
	local blacklist = th:GetBlacklist()
	
	if(!table.HasValue(blacklist, plyID)) then print("Player not blacklisted") return end
	
	table.RemoveByValue( blacklist, plyID )
	
	th:SetBlacklist(blacklist)
	
	print( "Removed [".. plyID .."] from ".. th:Name() .."'s blacklist" )

end

net.Receive("BlacklistPlayer", function(len, ply)

	-- Reads
	local rawID = net.ReadString()
	local victim = net.ReadEntity()
	local bl = net.ReadBool()
	--
	
	thID = util.StringToType(rawID, "Int")
	
	local th = theater.GetByLocation( thID )
	
	--if(!IsValid(th)) then print("Invalid Theater") return end
	
	local owner = ply
	local victimID = victim:SteamID()
	
	if( !ply:IsAdmin() ) then 
		--if(th:GetOwner() == nil) then return end
		if( !th:GetOwner():IsPlayer() ) then return end
		
		if(th:GetOwner():SteamID() != owner:SteamID()) then print("Invalid owner") return end
		
	end
	
	if(bl) then
	
		AddPlayer(thID, victimID)
		
		if(victim:GetTheater() != nil) then
			if(victim:GetTheater():Name() == th:Name()) then
				KickOut(victim) -- Spaghetti lord
			end
		end
		
		ACH:UnlockAchievement(ply, 42)
	else
		RemovePlayer(thID, victimID)
	end

	SendModifiedBlacklist(thID, owner)

end)

function WipeBlacklist(thID)

	local th = theater.GetByLocation(thID)
	
	--if(!IsValid(th)) then print("Invalid Theater") return end
	
	blacklist = {}
	
	th:SetBlacklist(blacklist)
	
	print("Wiped ".. th:Name() .."'s blacklist")
	
	PrintTable(th:GetBlacklist())

end

function IsBlacklisted(thID, ply)

	local th = theater.GetByLocation(thID)
	local plyID = ply:SteamID()
	
	--if(!IsValid(th.Blacklist)) then print("Invalid Theater") return end
	
	local blacklist = th:GetBlacklist()
	
	return table.HasValue(blacklist, plyID)

end

function OnEnterTheater(thID, ply)

	if(IsBlacklisted(thID, ply)) then
		KickOut(ply)
	end

end
