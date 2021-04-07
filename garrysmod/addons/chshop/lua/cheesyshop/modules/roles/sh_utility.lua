
function CHIsAdmin(ply)
	
	local group = ply:GetNWString("UserGroup", "user")
	
	if(group == "developer")then
		return true
	elseif(group == "co-owner")then
		return true
	elseif(group == "owner")then
		return true
	else
		return false
	end
	
	return false -- Just in case
end