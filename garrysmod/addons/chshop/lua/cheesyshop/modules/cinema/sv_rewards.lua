
Rewards = {}

-- Cinema Rewards --

-- Calculates the amount of XP and Credits rewarded from a video depending the amount of seconds that video has been playing, and a multiplier.
function Rewards:CalculateVideoRewards( amountSeconds, multiplier ) -- Base multiplier
	
	print( "Seconds: ".. amountSeconds ..", Multipiler: ".. multiplier * 100 .."%." )
	-- The amount of seconds played get multiplied by the base multiplier, then multiplied by the general multiplier.
	local value = (amountSeconds * multiplier) * GetConVar("chsh_general_multiplier"):GetInt()
	
	print( "Reward (Credits/XP): ".. math.Round(value) .."." )
	return math.Round( value ) -- Always round the result.
end

-- Rewards XP and Credits to all the players inside a theater after a video ends.
function Rewards:GiveVideoRewards(thID, videoTime, url)

	local th = theater.GetByLocation( thID ) -- Get the reference of the theater by id.
	if( th._Video._VideoType == '' )then return end -- If nothing was playing then don't reward credits.
	print( "Theater: ".. th._Name ..", Seconds Played: ".. videoTime .."." )
	
	local amountXP = self:CalculateVideoRewards(videoTime, (GetConVar("chsh_xp_multiplier"):GetInt() * 0.01 ) )
	local amountCredits = self:CalculateVideoRewards( videoTime, (GetConVar("chsh_credits_multiplier"):GetInt() * 0.01 ) )
	
	-- If exceeds the cap, change it to the maximum value.
	if( amountXP > GetConVar("chsh_xp_cap"):GetInt() ) then amountXP = GetConVar("chsh_xp_cap"):GetInt() end
	if( amountCredits > GetConVar("chsh_credits_cap"):GetInt() ) then amountCredits = GetConVar("chsh_credits_cap"):GetInt() end
	
	local plys = player.GetAll()
	for i = 1, table.Count(plys) do
		local ply = plys[i]
		if( ply:GetTheater() == th )then
			if(GetAFK(ply))then 
				ply:ChatPrint("You are afk, you'll receive less credits and experience from videos.")
				PlayerVars:AddXP(ply, amountXP * .25)
				PlayerVars:AddCredits(ply, amountCredits * .25)
				ply:ChatPrint("You received ".. math.Round(amountXP * .25) .." XP and ".. math.Round(amountCredits * .25) .." Credits from the video.")
			else
				PlayerVars:AddXP(ply, amountXP)
				PlayerVars:AddCredits(ply, amountCredits)
				ply:ChatPrint("You received ".. math.Round(amountXP) .." XP and ".. math.Round(amountCredits) .." Credits from the video.")
			end
			PlayerData:Save(ply)
			GiveVideoAchiv(ply, url, videoTime)
		end
	end
end
hook.Add("chsh_cinema_video_rewards", "give_video_rewards", function(th, startTime, url)
	print(url)
	local seconds = CurTime() - startTime
	if(seconds < 0 || seconds == nil)then seconds = 0 end
	Rewards:GiveVideoRewards(th, seconds, url)
end)