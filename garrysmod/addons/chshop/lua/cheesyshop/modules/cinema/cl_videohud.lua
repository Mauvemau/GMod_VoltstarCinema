surface.CreateFont( "VideoHudFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 19,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


module( "theater", package.seeall )
	requester = "RequesterName"
	videoLenght = "3:00"

function VideoHud()
	
	local Theater = LocalPlayer().GetTheater and LocalPlayer():GetTheater() or nil
	

	if(Theater != nil) then
		local Video = CurrentVideo()
		if !Video then return end
		if (Video:Type() == "") then return end
	
		local videoTitle = Video:Title()
		videoTitle = string.sub(videoTitle, 1, 33)
		if ( string.len(videoTitle) == 33) then
			videoTitle = videoTitle.."..."
		end
		
		local requester = Video:GetOwnerName()
		local ownerID = Video:GetOwnerSteamID()
		local owner = nil
		
		local currentVidTime = (CurTime() - Video:StartTime())
		
		local percentBar = currentVidTime / Video:Duration()
		percentBar = percentBar * 300
		
		local strSeconds = string.FormatSeconds(math.Clamp(math.Round(currentVidTime), 0, Video:Duration()))
		
		local strDuration = string.FormatSeconds(Video:Duration())
		
		draw.RoundedBox(0, 10, ScrH() * 0.985, 300, 10, Color(100, 100, 100, 50))
		draw.RoundedBox(0, 10, ScrH() * 0.985, math.Clamp(percentBar, 0, 300) , 10, borderColor) -- Color(255, 255, 255, 80)
		if(Video.duration != 0) then
			draw.SimpleText( strDuration, "VideoHudFont", 310, ScrH() * 0.98, Color(255, 255, 255, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText( strSeconds, "VideoHudFont", 10, ScrH() * 0.96, Color(255, 255, 255, 150), 0, 0)
		else
			draw.SimpleText( "Live", "VideoHudFont", ScrW() * 0.02, ScrH() * 0.96, Color(255, 255, 255, 150), 0, 0)
			draw.RoundedBox(60, 11, ScrH() * 0.962, 15, 15, Color(255, 10, 10, 150))
		end
		
		draw.SimpleText( videoTitle, "VideoHudFont", 10, ScrH() * 0.93, Color(255, 255, 255, 150), 0, 0)
		draw.SimpleText( "Requested by ".. requester, "VideoHudFont", 310, ScrH() * 0.93, Color(255, 255, 255, 50), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)	
	
	end
end
hook.Add("HUDPaint", "VidHud", VideoHud)
