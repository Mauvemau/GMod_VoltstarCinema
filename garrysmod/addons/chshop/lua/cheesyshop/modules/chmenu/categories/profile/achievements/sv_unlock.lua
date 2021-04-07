-- Receives how many times a player ate popcorn.
function CheckPopcornAchievement(ply, ate)
	if(ate >= 144)then ACH:UnlockAchievement(ply, 3) end
	if(ate >= 1444)then ACH:UnlockAchievement(ply, 13) end
	if(ate == 25)then ply:ChatPrint("You ate popcorn 25 times.") end
	if(ate == 50)then ply:ChatPrint("You ate popcorn 50 times.") end
	if(ate == 100)then ply:ChatPrint("You ate popcorn 100 times.") end
	if(ate == 200)then ply:ChatPrint("You ate popcorn 200 times.") end
	if(ate == 400)then ply:ChatPrint("You ate popcorn 400 times.") end
	if(ate == 800)then ply:ChatPrint("You ate popcorn 800 times.") end
	if(ate == 1000)then ply:ChatPrint("You ate popcorn 1000 times.") end
end

-- Unlocks achievement for killing in the dangerzone.
function CheckDangerzoneAchievement(ply)
	if(GetDangerzoneKills(ply) >= 25)then ACH:UnlockAchievement(ply, 64) end
	if(GetDangerzoneKills(ply) >= 100)then ACH:UnlockAchievement(ply, 65) end
	if(GetDangerzoneKills(ply) >= 600)then ACH:UnlockAchievement(ply, 66) end
	if(GetDangerzoneKills(ply) >= 1000)then ACH:UnlockAchievement(ply, 67) end
end

-- Unlocks achievement after purchasing from the shop.
function CheckShopAchievement(ply)
	if(GetPlayermodelsOwned(ply) >= 5)then ACH:UnlockAchievement(ply, 39) end
	if(GetPlayermodelsOwned(ply) >= 32)then ACH:UnlockAchievement(ply, 60) end
	if(GetPlayermodelsOwned(ply) >= 79)then ACH:UnlockAchievement(ply, 61) end
end

-- Unlocks achievement for credits wasted/earned.
function CheckCreditAchievement(ply)
	if(GetEarnedSlots(ply) >= 30000)then ACH:UnlockAchievement(ply, 21) end
	if(GetWastedSlots(ply) >= 30000)then ACH:UnlockAchievement(ply, 22) end
	
	if(GetWastedShop(ply) >= 30000)then ACH:UnlockAchievement(ply, 38) end
end

-- Unlocks achievements for playtime milestone.
function CheckPlaytimeAchievement(ply)
	if(GetPlaytime(ply) >= 7200)then ACH:UnlockAchievement(ply, 28) end
	if(GetPlaytime(ply) >= 36000)then ACH:UnlockAchievement(ply, 30) end
	if(GetPlaytime(ply) >= 180000)then ACH:UnlockAchievement(ply, 32) end
	if(GetPlaytime(ply) >= 604800)then ACH:UnlockAchievement(ply, 34) end
	if(GetPlaytime(ply) >= 2592000)then ACH:UnlockAchievement(ply, 57) end
end

-- Unlocks achievements for level milestone.
function CheckLevelAchievement(ply)
	if(GetLevel(ply) > 5)then ACH:UnlockAchievement(ply, 1) end
	if(GetLevel(ply) >= 50)then ACH:UnlockAchievement(ply, 10) end
	if(GetLevel(ply) >= 100)then ACH:UnlockAchievement(ply, 16) end
	if(GetLevel(ply) >= 500)then ACH:UnlockAchievement(ply, 19) end
	if(GetLevel(ply) >= 1000)then ACH:UnlockAchievement(ply, 58) end
end

-- Unlocks achievements for amount of videos watched.
function CheckVideoAchievement(ply)
	if(GetVideosWatched(ply) > 15)then ACH:UnlockAchievement(ply, 5) end
	if(GetVideosWatched(ply) > 150)then ACH:UnlockAchievement(ply, 12) end
	if(GetVideosWatched(ply) > 1500)then ACH:UnlockAchievement(ply, 17) end
	if(GetVideosWatched(ply) > 10000)then ACH:UnlockAchievement(ply, 59) end
end

-- (DO NOT EDIT) Automatically unlocks video achievements. Refer to sh_achievements to make video achievements.
function GiveVideoAchiv(ply, link, dur)
	for k, v in pairs(achVideos)do
		if(v.link == link) and (dur >= v.lenght) then
			ACH:UnlockAchievement(ply, v.achID)
		end
	end

	if(dur >= 120)then PlayerVars:AddVideoWatched(ply) end
	--Unlock achievements for time of videos watched
	if(dur >= 10800)then ACH:UnlockAchievement(ply, 7) end
	if(dur >= 1800)then ACH:UnlockAchievement(ply, 29) end
end

-- Unlock by logging in.
local function GiveLoginAchiv(ply)
	ACH:UnlockAchievement(ply, 6)
end
hook.Add("PlayerInitialSpawn", "unlock_login_achiv", function(ply)
	timer.Simple(5, function()
		GiveLoginAchiv(ply)
		timer.Simple(5, function()
			CheckLevelAchievement(ply)
		end)
	end)
end)
	
-- Unlock Achievements by typing something in chat.
function CheckChatAchievement(ply, txt)
	if(string.match(string.lower(txt), "dooky"))then ACH:UnlockAchievement(ply, 9) end
	if(string.match(string.lower(txt), "awoo") && ply:GetModel() == "models/kemono_friends/gray_wolf/gray_wolf_player.mdl")then ACH:UnlockAchievement(ply, 11) end
	if(string.match(string.lower(txt), "bulge"))then ACH:UnlockAchievement(ply, 27) end
	if(string.match(string.lower(txt), string.lower(ply:Name())))then ACH:UnlockAchievement(ply, 33) end
end
hook.Add("PlayerSay", "chsh_chat_achievements", function(ply, text)
	CheckChatAchievement(ply, text)
end)
-- Simply for the dying achivement.
hook.Add("PlayerDeath", "chsh_death_achievement", function(victim, inflictor, attacker)
	ACH:UnlockAchievement(victim, 14)
end)

-- Unlock achivemenets by location.
function CheckLocationAchievement(ply, location)
	local loc = string.lower(location)
	--if(loc == "minecraft theater")then ACH:UnlockAchievement(ply, 26) end
	if(loc == "minecraft theater")then ACH:UnlockAchievement(ply, 26) end
end
hook.Add("PlayerChangeLocation", "chsh_location_achievement", function(ply)
	if(ply:IsConnected() && ply:IsFullyAuthenticated())then
		CheckLocationAchievement(ply, ply:GetLocationName())
	end
end)

-- Unlock achievement by pressing E on things.
function CheckUseAchievement(ply, thing)
	if(thing:GetName() == "Litty Titty" && thing:GetClass() == "func_button")then ACH:UnlockAchievement(ply, 53) end
	if(thing:GetName() == "trickortreat" && thing:GetClass() == "func_button")then ACH:UnlockAchievement(ply, 54) end
	if(thing:GetName() == "zero" && thing:GetClass() == "func_button")then ACH:UnlockAchievement(ply, 55) end
	if(thing:GetName() == "taxi track" && thing:GetClass() == "func_tanktrain")then ACH:UnlockAchievement(ply, 56) end
	if(thing:GetName() == "present1" && thing:GetClass() == "func_button")then ACH:UnlockAchievement(ply, 68) end
end
hook.Add("PlayerUse", "chsh_use_achievement", function(ply, ent)
	if(ent:GetClass() != "func_button" && ent:GetClass() != "func_tanktrain")then return end
	CheckUseAchievement(ply, ent)
end)
