local effects={
	popcorn = "popcorn",
	rain = "rain",
	watersplash = "watersplash",
	manhacksparks = "manhacksparks",
    cball_explode= "cball_explode",
    shelleject = "shelleject",
    shotgunshelleject = "shotgunshelleject",
	heart = "heart",
	snow = "snow",
	missingtexture = "missingtexture",
	rose = "rose",
	kanna = "kanna",
	yoda = "yoda",
	yodag = "yodag",
	naptime = "naptime",
	kizuna = "kizuna",
	virus = "virus",
	cheesybologna = "cheesybologna"
}
local noisy={
	watersplash = "watersplash"
}


-- Question, why not making a list of the effects that *can* be used instead, since there's just 2, am i right? (Mau)

concommand.Add("effect",function(ply, cmd, args) -- I added some spaces between things to make it easier on the eyes when it comes to reading. (Mau)

	if !IsValid(ply) then return end -- Validations should go before anything. (Mau)

	if ply:GetNWFloat("PreciousTime") > CurTime() then return end
	
	popcorn = args[1]
	
		local sfx = EffectData()
		sfx:SetOrigin( ply:GetShootPos() )
		sfx:SetAngles( ply:EyeAngles() )
		
		if noisy[popcorn] and ply:InTheater() and !ply:IsAdmin() then
			popcorn = "popcorn"
			ply:PrintMessage(HUD_PRINTTALK, "You not allowed to use this effect inside of a theater.")
		end
		
		if !ply:IsAdmin() then
			if !table.HasValue(effects, popcorn)  then 
				ply:PrintMessage(HUD_PRINTTALK, "This effect is not in the list.") 
				return end
			ply.proj = util.Effect( effects[popcorn] , sfx )
		else
			ply.proj = util.Effect( popcorn , sfx )
		end
		
		
		if IsValid(ply.proj) then
			ply.proj:SetOwner(ply)
			ply.proj:Spawn()

		end
	
	
	--Set the user groups, I organized the times has it looked the best to trow popcorn, no need to add developer here cuz it will be set to instant trow.
	if ( !ply:IsAdmin() ) then --toothpaste users (members)
		ply:SetNWFloat("PreciousTime", CurTime() + 2.5)
	else -- If they are admins. (Mau)
		ply:SetNWFloat("PreciousTime", CurTime() + 0.5)
	end
 end)
 --created by Coco
 --Mau helped simplify everything