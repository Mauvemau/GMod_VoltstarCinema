util.AddNetworkString("chsh_announce_achievement")

ACH = {}

function ACH:UnlockAchievement(ply, id)
	local achivName = "VS_A".. id
	
	if(achievements[id] == nil) then print("Achievement not valid.") return end
	if(!IsValid( ply )) or (!ply:IsPlayer()) then print("Invalid target.") return end
	
	if(util.GetPData(ply:SteamID(), achivName, nil) == nil) then
		util.SetPData(ply:SteamID(), achivName , true)
		self:AnnounceAchievements(ply, achievements[id].title)
		PlayerVars:AddXP(ply, achievements[id].xp)
		PlayerVars:AddCredits(ply, achievements[id].credits)
		if(achievements[id].coupon)then
			PlayerVars:AddCoupons(ply, 1)
		end
		self:InitAchievements(ply)
	end
end

function ACH:AnnounceAchievements(ply, achivName)

	print(ply:Name() .." has unlocked \"".. achivName .."\"")
	net.Start("chsh_announce_achievement")
		net.WriteEntity(ply)
		net.WriteString(achivName)
	net.Broadcast()
end

function ACH:ResetAchievements(ply)
	
	for k, v in pairs(achievements)do
		local achivName = "VS_A".. k
		if( util.GetPData( ply:SteamID(), achivName , nil) != nil ) then
			ply:RemovePData(achivName)
			ply:SetNWBool(achivName, nil)
		end
	end
	print("Achievements reset.")
end

local function TransferOldChieves(ply)
	
	for k, v in pairs(achievements)do
		local achivName = "A".. k
		if(util.GetPData(ply:SteamID(), achivName, false)) then
			ACH:UnlockAchievement(ply, k)
		end
	end
end

function ACH:InitAchievements(ply) -- I know this looks kinda disgusting, but i couldn't find another way to do it.
	
	for k, v in pairs(achievements)do
		local achivName = "VS_A".. k
		if(util.GetPData(ply:SteamID(), achivName, false)) then
			ply:SetNWBool(achivName, true)
		end
	end
end
hook.Add("PlayerInitialSpawn", "chsh_load_achievements", function(ply)
	timer.Simple(5, function()
		ACH:InitAchievements(ply)
	end)
end)
