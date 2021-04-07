util.AddNetworkString( "SetLbyMusic" )

net.Receive( "SetLbyMusic", function( len, ply )

	set = net.ReadBool()
	ply:SetNWBool("ListeningRadio", set)
	
	--[[
	if(set) then
		ply:ChatPrint( "Credits from the radio ON" )
	else
		ply:ChatPrint( "Credits from the radio OFF" )
	end
	]]
end)

timer.Create( "RewardMusic", 60, 0, function()
	for _, ply in ipairs( player.GetAll() ) do
		--ply:ChatPrint("Trying to reward.")
		if( ply:GetNWBool("ListeningRadio") && !ply:InTheater() ) then
			--ply:PrintMessage( HUD_PRINTNOTIFY, "Rewarded 15 XP and 5 Credits from listening music.")
			--REWARDS:AddExperience(ply, 15)
			--REWARDS:AddCredits(ply, 5)
		end
		
	end
end )