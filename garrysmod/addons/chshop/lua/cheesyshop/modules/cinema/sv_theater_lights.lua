-- Code made by Phonka
local UseCooldown = 0.3
hook.Add("PlayerUse", "PrivateTheaterLightSwitch", function( ply, ent )
	if(ent:GetClass() != "func_button")then return end
	if ply.LightsLastUse and ply.LightsLastUse + UseCooldown > CurTime() then
		return false
	end
	
	if(CHIsAdmin(ply))then return true end

	local Theater = ply:GetTheater()
	if Theater and Theater:IsPrivate() and ent:GetClass() == "func_button" then

		ply.LightsLastUse = CurTime()

		if Theater:GetOwner() != ply then
			Theater:AnnounceToPlayer( ply, 'Theater_OwnerUseOnly' )
			return false
		end

	end

	return true

end)