function GetAmountAchObtained(ply)
	local amount = 0
	for k, v in pairs(achievements)do
		local achivName = "VS_A".. k
		if(ply:GetNWBool(achivName))then
			amount = amount + 1
		end
	end
	return amount
end

local function BuildAchs(ply)
	if(!IsValid(PFTabsPanel))then return end
	
	local ObtainedAchs = {}
	local UnobtainedAchs = {}
	for k, v in pairs(achievements)do
		local achivName = "VS_A".. k
		if(ply:GetNWBool(achivName))then
			--table.insert(ObtainedAchs, v)
			ObtainedAchs[k] = v
		else
			--table.insert(UnobtainedAchs, v)
			UnobtainedAchs[k] = v
		end
	end -- Huge brain
	
	-- This is taken from old code, the format could be a little different.
	AchFrame = vgui.Create("DPanel", PFTabsPanel)
	AchFrame:SetSize( PFTabsPanel:GetWide() * 1, PFTabsPanel:GetTall() * 1 )
	AchFrame:SetPos( 0, 0)
	AchFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local TopBar = vgui.Create("DPanel", AchFrame)
	TopBar:SetPos(0, AchFrame:GetTall() * .01)
	TopBar:SetSize(AchFrame:GetWide() * 1, AchFrame:GetTall() * .06)
	PaintFrame(TopBar)
	
	local Scroll = vgui.Create("DScrollPanel", AchFrame)
	Scroll:SetPos(0, AchFrame:GetTall() * .075)
	Scroll:SetSize(AchFrame:GetWide() * .999, AchFrame:GetTall() * .915)
	local ypos = 0
	
	local function LoadChieves(list)
		if(!IsValid(Scroll))then return end
		Scroll:GetCanvas():Clear()
		ypos = 0
	
		for k, v in pairs(list) do
			local achivName = "VS_A".. k
			local vidChieve = nil
			
			for key, vid in pairs(achVideos)do
				if(vid.achID == k)then vidChieve = vid.link end
			end
		
			local AchivPanel = vgui.Create("DPanel", Scroll)
			AchivPanel:SetPos(AchFrame:GetWide() * .005, ypos)
			AchivPanel:SetSize(AchFrame:GetWide() * .975, AchFrame:GetTall() * .15)
			AchivPanel.Paint = function(self, w, h)
				if(ply:GetNWBool(achivName)) then
					draw.RoundedBox( 0, 0, 0, w, h, borderColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color(100, 100, 100) )
				end
				draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor ) -- 35
			end
		
			local Title = vgui.Create( "DLabel", AchivPanel )
			Title:SetPos(AchivPanel:GetWide() * .01, AchivPanel:GetTall() * .05)
			Title:SetFont("chsh_ach_title_font")
			Title:SetText(v.title)
			if(ply:GetNWBool(achivName)) then 
				Title:SetColor(borderColor)
			else
				Title:SetColor(Color(100, 100, 100))
			end
			Title:SizeToContents()
			
			if(vidChieve != nil)then
				local PlayButton = vgui.Create("DButton", AchivPanel)
				PlayButton:SetPos((AchivPanel:GetWide() * .02) + Title:GetWide(), AchivPanel:GetTall() * .16)
				PlayButton:SetSize(AchivPanel:GetWide() * .1, AchivPanel:GetTall() * .26)
				PlayButton:SetFont("chsh_ach_description_font")
				PlayButton:SetText("Play Video")
				PaintButton(PlayButton)
				if(!ply:GetNWBool(achivName)) then 
					PaintButtonSpecific(PlayButton, Color(200, 200, 200))
				end
				PlayButton:SetTooltip("You must be inside a theater")
				
				PlayButton.DoClick = function()
					local th = LocalPlayer():GetTheater()
					if(!th) then return end
					RunConsoleCommand("say", "https://youtu.be/".. vidChieve)
				end
			end
		
			local Description = vgui.Create("DLabel", AchivPanel)
			Description:SetPos(AchivPanel:GetWide() * .01, AchivPanel:GetTall() * .55)
			Description:SetColor(Color(200, 200, 200))
			Description:SetFont("chsh_ach_description_font")
			Description:SetText(v.description)
			Description:SizeToContents()
			
			local RewardsLabel = vgui.Create("DLabel", AchivPanel)
			RewardsLabel:SetPos(AchivPanel:GetWide() * .74, AchivPanel:GetTall() * .05)
			RewardsLabel:SetColor(Color(240, 180, 60, 255))
			RewardsLabel:SetFont("chsh_ach_description_font")
			RewardsLabel:SetText("Rewards:")
			RewardsLabel:SizeToContents()
			
			local myxpos = AchivPanel:GetWide() * .75
			
			local XPIco = vgui.Create("DLabel", AchivPanel)
			XPIco:SetPos(myxpos, AchivPanel:GetTall() * .25)
			XPIco:SetColor(Color(240, 180, 60, 255))
			XPIco:SetFont("chsh_ach_reward_font")
			XPIco:SetContentAlignment(6)
			XPIco:SetText("XP")
			XPIco:SizeToContents()
			
			myxpos = myxpos + (XPIco:GetWide() * 1) + 3
			
			local XP = vgui.Create("DLabel", AchivPanel)
			XP:SetPos(myxpos, AchivPanel:GetTall() * .25)
			XP:SetColor(Color(255, 255, 255, 255))
			XP:SetFont("chsh_ach_reward_font")
			XP:SetContentAlignment(6)
			XP:SetText(v.xp)
			XP:SizeToContents()
			
			myxpos = myxpos + (XP:GetWide() * 1) + 8
			
			local CreditsIco = vgui.Create("DPanel", AchivPanel)
			CreditsIco:SetPos(myxpos, (AchivPanel:GetTall() * .25) + 2)
			CreditsIco:SetSize((XP:GetTall() * 1) - 4, (XP:GetTall() * 1) - 4)
			CreditsIco.Paint = function(self, w, h)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(currencyIcoLocal)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			
			myxpos = myxpos + (CreditsIco:GetWide() * 1) + 3
			
			local Credits = vgui.Create("DLabel", AchivPanel)
			Credits:SetPos(myxpos, AchivPanel:GetTall() * .25)
			Credits:SetColor(Color(255, 255, 255, 255))
			Credits:SetFont("chsh_ach_reward_font")
			Credits:SetContentAlignment(6)
			Credits:SetText(v.credits)
			Credits:SizeToContents()
			
			if(v.coupon)then
				local ExtraLabel = vgui.Create("DLabel", AchivPanel)
				ExtraLabel:SetPos(AchivPanel:GetWide() * .74, AchivPanel:GetTall() * .55)
				ExtraLabel:SetColor(Color(240, 180, 60, 255))
				ExtraLabel:SetFont("chsh_ach_description_font")
				ExtraLabel:SetContentAlignment(6)
				ExtraLabel:SetText("Extra:")
				ExtraLabel:SizeToContents()
				
				local Extra = vgui.Create("DLabel", AchivPanel)
				Extra:SetPos((AchivPanel:GetWide() * .74) + (ExtraLabel:GetWide() * 1) + 3, AchivPanel:GetTall() * .55)
				Extra:SetColor(Color(255, 255, 255, 255))
				Extra:SetFont("chsh_ach_description_font")
				Extra:SetContentAlignment(6)
				Extra:SetText("Playermodel Coupon")
				Extra:SizeToContents()
			end
			
			ypos = ypos + AchivPanel:GetTall() * 1.05	
		end
	end
	LoadChieves(achievements)
	
	local amountUnlocked = GetAmountAchObtained(ply)
	local percent = amountUnlocked / table.Count(achievements)
	percent = percent * 100
	
	local ProgressLabel = vgui.Create("DLabel", TopBar)
	ProgressLabel:SetFont("chsh_topbar_font")
	ProgressLabel:SetText("Progress: ".. ReplaceCommaWithDot(string.Comma(amountUnlocked)) .."/".. ReplaceCommaWithDot(string.Comma(table.Count(achievements))) .." - (".. math.Round(percent) .."%)")
	ProgressLabel:SetContentAlignment(6)
	ProgressLabel:SizeToContents()
	ProgressLabel:SetTall(TopBar:GetTall() * 1)
	ProgressLabel:SetPos((TopBar:GetWide() * 1) - (ProgressLabel:GetWide() * 1.05), 0)
	ProgressLabel:SetColor(Color(255, 255, 255, 255))
	
	local Buttons = {}
	local function UnselectAllButtons()
		for k, v in pairs(Buttons)do
			ButtonToggleSelected(v, false)
		end
	end
	
	local buttonxpos = 0
	local AllButton = vgui.Create("DButton", TopBar)
	AllButton:SetPos(buttonxpos, 0)
	AllButton:SetSize(TopBar:GetWide() * .15, TopBar:GetTall() * 1)
	AllButton:SetFont("chsh_topbar_font")
	AllButton:SetText("All")
	AllButton.selected = true
	PaintButton(AllButton)
	table.insert(Buttons, AllButton)
	ButtonToggleSelected(AllButton, true)
	
	buttonxpos = buttonxpos + AllButton:GetWide()
	
	local ObtainedButton = vgui.Create("DButton", TopBar)
	ObtainedButton:SetPos(buttonxpos, 0)
	ObtainedButton:SetSize(TopBar:GetWide() * .15, TopBar:GetTall() * 1)
	ObtainedButton:SetFont("chsh_topbar_font")
	ObtainedButton:SetText("Obtained")
	ObtainedButton.selected = false
	PaintButton(ObtainedButton)
	table.insert(Buttons, ObtainedButton)
	ButtonToggleSelected(ObtainedButton, false)
	
	buttonxpos = buttonxpos + AllButton:GetWide()
	
	local UnobtainedButton = vgui.Create("DButton", TopBar)
	UnobtainedButton:SetPos(buttonxpos, 0)
	UnobtainedButton:SetSize(TopBar:GetWide() * .15, TopBar:GetTall() * 1)
	UnobtainedButton:SetFont("chsh_topbar_font")
	UnobtainedButton:SetText("Unobtained")
	UnobtainedButton.selected = false
	PaintButton(UnobtainedButton)
	table.insert(Buttons, UnobtainedButton)
	ButtonToggleSelected(UnobtainedButton, false)
	
	AllButton.DoClick = function()
		if(AllButton.selected)then return false end
		UnselectAllButtons()
		ButtonToggleSelected(AllButton, true)
		LoadChieves(achievements)
	end
	
	ObtainedButton.DoClick = function()
		if(ObtainedButton.selected)then return false end
		UnselectAllButtons()
		ButtonToggleSelected(ObtainedButton, true)
		LoadChieves(ObtainedAchs)
	end
	
	UnobtainedButton.DoClick = function()
		if(UnobtainedButton.selected)then return false end
		UnselectAllButtons()
		ButtonToggleSelected(UnobtainedButton, true)
		LoadChieves(UnobtainedAchs)
	end
	
	if(IsValid(PFHelpSign))then
		PFHelpSign:SetText("A list of all the achievements, grayed out achievements are UNOBTAINED.")
		PFHelpSign:SizeToContents()
	end
	
end

local ACHIEVEMENTS = {}

ACHIEVEMENTS.id = "Achievements"

function ACHIEVEMENTS:GetID()
	return self.id
end

function ACHIEVEMENTS:Open()
	PF:CloseAllTabs()
	BuildAchs(LocalPlayer())
end

function ACHIEVEMENTS:Close()
	if(IsValid(AchFrame))then
		AchFrame:Remove()
	end
end

local function Initialize()
	table.insert(PF.tabs, ACHIEVEMENTS)
end
hook.Add("chsh_load_profile", "load_achievements", Initialize)

-- Announces Achievemens in chat when earned.
net.Receive("chsh_announce_achievement", function()
	local red = Color( 255, 50, 50 )
	local white = Color( 255, 255, 225 )
	local yellow = Color( 255, 223, 0 )

	local ply = net.ReadEntity()
	local ach = net.ReadString()

	if(!ply:IsValid())then return end
	chat.AddText(team.GetColor(ply:Team()), ply:Name(), white, " has unlocked ", yellow, "\"".. ach .."\"")
end)