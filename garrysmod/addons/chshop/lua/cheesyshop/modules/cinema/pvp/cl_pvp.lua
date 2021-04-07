
function GetColor(id)

	if( id == "1" ) then
		return Color(128, 128, 255)
	elseif ( id == "2" ) then
		return Color(255, 128, 0)
	else
		return Color(255, 0, 0) 
	end

end


net.Receive("PVPAnnounce", function( len )
	local text = net.ReadString()
	local id = net.ReadString()
	chat.AddText( GetColor(id) ,"[ARENA] ".. text)
end)


