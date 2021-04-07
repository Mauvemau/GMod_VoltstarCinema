
MYSQL = {}

DATABASE_HOST 		= "your_database_hostname"
DATABASE_PORT 		= 3306
DATABASE_NAME 		= "your_database_name"
DATABASE_USERNAME	= "your_database_username"
DATABASE_PASSWORD	= "your_database_password"

local MySQLOO = require( "mysqloo" )
db_offline = true

DB_CHEESY = mysqloo.connect( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT )

function CreatePlayerDataTable()


end

function ConnectToDatabase()
	print( "[SQL] Connecting to Database." )
	DB_CHEESY.onConnected = function()
		print( "[SQL] Database connection successful!" )
		if(db_offline) then
			local players = player.GetAll()
			for k, v in pairs(players) do
				PlayerData:Load(v)
			end
			db_offline = false
		end
	end
	DB_CHEESY.onConnectionFailed = function( db, msg )
		print( "[SQL] Connection to database failed." )
		print( msg )
		db_offline = true
	end
	DB_CHEESY:connect()
end
ConnectToDatabase()

local function CheckDB()
	if( DB_CHEESY:status() != mysqloo.DATABASE_CONNECTED ) then
		ConnectToDatabase()
		print( "[SQL] Database connection restarted." )
	end
end
timer.Create( "DB_CHECK", 5, 0, CheckDB )

local function CheckDataIntegrity(plydata) -- Checks none of the variables in the data is invalid.

	if(plydata == nil)then print("Player data invalid. Not saving.") return false end
	if(plydata.steamid == nil)then print("SteamID data invalid. Not saving.") return false end
	if(plydata.lvl == nil)then print("Level data invalid. Not saving.") return false end
	if(plydata.credits == nil)then print("Credits data invalid. Not saving.") return false end
	if(plydata.xp == nil)then print("XP data invalid. Not saving.") return false end
	if(plydata.neededxp == nil)then print("NeededXP data invalid. Not saving.") return false end
	if(plydata.playtime == nil)then print("Playtime data invalid. Not saving.") return false end
	if(plydata.name == nil)then print("Player Name data invalid. Not saving.") return false end
	
	return true
end

function MYSQL:InitPlayer(plydata)
	print("[SQL] Initializing new player..." )
	
	local q = [[
	INSERT INTO `users` (steamid, lvl, credits, xp, neededxp, playtime, plname)
	VALUES ( '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
	ON DUPLICATE KEY UPDATE 
		steamid = VALUES(steamid),
		lvl = VALUES(lvl),
		credits = VALUES(credits),
		xp = VALUES(xp),
		neededxp = VALUES(neededxp),
		playtime = VALUES(playtime),
		plname = VALUES(plname)
	]]
	q = string.format(q, plydata.steamid, plydata.lvl or 1, plydata.credits or 0, plydata.xp or 0, plydata.neededxp or 120, plydata.playtime or 0, plydata.name or 'nil')

	local query = DB_CHEESY:query(q)
	query.onSuccess = function()
		print( "[SQL] The new player ".. plydata.name .." was initialized!" )
	end
	query.onError = function( db, err )
		print( "[SQL] (Add Player) - Error: ", err )
	end
	query:start()
	
end

function MYSQL:Save(plydata)
	if(db_offline) then return end
	if(!CheckDataIntegrity(plydata)) then return end -- Making sure all the data is valid before proceeding.
	
	local q = [[
    SELECT *
    FROM `users`
    WHERE steamid = '%s'
    ]]
	q = string.format( q, plydata.steamid )
	
	search = DB_CHEESY:query( q )

	search.onSuccess = function()
		if( #search:getData() == 0 ) then -- If data doesn't exist initialize it.
			print("[SQL] No data for ".. plydata.name .." found.")
			self:InitPlayer(plydata)
		else -- Update data.
			print("[SQL] Updating data for ".. plydata.name ..".")
			
			local q = [[
			INSERT INTO `users` (steamid, lvl, credits, xp, neededxp, playtime, plname)
			VALUES ( '%s', '%s', '%s', '%s', '%s', '%s', '%s' )
			ON DUPLICATE KEY UPDATE
				lvl = VALUES(lvl),
				credits = VALUES(credits),
				xp = VALUES(xp),
				neededxp = VALUES(neededxp),
				playtime = VALUES(playtime),
				plname = VALUES(plname)
			]]
			q = string.format(q, plydata.steamid, plydata.lvl, plydata.credits, plydata.xp, plydata.neededxp, plydata.playtime, plydata.name or 'nil')
			
			local query = DB_CHEESY:query(q)
			query.onSuccess = function()
				print( "[SQL] Data for ".. plydata.name .." was updated!" )
			end
			query.onError = function( db, err )
				print( "[SQL] (Save) - Error: ", err )
			end
			query:start()

		end
	end
	search:start()
	
end

function MYSQL:Load(ply)
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
			print( "[SQL] There is no data from ".. ply:Name() .." in the database." )
		else
			print( "[SQL] Data found! Loading data for ".. ply:Name() .. "." )
			local row = data[1]
			
			PlayerVars:SetLevel(ply, row.lvl or 1)
			PlayerVars:SetCredits(ply, row.credits or 0)
			PlayerVars:SetXP(ply, row.xp or 0)
			PlayerVars:SetNeededXP(ply, row.neededxp or 120)
			
			print( "[SQL] Data for ".. ply:Name() .." loaded successfully." )
			return true
		end
	end
	query.onError = function( db, err )
		print( "[SQL] (Load) - Error: ", err )
	end
	query:start()
	return false
end

function MYSQL:Delete(ply)
	
end

