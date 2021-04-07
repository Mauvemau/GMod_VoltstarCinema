surface.CreateFont( "CheesyHudFont", {
	font      = "Arial",
	size      = ScrH() * .025,
	weight    = 615,
	antialias = true
})

surface.CreateFont( "CheesyHudMoneyFont", {
	font      = "Arial",
	size      = ScrH() * .023,
	weight    = 615,
	antialias = true
})

surface.CreateFont( "CheesyHudLocation", {
	font      = "Open Sans Condensed",
	size      = ScrH() * .025,
	weight    = 615,
	antialias = true
})

surface.CreateFont( "DevModeFont", {
	font      = "Arial",
	size      = ScrW() * .013,
	weight    = 600,
	antialias = false,
	outline	  = true
})

local currentMoney = 0
local lastMoney = currentMoney
local displayMoney = lastMoney

local function PrintHud()
	
	local h = ScrH()
	local w = ScrH() * 1.8
	
	currentMoney = GetCredits(LocalPlayer())
	local xpbar = ( GetXP( LocalPlayer() ) / GetNeededXP( LocalPlayer() ) ) * ( w * 0.11 ) -- Yes, i have no idea what i'm doing.
	
	if(lastMoney != currentMoney)then
		lastMoney = currentMoney
		displayMoney = ReplaceCommaWithDot(string.Comma(lastMoney))
		print("Transformed.")
	end
	
	-- Background --
	draw.RoundedBox(0, w * 0.05, h * 0.085, w * 0.11, h * 0.045, Color(75, 75, 75, 255)) -- Border
	draw.RoundedBox(0, w * 0.05, h * 0.087, w * 0.109, h * 0.043, Color(30, 30, 30, 255)) -- Box
	draw.RoundedBox(0, w * 0.05, h * 0.124, w * 0.11, h * 0.006, Color(75, 75, 75, 255)) -- XP bar background
	draw.RoundedBox(0, w * 0.05, h * 0.124, math.Clamp(xpbar, 0, w * 0.11), h * 0.006, borderColor) -- XP bar fill
	draw.RoundedBox(40, h * 0.05, h * 0.05, h * 0.08, h * 0.08, borderColor)
	draw.RoundedBox(40, h * 0.0545, h * 0.0545, h * 0.07, h * 0.07, Color(30, 30, 30, 255))
	
	-- Information --
	draw.SimpleText(GetLevel( LocalPlayer() ), "CheesyHudFont", w * 0.05, h * 0.089, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--draw.SimpleText("$", "CheesyHudFont", w * 0.078, h * 0.092, Color(255, 223, 0, 255), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(currencyIcoLocal)
	surface.DrawTexturedRect(w * 0.075, h * 0.091, h * .026, h * .026)
	draw.SimpleText(displayMoney, "CheesyHudMoneyFont", w * 0.0915, h * 0.094, Color( 255, 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT)
	
	local location = "null"
	if (LocalPlayer():GetTheater() == nil) then 
		location = LocalPlayer():GetLocationName()
	else
		location = LocalPlayer():GetTheater():Name()
	end
	
	draw.SimpleText(location, "CheesyHudLocation", w * 0.075, h * 0.06, borderColor, TEXT_ALIGN_BOTTOM, TEXT_ALIGN_LEFT)

end

-- Prints a chunk of text on the side of the screen, showing useful info for development. --
local devPos = {x = ScrW() * 0.007, y = ScrH() * 0.3}
local devColor = Color( 255, 255, 255 )
local function PrintDevInfo()
	draw.SimpleText("Level: ".. GetLevel( LocalPlayer() ),"DevModeFont", devPos.x, devPos.y, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("Credits: ".. GetCredits( LocalPlayer() ),"DevModeFont", devPos.x, devPos.y + 20, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("XP: ".. GetXP( LocalPlayer() ),"DevModeFont", devPos.x, devPos.y + 40, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("XP needed: ".. GetNeededXP( LocalPlayer() ),"DevModeFont", devPos.x, devPos.y + 60, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("Ping: ".. LocalPlayer():Ping(),"DevModeFont", devPos.x, devPos.y + 80, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)		
	draw.SimpleText("Position: (X: ".. math.Round(LocalPlayer():GetPos().x) ..", Y: ".. math.Round(LocalPlayer():GetPos().y) ..", Z:".. math.Round(LocalPlayer():GetPos().z) ..")",
	"DevModeFont", devPos.x, devPos.y + 100, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("Angles: (X: ".. math.Round(LocalPlayer():GetAngles().x) ..", Y: ".. math.Round(LocalPlayer():GetAngles().y) ..")",
	"DevModeFont", devPos.x, devPos.y + 120, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
	draw.SimpleText("FPS: ".. math.Round((1 / FrameTime())),"DevModeFont", devPos.x, devPos.y + 140, devColor, TEXT_ALIGN_TOP, TEXT_RIGHT)
end

local shouldDrawHud = 1
local devmode = 0

local function UpdateHudVariables()
	shouldDrawHud = GetConVar( "chsh_hud_draw" ):GetInt()
	devmode = GetConVar( "chsh_dev_mode" ):GetInt()
end

-- Prints Addon's hud --
local function CheesyHud()

	UpdateHudVariables()
	if(shouldDrawHud == 1) then
	
		PrintHud()
		
		if(devmode == 1) then
			PrintDevInfo()
		end
		
	end
	
end
hook.Add("HUDPaint", "print_ch_hud", CheesyHud)