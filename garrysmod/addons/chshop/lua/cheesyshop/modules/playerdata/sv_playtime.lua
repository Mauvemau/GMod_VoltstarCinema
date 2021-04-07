
util.AddNetworkString("chsh_update_playtime")

function UpdatePlaytime(ply)
	net.Start("chsh_update_playtime")
		net.WriteEntity(ply)
		net.WriteString(ply.PlayTime)
	net.Broadcast()
	print("[CHSH] Playtime updated for ".. ply:Name() ..".")
end

local function LoadPlaytime(ply)
	if(!IsValid(ply))then return end
	if(db_offline) then return end
	local q = [[
    SELECT *
    FROM `users`
    WHERE steamid = '%s'
    ]]
	q = string.format(q, ply:SteamID())
	
	local query = DB_CHEESY:query(q)
	
	function query:onSuccess(data)
		if( #query:getData() == 0 ) then
			print( "[SQL] There is no playtime data from ".. ply:Name() .." in the database." )
		else
			print( "[SQL] Playtime Data found! loading playtime for ".. ply:Name() .. "." )
			local row = data[1]
			
			PlayerVars:SetPlaytime(ply, tonumber(row.playtime) or 0)
			
			print( "[SQL] Playtime data for ".. ply:Name() .." loaded successfully." )
			return
		end
	end
	query.onError = function( db, err )
		print( "[SQL] (Load) - Error: ", err )
	end
	query:start()
	return
end

local function SavePlaytime(ply)
	PlayerData:Save(ply)
end

local function TransferPlaytime(ply)
	if(!IsValid(ply))then return end
	local myPlayTime = ply.PlayTime or 0
	
	if(myPlayTime > 120)then return myPlayTime end
	if(util.StringToType(util.GetPData(ply:SteamID(), "VS_PlaytimeTransfered", false), "Bool" )) then print("[CHSH] Player playtime already transfered.") return myPlayTime end
	
	local data = file.Read( "player_old_data.txt", "DATA" )
	if not data then return end
	
	data = string.Split( data, "\n" )
	for _, line in ipairs( data ) do
		local args = string.Split( line, ";" )
		if ( #args < 3 ) then continue end
		local id = args[1]
		if not id then return end
		
		if(id == ply:SteamID())then
			myPlayTime = args[4]
		end
	end
	
	util.SetPData(ply:SteamID(), "VS_PlaytimeTransfered", true)
	return math.Round(tonumber(myPlayTime))
end

function InitPlaytime(ply)
	LoadPlaytime(ply)
	timer.Simple(5, function()
		LoadPlaytime(ply)
	end)
	timer.Simple(10, function()
		ply.PlayTime = TransferPlaytime(ply)
		SavePlaytime(ply)
		UpdatePlaytime(ply)
	end)
	timer.Simple(25, function()
		ply.PlayTimeInit = true
	end)
end

local delay = 300
local function PlayTimeThink()
	local players = player.GetAll()
	for k, ply in pairs(players)do
		if(IsValid(ply) && ply:IsPlayer()) then
			if(ply:IsConnected() and ply:IsFullyAuthenticated())then
				if(ply.PlayTime != nil && ply.PlayTimeInit)then
					ply.PlayTime = ply.PlayTime + delay
					SavePlaytime(ply)
					UpdatePlaytime(ply)
					CheckPlaytimeAchievement(ply)
				else
					print("[Playtime] ".. ply:Name() .. " not initialized.")
				end
			else
				print("[Playtime] Player not yet authenticated.")
			end
		else
			print("[Playtime] Invalid player.")
		end
	end
end
timer.Create("chsh_playtime_counter", delay, 0, function()
	PlayTimeThink()
end)

