local defaultVolume = 5

local function SetVolume(volume)
	local vol = 0
	if(LocalPlayer().myStation == nil) then return end
	if(volume < 0) then
		vol = 0
	elseif(volume > 100) then
		vol = 1
	else
		vol = volume * .01
	end
	LocalPlayer().myStation:SetVolume(vol)
end

local function StopPlaying()
	if(LocalPlayer().myStation == nil) then return end
	LocalPlayer().myStation:Stop()
	LocalPlayer().myStation = nil
end
concommand.Add( "music_stfu", function()
	StopPlaying()
end)

local function PlayURL(url)
	if(LocalPlayer().myStation != nil) then StopPlaying() end
	sound.PlayURL(url, "noblock noplay", function( station )
		if ( IsValid( station ) ) then
			station:Play()
			LocalPlayer().myStation = station
			SetVolume(defaultVolume)
		else
			LocalPlayer():ChatPrint( "Invalid URL!" )
		end
	end)
end

local function StartPlayingDefault()
	local url = "https://plaza.one/plaza.pls"
	volume = 5
	PlayURL(url)
end
hook.Add( "InitPostEntity", "play_music", function()
	timer.Simple(2, function()
		--StartPlayingDefault()
	end)
end)

-- Visualizer
local shouldDrawHud = 1
local AMP = 600
local smoothData = {}
for i = 1, 256 do
	smoothData[i] = 0
end

local function UpdateHudVariables()
	shouldDrawHud = GetConVar( "chsh_hud_draw" ):GetInt()
end

hook.Add("HUDPaint", "MusicVisualizer", function()
	
	UpdateHudVariables()
	if(shouldDrawHud != 1) then return end
	if(LocalPlayer().myStation == nil) then return end
	if(LocalPlayer():InTheater()) then return end
	if(LocalPlayer().myStation:GetState() != 1) then return end
	
	local data = {}
	LocalPlayer().myStation:FFT(data, FFT_512)
	
	if(!data) then return end
	
	for i = math.Round(ScrW() * .012), ScrW() * 0.04 do
		smoothData[i] = Lerp(10 * FrameTime(), smoothData[i], data[i])
		draw.RoundedBox(1, i * 4, ScrH() * .129, 3, math.Clamp(smoothData[i] * AMP, 0, 100), borderColor)
	end
end)

hook.Add("Think", "MusicPlayer", function()
	if(LocalPlayer().myStation == nil) then return end
	if(LocalPlayer():InTheater()) then return end

	if(LocalPlayer().myStation:GetState() != 1) then
		StartPlayingDefault()
	end
end)