
util.AddNetworkString("chsh_change_title")

EXTRAS = {}

function EXTRAS:TransferOld(ply)
	if(util.StringToType(util.GetPData(ply:SteamID(), "chsh_extras_transfered", false), "bool"))then return end
	util.SetPData(ply:SteamID(), "chsh_videos_watched", util.GetPData( ply:SteamID(), "CB_VWatched" , 0))
	util.SetPData(ply:SteamID(), "chsh_extras_transfered", true)
end

function EXTRAS:LoadStats(ply)
	print("[CHSH] Setting up extras...")
	ply:SetNWInt("slots_earned", util.StringToType(util.GetPData(ply:SteamID(), "chsh_earned_slots", 0), "int"))
	ply:SetNWInt("slots_wasted", util.StringToType(util.GetPData(ply:SteamID(), "chsh_wasted_slots", 0), "int"))
	ply:SetNWInt("shop_wasted", util.StringToType(util.GetPData(ply:SteamID(), "chsh_wasted_shop", 0), "int"))
	ply:SetNWInt("videos_watched", util.StringToType(util.GetPData(ply:SteamID(), "chsh_videos_watched", 0), "int"))
	ply:SetNWInt("dangerzone_kills", util.StringToType(util.GetPData(ply:SteamID(), "chsh_kills", 0), "int"))
	ply:SetNWInt("dangerzone_deaths", util.StringToType(util.GetPData(ply:SteamID(), "chsh_deaths", 0), "int"))
	ply:SetNWInt("general_earned", util.StringToType(util.GetPData(ply:SteamID(), "chsh_general_earned", 0), "int"))
	ply:SetNWString("player_title", util.StringToType(util.GetPData(ply:SteamID(), "vs_title", ""), "string"))
	print("[CHSH] All extra stats loaded.")
end

function EXTRAS:SaveStats(ply)
	util.SetPData(ply:SteamID(), "chsh_earned_slots", ply:GetNWInt("slots_earned", 0))
	util.SetPData(ply:SteamID(), "chsh_wasted_slots", ply:GetNWInt("slots_wasted", 0))
	util.SetPData(ply:SteamID(), "chsh_wasted_shop", ply:GetNWInt("shop_wasted", 0))
	util.SetPData(ply:SteamID(), "chsh_videos_watched", ply:GetNWInt("videos_watched", 0))
	util.SetPData(ply:SteamID(), "chsh_kills", ply:GetNWInt("dangerzone_kills", 0))
	util.SetPData(ply:SteamID(), "chsh_deaths", ply:GetNWInt("dangerzone_deaths", 0))
	util.SetPData(ply:SteamID(), "chsh_general_earned", ply:GetNWInt("general_earned", 0))
	util.SetPData(ply:SteamID(), "vs_title", ply:GetNWString("player_title", ""))
end

net.Receive("chsh_change_title", function(len, ply)
	print("Changing  title for ".. ply:Name() .."...")
	local title = net.ReadString()
	PlayerVars:SetTitle(ply, title)
end)