
PlayerVars = {}

-- Levels up a player.
function PlayerVars:LevelUp( ply )
	local increase = (GetConVar("ch_xpneeded_increase"):GetInt() * .01) + 1 -- from percentage to multiplier.
	self:SetLevel(ply, GetLevel(ply) + 1)
	self:SetNeededXP(ply, GetNeededXP( ply ) * increase) -- multiplies it by the increase.
end
hook.Add( "ch_levelup", "ch_levelup_player", function( id )
	if( player.GetBySteamID( id ) )then
		local ply = player.GetBySteamID( id )
		PlayerVars:LevelUp( ply )
	end
end)

-- Sets the level for a player.
function PlayerVars:SetLevel(ply, value)
	ply:SetNWInt("ch_level", math.Round(value))
end

-- Adds an amount of XP to the player.
function PlayerVars:AddXP( ply, amount )
	--ply:ChatPrint( "You received ".. amount .." XP." )
	self:SetXP(ply, GetXP(ply) + amount)
	self:CheckLevelUp(ply)
	hook.Call("chsh_on_data_updated", nil, ply)
end

-- Removes an amount of XP from the player.
function PlayerVars:RemoveXP( ply, amount )
	local current = GetXP(ply)
	current = current - amount
	if(current < 0) then current = 0 end -- If under 0, then just set it to 0.
	self:SetXP(ply, GetXP(ply) - amount)
end

-- Sets the player's XP to certain value.
function PlayerVars:SetXP( ply, value )
	ply:SetNWInt("ch_xp", math.Round(value))
end

-- Sets the Needed XP of a player to a value.
function PlayerVars:SetNeededXP( ply, value )
	local val = value
	if(val > GetConVar("chsh_xpneeded_cap"):GetInt()) then val = GetConVar("chsh_xpneeded_cap"):GetInt() end -- If value exceeds the cap, it just sets it to the max value.
	ply:SetNWInt("ch_neededxp", math.Round(val))
end

-- Gives an amount of credits to the player.
function PlayerVars:AddCredits( ply, amount )
	--ply:ChatPrint( "You received ".. amount .." credits." )
	self:SetCredits(ply, GetCredits(ply) + amount)
	self:AddEarnedGeneral(ply, amount)
	hook.Call("chsh_on_data_updated", nil, ply)
end

-- Removes an amount of credits to the player.
function PlayerVars:RemoveCredits( ply, amount )
	local current = GetCredits(ply)
	current = current - amount
	if(current < 0) then current = 0 end -- If under 0, then just set it to 0.
	self:SetCredits(ply, current)
	hook.Call("chsh_on_data_updated", nil, ply)
end

-- Sets the player's credits to a value.
function PlayerVars:SetCredits( ply, value )
	ply:SetNWInt("ch_credits", math.Round(value))
end

-- Verifies if a player can level up and proceeds to level up that player if that's the case.
function PlayerVars:CheckLevelUp(ply)
	while( GetXP(ply) >= GetNeededXP(ply) )do -- While loop of death.
		self:RemoveXP(ply, GetNeededXP(ply))
		self:LevelUp(ply)
		CheckLevelAchievement(ply)
	end
end

function PlayerVars:SetPlaytime(ply, value)
	ply.PlayTime = math.Round(value)
end

function PlayerVars:SetCoupons(ply, value)
	ply:SetNWInt("ch_plycoupons", math.Round(value))
	PlayerData:SaveExtras(ply)
end

function PlayerVars:AddCoupons(ply, amount)
	ply:SetNWInt("ch_plycoupons", GetPMCoupons(ply) + math.Round(amount))
	PlayerData:SaveExtras(ply)
end

function PlayerVars:RemoveCoupons(ply, amount)
	local current = GetPMCoupons(ply)
	current = current - amount
	if(current < 0) then current = 0 end -- If under 0, then just set it to 0.
	ply:SetNWInt("ch_plycoupons", current)
	PlayerData:SaveExtras(ply)
end

function PlayerVars:AddEarnedSlots(ply, amount)
	ply:SetNWInt("slots_earned", ply:GetNWInt("slots_earned", 0) + amount)
	EXTRAS:SaveStats(ply)
	CheckCreditAchievement(ply)
end

function PlayerVars:AddWastedSlots(ply, amount)
	ply:SetNWInt("slots_wasted", ply:GetNWInt("slots_wasted", 0) + amount)
	EXTRAS:SaveStats(ply)
	CheckCreditAchievement(ply)
end

function PlayerVars:AddWastedShop(ply, amount)
	ply:SetNWInt("shop_wasted", ply:GetNWInt("shop_wasted", 0) + amount)
	EXTRAS:SaveStats(ply)
	CheckCreditAchievement(ply)
end

function PlayerVars:AddVideoWatched(ply)
	ply:SetNWInt("videos_watched", ply:GetNWInt("videos_watched", 0) + 1)
	EXTRAS:SaveStats(ply)
	CheckVideoAchievement(ply)
end

function PlayerVars:AddKill(ply)
	ply:SetNWInt("dangerzone_kills", ply:GetNWInt("dangerzone_kills", 0) + 1)
	EXTRAS:SaveStats(ply)
end

function PlayerVars:AddDeath(ply)
	ply:SetNWInt("dangerzone_deaths", ply:GetNWInt("dangerzone_deaths", 0) + 1)
	EXTRAS:SaveStats(ply)
end

function PlayerVars:AddEarnedGeneral(ply, amount)
	ply:SetNWInt("general_earned", ply:GetNWInt("general_earned", 0) + amount)
end

function PlayerVars:SetTitle(ply, title)
	if(string.len(title) > 50)then
		title = string.sub(title, 1, 50)
	end
	ply:SetNWString("player_title", title)
	EXTRAS:SaveStats(ply)
	print(ply:Name() .." changed their title to <".. title ..">")
end