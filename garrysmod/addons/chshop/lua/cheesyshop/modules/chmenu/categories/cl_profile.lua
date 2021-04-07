
local defaultTab = 1
local lastTab = defaultTab

local function BuildProfile()
	if(!IsValid(CHMenuFrame))then return end
	
	ProfilePanel = vgui.Create("DPanel", CHMenuFrame)
	ProfilePanel:SetSize( CHMenuFrame:GetWide() * 1, CHMenuFrame:GetTall() * 0.88 )
	ProfilePanel:SetPos( 0, CHMenuFrame:GetTall() * .1185 )
	ProfilePanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	if(IsValid(BottomBarPanel))then
		BottomBarPanel:MoveToFront()
	end

	local PlayerViewBox = vgui.Create("DPanel", ProfilePanel)
	PlayerViewBox:SetSize( ProfilePanel:GetWide() * .3, ProfilePanel:GetTall() * .85 )
	PlayerViewBox:SetPos( ProfilePanel:GetWide() * .02, ProfilePanel:GetTall() * .035 )
	PaintFrame(PlayerViewBox)
	
	PlayermodelView = vgui.Create("DModelPanel", PlayerViewBox)
	PlayermodelView:SetSize(PlayerViewBox:GetWide() * 1, PlayerViewBox:GetTall() * 1)
	ApplyBodygroupsPlayerview()
	if(!lastAngle)then lastAngle = Angle( 0, 0, 0 ) end
	PlayermodelView.Angles = lastAngle
	
	local mn, mx = PlayermodelView.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
	
	PlayermodelView:SetFOV(25)
	PlayermodelView:SetCamPos(Vector(size, size, size))
	PlayermodelView:SetLookAt((mn + mx) * 0.5)
	
	function PlayermodelView:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function PlayermodelView:DragMouseRelease() self.Pressed = false end

	function PlayermodelView:LayoutEntity( ent )
		if ( self.bAnimated ) then self:RunAnimation() end

		if ( self.Pressed ) then
			local mx = gui.MousePos()
			self.Angles = self.Angles - Angle( 0, ( ( self.PressX or mx ) - mx ) / 2, 0 )

			self.PressX, self.PressY = gui.MousePos()
		end

		ent:SetAngles( self.Angles )
		lastAngle = self.Angles
	end
	
	if(skSelected)then PlayermodelView.Entity:SetSkin(skSelected) end
	for k = 0, PlayermodelView.Entity:GetNumBodyGroups() - 1 do
		if(bgSelected[k])then PlayermodelView.Entity:SetBodygroup(k, bgSelected[k]) end
	end
	
	-- Level Bar
	local LevelPanel = vgui.Create("DPanel", ProfilePanel)
	LevelPanel:SetSize(PlayerViewBox:GetWide() * 1, ProfilePanel:GetTall() * 0.06)
	LevelPanel:SetPos(ProfilePanel:GetWide() * .02, ProfilePanel:GetTall() * .86)
	LevelPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, grayColor) -- Border
		draw.RoundedBox(0, 2, 2, w - 4, h -4, backgroundColor) -- Background
		
		offset = w * .14
		draw.RoundedBox(0, offset, h * .85, w - offset, h * .2, grayColor) -- XPBar Empty
		local xpbar = (GetXP(LocalPlayer()) / GetNeededXP(LocalPlayer())) * (w - offset)
		draw.RoundedBox(0, offset, h * .85, math.Clamp(xpbar, 0, w - offset), h * .2, borderColor) -- XPBar fill
	end
	
	local LevelCirclePanel = vgui.Create("DPanel", ProfilePanel)
	LevelCirclePanel:SetSize(LevelPanel:GetTall() * 2, LevelPanel:GetTall() * 2)
	LevelCirclePanel:SetPos(ProfilePanel:GetWide() * .006, ProfilePanel:GetTall() * .82)
	LevelCirclePanel.Paint = function(self, w, h)
		draw.RoundedBox(50, 0, 0, w, h, borderColor)
		draw.RoundedBox(50, 0 + 6, 0 + 6, w - 12, h - 12, backgroundColor)
	end
	
	local LevelMarker = vgui.Create("DLabel", LevelCirclePanel)
	LevelMarker:SetSize(LevelCirclePanel:GetWide() * 1, LevelCirclePanel:GetTall() * 1)
	LevelMarker:SetPos(0, 0)
	LevelMarker:SetContentAlignment(5)
	LevelMarker:SetFont("chsh_pf_level_font")
	LevelMarker:SetText(GetLevel(LocalPlayer()))
	LevelMarker:SetColor(Color(255, 255, 255, 255))
	
	local LevelIndicator = vgui.Create("DLabel", LevelCirclePanel)
	LevelIndicator:SetSize(LevelCirclePanel:GetWide() * 1, (LevelCirclePanel:GetTall() * 1) - (LevelCirclePanel:GetTall() * .13))
	LevelIndicator:SetPos(0, LevelCirclePanel:GetTall() * .13)
	LevelIndicator:SetContentAlignment(8)
	LevelIndicator:SetFont("chsh_pf_levelind_font")
	LevelIndicator:SetText("Level")
	LevelIndicator:SetColor(Color(255, 255, 255, 255))
	
	local offset = 0
	local percent = GetXP(LocalPlayer())/GetNeededXP(LocalPlayer())
	percent = percent * 100
	local XPMarker = vgui.Create("DLabel", LevelPanel)
	XPMarker:SetSize((LevelPanel:GetWide() * 1) - offset, LevelPanel:GetTall() * .9)
	XPMarker:SetPos(offset, 0)
	XPMarker:SetContentAlignment(5)
	XPMarker:SetFont("chsh_pf_xp_font")
	XPMarker:SetText(math.Round(percent) .."%")
	XPMarker:SetColor(Color(255, 255, 255, 255))
	
	local ChangePanel = vgui.Create("DPanel", LevelPanel)
	ChangePanel:SetSize(LevelPanel:GetWide() * 1, LevelPanel:GetTall() * 1)
	ChangePanel:SetPos(0, 0)
	ChangePanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	ChangePanel.OnCursorEntered = function()
		XPMarker:SetText(GetXP(LocalPlayer()) .." / ".. GetNeededXP(LocalPlayer()) .." xp")
	end
	ChangePanel.OnCursorExited = function()
		local percent = GetXP(LocalPlayer())/GetNeededXP(LocalPlayer())
		percent = percent * 100
		XPMarker:SetText(math.Round(percent) .."%")
	end
	--
	
	local TabsPanelBox = vgui.Create("DPanel", ProfilePanel)
	TabsPanelBox:SetSize(ProfilePanel:GetWide() * .65, ProfilePanel:GetTall() * 0.85)
	TabsPanelBox:SetPos(ProfilePanel:GetWide() * .335, ProfilePanel:GetTall() * .035)
	TabsPanelBox.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local TabsButtoner = vgui.Create("DPanel", TabsPanelBox)
	TabsButtoner:SetPos( 0, 0)
	TabsButtoner:SetSize( TabsPanelBox:GetWide() * 1, TabsPanelBox:GetTall() * .1 )
	TabsButtoner.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	TabsButtoner.buttons = {}
	
	function TabsButtoner:UnselectAllButtons()
		for i = 1, table.Count(self.buttons) do
			ButtonToggleSelected(self.buttons[i], false)
		end
	end
	function TabsButtoner:SelectButton(index)
		ButtonToggleSelected(self.buttons[index], true)
	end
	
	if(table.Count(PF.tabs) < 1) then return end
	
	local xpos = 0
	for i = 1, table.Count(PF.tabs) do
	
		local Button = vgui.Create("DButton", TabsButtoner)
		Button:SetText(PF.tabs[i]:GetID())
		Button:SetFont("chsh_tabs_buttons_font")
		Button:SetSize( TabsButtoner:GetWide() * .18, TabsButtoner:GetTall() * 1 )
		Button:SetPos(xpos, 0)
		xpos = xpos + Button:GetWide() * 1
		PaintButton(Button)
		
		Button.DoClick = function()
			TabsButtoner:UnselectAllButtons()
			PF.tabs[i]:Open()
			TabsButtoner:SelectButton(i)
			lastTab = i
		end
		
		table.insert(TabsButtoner.buttons, Button)
	end
	
	local InfoIco = vgui.Create("DSprite", ProfilePanel)
	InfoIco:SetMaterial(Material("icon16/information.png"))
	InfoIco:SetPos( ProfilePanel:GetWide() * .35, ProfilePanel:GetTall() * .91 )
	InfoIco:SetSize( ProfilePanel:GetTall() * .03, ProfilePanel:GetTall() * .03 )
	
	PFHelpSign = vgui.Create("DLabel", ProfilePanel)
	PFHelpSign:SetPos( ProfilePanel:GetWide() * .362, ProfilePanel:GetTall() * .89 )
	PFHelpSign:SetFont("chsh_tips_font")
	PFHelpSign:SetText("")
	
	PFTabsPanel = vgui.Create("DPanel", TabsPanelBox)
	PFTabsPanel:SetPos( 0, TabsPanelBox:GetTall() * .1)
	PFTabsPanel:SetSize( TabsPanelBox:GetWide() * 1, TabsPanelBox:GetTall() * .9 )
	PaintFrame(PFTabsPanel)
	
	TabsButtoner:UnselectAllButtons()
	PF.tabs[lastTab]:Open()
	TabsButtoner:SelectButton(lastTab)
	
end

local PROFILE = {}

PROFILE.id = "Profile"

PF = {}
PF.tabs = {}

function PF:CloseAllTabs()
	for i = 1, table.Count(self.tabs) do
		self.tabs[i]:Close()
	end
end

function PROFILE:GetID()
	return self.id
end

function PROFILE:Open()
	CHMenu:CloseAllTabs()
	BuildProfile()
end

function PROFILE:Close()
	if(IsValid(ProfilePanel))then
		ProfilePanel:Remove()
	end
end

function PROFILE:Update()
	for k, v in pairs(PF.tabs)do
		if(v.Update)then
			v:Update()
		end
	end
end

function PROFILE:LoadTabs()
	table.Empty(PF.tabs)
	hook.Call("chsh_load_profile")
end

local function Initialize()
	table.insert(CHMenu.categories, 1, PROFILE) -- Add a 1 if you want this category to be the one that opens first when you open the menu.
	PROFILE:LoadTabs()
end
hook.Add("chsh_load_categories", "load_profile", Initialize)