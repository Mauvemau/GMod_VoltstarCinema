util.AddNetworkString("chsh_announce_command")

local acts = {
	agree = "agree",
	bow = "bow",
	beckon = "becon",
	cheer = "cheer",
	dance = "dance",
	disagree = "disagree",
	forward = "forward",
	group = "group",
	halt = "halt",
	flail = "zombie",
	laugh = "laugh",
	muscle = "muscle",
	point = "point",
	robot = "robot",
	salute = "salute",
	sexy = "muscle",
	wave = "wave",
	zombie = "zombie"
}

local message = {
	meditate = "meditates",
	sit = "sits",
	lay = "lays down",
	thumbsup = "gives two thumbs up",
	cower = "cowers",
	showoff = "shows off",
	crossarms = "crosses arms",
	sitback = "sits back",
	kneel = "kneels"
}

local function AnnounceCommand(ply, str)
	net.Start("chsh_announce_command")
		net.WriteEntity(ply)
		net.WriteString(str)
	net.Broadcast()
end

local function CustomActCommands(ply, command)
	
	if Actions[command] then
		if (ply.ActionExitTime and RealTime() - ply.ActionExitTime < 3) or ply:GetNWBool("ActionsToogle") or ply:IsPlayingTaunt() or ply:InVehicle() then
			return ""
		end

		ply:SetNWString("ActionCMD", command)
		ply:SetNWBool("ActionsToogle", true)
	
		-- Announce
		AnnounceCommand(ply, message[command])
		
	end

end

local function ActCommands(ply, command)
	if(acts[command])then
		ply:SendLua("RunConsoleCommand('act', '" .. acts[command] .. "')")

		-- Announce
		AnnounceCommand(ply, acts[command].."s")
		
	end
end

local function AdminCommands(ply, command)
	if(!CHIsAdmin(ply))then return end
	
	if (command == "cleanup") then
		ply:SendLua("RunConsoleCommand('gmod_admin_cleanup')")
		PrintMessage( HUD_PRINTTALK, "Cleaning up the map..." )
	end
	
	if (command == "spawnup") then
		--SPAWNENTS:SpawnEntities()
		PrintMessage( HUD_PRINTTALK, "Default entities spawned." )
	end
end

local function RegularCommands(ply, command)
	if(command == "thirdperson") then
		ply:SendLua("RunConsoleCommand('simple_thirdperson_enable_toggle')")
	end
	if(command == "fs") then
		ply:SendLua("RunConsoleCommand('cinema_fullscreen')")
	end
	if(command == "tc") then
		ply:SendLua("RunConsoleCommand('cinema_toggle_controls')")
	end
	if(command == "kill") then
		ply:SendLua("RunConsoleCommand('kill')")
	end
	if(command == "rf") then
		ply:SendLua("RunConsoleCommand('chsh_reload_shop')")
	end
	if(command == "afk") then
		ply:SendLua("RunConsoleCommand('chsh_set_afk')")
	end
end

hook.Add( "PlayerSay", "voltstar_commands", function(ply, chat)

	if ( string.StartWith(chat, '!')) or (string.StartWith(chat, '/'))then
	
		local command = ""
		if(string.sub(chat, 1, 1) == '!')then
			command = string.match(chat, "!(.*)")
		else
			command = string.match(chat, "/(.*)")
		end
		command = string.lower(command)
		
		RegularCommands(ply, command)
		AdminCommands(ply, command)
		ActCommands(ply, command)
		CustomActCommands(ply, command)
	
		return ""
	end
	
end)