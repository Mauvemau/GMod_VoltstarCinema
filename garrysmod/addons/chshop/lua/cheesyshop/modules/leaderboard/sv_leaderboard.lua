util.AddNetworkString( "chsh_refresh_leaderboards" )

local currentLevel = "Loading..."
local currentPlaytime = "Loading..."

local function SendCurrent(ply)
	net.Start("chsh_refresh_leaderboards")
		net.WriteString(currentLevel)
		net.WriteString(currentPlaytime)
	net.Send(ply)
end

local function UpdateLeaderboards(level, playtime)
	net.Start("chsh_refresh_leaderboards")
		net.WriteString(level)
		net.WriteString(playtime)
	net.Broadcast()
end

local function LoadLeaderboard()

	local bestLevel = {}
	local bestPlaytime = {}
	local stringLevel = ""
	local stringPlaytime = ""

	if(db_offline) then return end
	local q = [[
	SELECT plname, lvl
	FROM users
	ORDER BY lvl DESC
	LIMIT 10;
    ]]
	
	local query = DB_CHEESY:query(q)
	
	function query:onSuccess(data)
		if( #query:getData() == 0 ) then
			print( "[SQL] There was an error loading the leaderboard." )
		else
			print( "[SQL] Loading leaderboards..." )
			
			for k, v in pairs(data)do
				bestLevel[k] = v
			end
			
			print( "[SQL] Leaderboards loaded successfully." )
		end
	end
	query.onError = function( db, err )
		print( "[SQL] (Load) - Error: ", err )
	end
	query:start()
	
	local q2 = [[
	SELECT plname, playtime
	FROM users
	ORDER BY playtime DESC
	LIMIT 10;
    ]]
	
	local query2 = DB_CHEESY:query(q2)
	
	function query2:onSuccess(data)
		if( #query2:getData() == 0 ) then
			print( "[SQL] There was an error loading the leaderboard." )
		else
			print( "[SQL] Loading leaderboards..." )
			
			for k, v in pairs(data)do
				bestPlaytime[k] = v
			end
			
			print( "[SQL] Leaderboards loaded successfully." )
		end
	end
	query2.onError = function( db, err )
		print( "[SQL] (Load) - Error: ", err )
	end
	query2:start()
	
	timer.Simple(5, function()
		for k, v in pairs(bestLevel)do
			stringLevel = stringLevel .. k ..". ".. v.plname .." - Lvl ".. v.lvl .."\n"
		end
		for k, v in pairs(bestPlaytime)do
			stringPlaytime = stringPlaytime .. k ..". ".. v.plname .." - ".. TransformTime(v.playtime) .."\n"
		end
		currentLevel = stringLevel
		currentPlaytime = stringPlaytime
		UpdateLeaderboards(stringLevel, stringPlaytime)
	end)
	
end
hook.Add( "Initialize", "some_unique_name", function()
	timer.Simple(30, function()
		LoadLeaderboard()
		timer.Create("chsh_leaderboard_update", 600, 0, function()
			LoadLeaderboard()
		end)
	end)
end)
hook.Add("PlayerInitialSpawn", "send_current_leaderboard", function(ply)
	timer.Simple(30, function()
		SendCurrent(ply)
	end)
end)