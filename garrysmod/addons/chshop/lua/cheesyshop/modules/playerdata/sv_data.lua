
PlayerData = {}

-- Called when a new player joins the server. Sets up all the data for them.
function PlayerData:Init(ply)
	if(!self:Load(ply))then
	
		print("[CHSHOP] Initializing data...") -- All values after "or" indicate an error.
		
		PlayerVars:SetLevel(ply, GetConVar( "chsh_init_lvl" ):GetInt() or -1)
		PlayerVars:SetCredits(ply, GetConVar( "chsh_init_credits" ):GetInt() or -1)
		PlayerVars:SetXP(ply, 0)
		PlayerVars:SetNeededXP(ply, GetConVar( "chsh_init_neededxp" ):GetInt() or 99)
	end
	print("[CHSHOP] Initialization for ".. ply:Name() .." successful." )
end
hook.Add( "PlayerInitialSpawn", "ch_setup_player_data", function( ply )
	PlayerData:Init(ply)
	PlayerData:RestoreOld(ply)
	PlayerData:LoadExtras(ply)
	InitPlaytime(ply)
	EXTRAS:TransferOld(ply)
	EXTRAS:LoadStats(ply)
end)
hook.Add( "ch_reload_data", "ch_reload_player_data", function( id )
	if( player.GetBySteamID( id ) )then
		local ply = player.GetBySteamID( id )
		PlayerData:Init(ply)
	end
end)

-- Loads a player's data from the database, if data exists it loads it and returns true, if not it returns false.
function PlayerData:Load(ply)

	if(chsh_database_service == "pdata")then
		if( util.StringToType( util.GetPData(ply:SteamID(), "CB_NAMEID", nil), "string" ) != "nil" ) then -- I know, turning a string into a string, woah.
		
			print("[CHSHOP] Player data found, loading it in...")
			
			-- If you wonder why the actual hecc is the data named so differently from the actual variables, it's because my server uses an old database.
			PlayerVars:SetLevel(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_LEVEL", nil), "int" ))
			PlayerVars:SetCredits(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_CREDITS", nil), "int" ))
			PlayerVars:SetXP(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_EXP", nil), "int" ))
			PlayerVars:SetNeededXP(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_NEXP", nil), "int" ))
			
			print("[CHSHOP] Data for ".. ply:Name() .." loaded successfully!" )
			
			return true
		else
			print("[CHSHOP] Player data not found.")
			
			return false
		end
	elseif( chsh_database_service == "mysql" ) then
		print( "[CHSHOP] Loading MYSQL player data..." )
		return MYSQL:Load(ply)
	else
		print( "[CHSHOP] Invalid data storage service, select a valid data storage service in sv_chvars." )
	end
	
end

-- Saves current player's data into the database.
function PlayerData:Save(ply)
	if(!IsValid(ply) || !ply:IsPlayer()) then print("[CHSHOP] (ERROR) Invalid entity at sv_chdata.lua:60") return end
	print("[CHSHOP] Saving data for ".. ply:Name() )
	
	if(chsh_database_service == "pdata")then
		util.SetPData(ply:SteamID(), "CB_NAMEID", "[".. ply:SteamID() .."]".. ply:Name())
		util.SetPData(ply:SteamID(), "CB_LEVEL", GetLevel(ply))
		util.SetPData(ply:SteamID(), "CB_EXP", GetXP(ply))
		util.SetPData(ply:SteamID(), "CB_CREDITS", GetCredits(ply))
		util.SetPData(ply:SteamID(), "CB_NEXP", GetNeededXP(ply))
		util.SetPData(ply:SteamID(), "CB_PLAYTIME", GetPlaytime(ply))
	elseif(chsh_database_service == "mysql") then
		local data = { -- Catch the data immediately, in case the player disconnects while the database is saving the data.
			steamid = ply:SteamID(),
			lvl = GetLevel(ply),
			credits = GetCredits(ply),
			xp = GetXP(ply),
			neededxp = GetNeededXP(ply),
			playtime = GetPlaytime(ply),
			name = TransformInvalidNames(ply:Name())
		}
		--PrintTable(data)
		MYSQL:Save(data)
	else
		print( "[CHSHOP] Invalid data storage service, select a valid data storage service in sv_chvars." )
	end
	self:SaveExtras(ply)
	print("[CHSHOP] Data for ".. ply:Name() .." was saved!")
end
hook.Add( "chsh_on_data_updated", "save_changed_data", function(ply)
end)

-- Deletes all data related to that player from the database. (Testing purposes)
function PlayerData:Delete(ply)
	print("[CHSHOP] Deleting data for ".. ply:Name() )
	
	if(chsh_database_service == "pdata") then
		ply:RemovePData("CB_NAMEID")
		ply:RemovePData("CB_LEVEL")
		ply:RemovePData("CB_EXP")
		ply:RemovePData("CB_CREDITS")
		ply:RemovePData("CB_NEXP")
	elseif(chsh_database_service == "mysql") then
		MYSQL:Delete(ply)
	else
		print( "[CHSHOP] Invalid data storage service, select a valid data storage service in sv_chvars." )
	end
	print("[CHSHOP] Data for ".. ply:Name() .." was deleted.")
	self:Init(ply)
	
end

-- Creates a backup of a player's data. (Meant to help in case network variables happen to get corrupted.)
function PlayerData:Backup(ply)
	print("[CHSHOP] Doing a backup for ".. ply:Name() )

	if(GetLevel(ply) <= 0 || GetNeededXP(ply) <= 0) then
		print("[CHSHOP] Current data is corrupted, restoring from a previous backup.")
		self:LoadBackup(ply)
	end

	util.SetPData(ply:SteamID(), "CH_BACKUP_NAMEID", "[".. ply:SteamID() .."]".. ply:Name() )
	util.SetPData(ply:SteamID(), "CH_BACKUP_LVL", GetLevel(ply) )
	util.SetPData(ply:SteamID(), "CH_BACKUP_XP", GetXP(ply) )
	util.SetPData(ply:SteamID(), "CH_BACKUP_CREDITS", GetCredits(ply) )
	util.SetPData(ply:SteamID(), "CH_BACKUP_NEEDED_XP", GetNeededXP(ply) )

	print("[CHSHOP] Backup for ".. ply:Name() .." was completed!")

end

-- Loads previously saved backup of the player's data, if data exists it loads it and returns true, if not it returns false.
function PlayerData:LoadBackup(ply)
	print("[CHSHOP] Looking for a backup of the data.")
	
	if( util.StringToType( util.GetPData(ply:SteamID(), "CH_BACKUP_NAMEID", nil), "string" ) == "nil" ||
	util.StringToType( util.GetPData(ply:SteamID(), "CB_BACKUP_LVL", nil), "int" ) == 0 ) then
		print("[CHSHOP] No backup data found, initializing like normal.")
		self:Reset(ply)
	end
	
	print("[CHSHOP] Backup found!")
	
	PlayerVars:SetLevel(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_LEVEL", nil), "int" ))
	PlayerVars:SetCredits(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_CREDITS", nil), "int" ))
	PlayerVars:SetXP(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_EXP", nil), "int" ))
	PlayerVars:SetNeededXP(ply, util.StringToType( util.GetPData(ply:SteamID(), "CB_NEXP", nil), "int" ))
	
	print("[CHSHOP] Data for ".. ply:Name() .." has been restored." )
	
end

-- WARNING: Restarts all player data. (Developer and testing purposes only)
function PlayerData:Reset(ply)
	print("[CHSHOP] Resetting all data to defaults.")
	
	PlayerVars:SetLevel(ply, GetConVar( "chsh_init_lvl" ):GetInt() or -1)
	PlayerVars:SetCredits(ply, GetConVar( "chsh_init_credits" ):GetInt() or -1)
	PlayerVars:SetXP(ply, 0)
	PlayerVars:SetNeededXP(ply, GetConVar( "chsh_init_neededxp" ):GetInt() or 99)
	
	print("[CHSHOP] Initialization for ".. ply:Name() .." successful." )
	
end

function PlayerData:RestoreOld(ply)

	if(util.StringToType(util.GetPData(ply:SteamID(), "VS_OLD_DATA_TRANSFERED", false), "bool")) then print("Old data already transfered.") return end
	
	if(util.StringToType(util.GetPData(ply:SteamID(), "CB_LEVEL", -1), "int") != -1) then
		
		print("[CHSHOP] Old player data found, loading it in...")
		
		-- If you wonder why the actual hecc is the data named so differently from the actual variables, it's because my server uses an old database.
		PlayerVars:SetLevel(ply, util.StringToType(util.GetPData(ply:SteamID(), "CB_LEVEL", nil), "int"))
		--PlayerVars:SetCredits(ply, util.StringToType(util.GetPData(ply:SteamID(), "CB_CREDITS", nil), "int"))
		PlayerVars:SetXP(ply, util.StringToType(util.GetPData(ply:SteamID(), "CB_EXP", nil), "int" ))
		PlayerVars:SetNeededXP(ply, util.StringToType(util.GetPData(ply:SteamID(), "CB_NEXP", nil), "int"))
		
		print("[CHSHOP] Old data for ".. ply:Name() .." loaded successfully!" )
		
		util.SetPData(ply:SteamID(), "VS_OLD_DATA_TRANSFERED", true)
		self:Save(ply)
		ACH:UnlockAchievement(ply, 37)
	else
		print("[CHSHOP] Player data not found.")
		util.SetPData(ply:SteamID(), "VS_OLD_DATA_TRANSFERED", true)
	end
	
end

function PlayerData:SaveExtras(ply)

	util.SetPData(ply:SteamID(), "CB_PMCOUPONS", GetPMCoupons(ply))

end

function PlayerData:LoadExtras(ply)

	local coupons = util.StringToType(util.GetPData(ply:SteamID(), "CB_PMCOUPONS", 0), "Int")
	PlayerVars:SetCoupons(ply, coupons)
	
	
end
