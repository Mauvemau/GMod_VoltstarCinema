
-- Defines what database service will be used to store data. Services available: "pdata", "mysql"
chsh_database_service = "mysql"

-- Economy Variables --
CreateConVar( "chsh_init_lvl", 1, FCVAR_NONE,
"Defines the level on which new players start.", 
1)
CreateConVar( "chsh_init_credits", 100, FCVAR_NONE, 
"Defines the amount of credits new players start off with.", 
0)
CreateConVar( "chsh_init_neededxp", 120, FCVAR_NONE, 
"Defines the amount of XP a new player will need to level up.", 
1)

-- Multipliers
CreateConVar( "ch_xpneeded_increase", 15, FCVAR_NONE, 
"Defines the percentage of incrementation of the needed XP after a player levels up. 0 for no incrementation.", 
0)

-- Caps
CreateConVar( "chsh_xpneeded_cap", 7000, FCVAR_NONE, 
"Defines a maximum XP needed to level up.", 
1)

-- Cinema Variables --
CreateConVar( "chsh_cinema_rewards", 1, FCVAR_NONE, 
"(CINEMA ONLY) If set to 0, no Credits or XP will be rewarded from videos. If set to 1, videos will reward Credits and XP.", 
0, 1)

-- Multipliers
CreateConVar( "chsh_general_multiplier", 1, FCVAR_NONE, 
"(CINEMA ONLY) General multiplier for XP and Credits, increased value will mean more XP and Credits from videos.", 
0.1)
CreateConVar( "chsh_xp_multiplier", 45, FCVAR_NONE, 
"(CINEMA ONLY) XP multiplier for each second of video watched. (%)", 
0.1)
CreateConVar( "chsh_credits_multiplier", 15, FCVAR_NONE, 
"(CINEMA ONLY) Credits multiplier for each second of video watched. (%)", 
0.1)
-- Caps
CreateConVar( "chsh_xp_cap", 3000, FCVAR_NONE, 
"(CINEMA ONLY) Defines the maximum amount of XP an individual video can reward.", 
1)
CreateConVar( "chsh_credits_cap", 2000, FCVAR_NONE, 
"(CINEMA ONLY) Defines the maximum amount of Credits an individual video can reward.", 
1)

-- Misc --
CreateConVar( "chsh_afk_credits", 10, FCVAR_NONE, 
"Defines an amount of Credits to reward to players every 5 minutes for just being on the server.", 
0)
CreateConVar( "chsh_afk_xp", 0, FCVAR_NONE, 
"Defines an amount of XP to reward to players every 5 minutes for just being on the server.", 
0)
CreateConVar( "chsh_kill_credits", 0, FCVAR_NONE, 
"Credits rewarded per player kill.", 
0)
CreateConVar( "chsh_kill_xp", 0, FCVAR_NONE, 
"XP rewarded per player kill.", 
0)

-- AFKVars --
CreateConVar("chsh_afk_time", 600, FCVAR_NONE,
"Defines amount of time needed before a player is set to afk.",
1800)

-- Command for refreshing the addon's scripts. (Admin Only, development purposes) --
concommand.Add("chsh_refresh_scripts", function( ply, cmd, args )
	if( ply:IsAdmin() )then
		hook.Call("ch_refresh_scripts")
	end
end)

