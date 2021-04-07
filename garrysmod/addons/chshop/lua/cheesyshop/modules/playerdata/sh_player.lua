
-- Returns the player's title.
function GetTitle(ply)
	return ply:GetNWString("player_title") or ""
end

-- Returns the current level of a player.
function GetLevel(ply)
	return ply:GetNWInt("ch_level")
end

-- Returns the current XP of a player.
function GetXP(ply)
	return ply:GetNWInt("ch_xp")
end

-- Returns the current Needed XP of a player.
function GetNeededXP(ply)
	return ply:GetNWInt("ch_neededxp")
end 

-- Returns the current credits of a player.
function GetCredits(ply)
	return ply:GetNWInt("ch_credits")
end

function GetPlaytime(ply)
	return ply.PlayTime or 0
end

function GetAFK(ply)
	return ply.AFK or false
end

function GetPMCoupons(ply)
	return ply:GetNWInt("ch_plycoupons") or 0
end

-- Extras

function GetEarnedSlots(ply)
	return ply:GetNWInt("slots_earned", 0)
end

function GetWastedSlots(ply)
	return ply:GetNWInt("slots_wasted", 0)
end

function GetWastedShop(ply)
	return ply:GetNWInt("shop_wasted", 0)
end

function GetVideosWatched(ply)
	return ply:GetNWInt("videos_watched", 0)
end

function GetDangerzoneKills(ply)
	return ply:GetNWInt("dangerzone_kills", 0)
end

function GetDangerzoneDeaths(ply)
	return ply:GetNWInt("dangerzone_deaths", 0)
end

function GetEarnedGeneral(ply)
	local earned = ply:GetNWInt("general_earned", 0) + ply:GetNWInt("slots_earned", 0)
	return earned
end

function GetWastedGeneral(ply)
	local wasted = ply:GetNWInt("shop_wasted", 0) + ply:GetNWInt("slots_wasted", 0)
	return wasted
end