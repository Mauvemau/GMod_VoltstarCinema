
local defaultTab = 1
local lastTab = defaultTab

lastAngle = Angle( 0, 0, 0 )
pmSelected = nil
skSelected = 0
bgSelected = {}

function ApplyBodygroupsPlayerview()
	if(!IsValid(PlayermodelView))then return end
	
	PlayermodelView:SetModel(LocalPlayer():GetModel())
	if(pmSelected)then PlayermodelView:SetModel(pmSelected) end
	PlayermodelView.Entity:SetSkin(skSelected)
	local groups = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
	for k = 0, PlayermodelView.Entity:GetNumBodyGroups() - 1 do
		if ( PlayermodelView.Entity:GetBodygroupCount( k ) <= 1 ) then continue end
		PlayermodelView.Entity:SetBodygroup( k, groups[ k + 1 ] or 0 )
	end
	PlayermodelView.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
end

function ApplyChanges()
	if(pmSelected == nil)then return end
	if(skSelected == nil)then return end
	if(bgSelected == nil)then return end
	-- Apply Model
	if(pmSelected != LocalPlayer():GetModel()) then
		net.Start("chsh_change_playermodel")
			net.WriteString(pmSelected)
		net.SendToServer()
	end
	-- Apply Skins
	if(skSelected != LocalPlayer():GetSkin()) then
		net.Start("chsh_change_skins")
			net.WriteFloat(skSelected)
		net.SendToServer()
	end
	-- Apply BodyGroups
	if(table.Count(bgSelected) > 0) then
		net.Start("chsh_change_bgroups")
			tbl = util.TableToJSON(bgSelected)
			net.WriteString(tbl)
		net.SendToServer()
	end
end

local function BuildWardrobe()
	if(!IsValid(CHMenuFrame))then return end
	
	if(pmSelected == nil)then pmSelected = LocalPlayer():GetModel() end
	if(skSelected == nil)then skSelected = LocalPlayer():GetSkin() end

	WardrobePanel = vgui.Create("DPanel", CHMenuFrame)
	WardrobePanel:SetSize( CHMenuFrame:GetWide() * 1, CHMenuFrame:GetTall() * 0.88 )
	WardrobePanel:SetPos( 0, CHMenuFrame:GetTall() * .1185 )
	WardrobePanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	if(IsValid(BottomBarPanel))then
		BottomBarPanel:MoveToFront()
	end
	
	local PlayerViewBox = vgui.Create("DPanel", WardrobePanel)
	PlayerViewBox:SetSize( WardrobePanel:GetWide() * .3, WardrobePanel:GetTall() * .85 )
	PlayerViewBox:SetPos( WardrobePanel:GetWide() * .02, WardrobePanel:GetTall() * .035 )
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
	
	local TabsPanelBox = vgui.Create("DPanel", WardrobePanel)
	TabsPanelBox:SetSize( WardrobePanel:GetWide() * .65, WardrobePanel:GetTall() * 0.85 )
	TabsPanelBox:SetPos( WardrobePanel:GetWide() * .335, WardrobePanel:GetTall() * .035 )
	TabsPanelBox.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
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
	
	if(table.Count(WD.tabs) < 1) then return end
	
	local xpos = 0
	for i = 1, table.Count(WD.tabs) do
	
		local Button = vgui.Create("DButton", TabsButtoner)
		Button:SetText(WD.tabs[i]:GetID())
		Button:SetFont("chsh_tabs_buttons_font")
		Button:SetSize( TabsButtoner:GetWide() * .18, TabsButtoner:GetTall() * 1 )
		Button:SetPos(xpos, 0)
		xpos = xpos + Button:GetWide() * 1
		PaintButton(Button)
		
		Button.DoClick = function()
			TabsButtoner:UnselectAllButtons()
			WD.tabs[i]:Open()
			TabsButtoner:SelectButton(i)
			lastTab = i
		end
		
		table.insert(TabsButtoner.buttons, Button)
	end
	
	local InfoIco = vgui.Create("DSprite", WardrobePanel)
	InfoIco:SetMaterial(Material("icon16/information.png"))
	InfoIco:SetPos( WardrobePanel:GetWide() * .35, WardrobePanel:GetTall() * .91 )
	InfoIco:SetSize( WardrobePanel:GetTall() * .03, WardrobePanel:GetTall() * .03 )
	
	WDHelpSign = vgui.Create("DLabel", WardrobePanel)
	WDHelpSign:SetPos( WardrobePanel:GetWide() * .362, WardrobePanel:GetTall() * .89 )
	WDHelpSign:SetFont("chsh_tips_font")
	WDHelpSign:SetText("")
	
	WDTabsPanel = vgui.Create("DPanel", TabsPanelBox)
	WDTabsPanel:SetPos( 0, TabsPanelBox:GetTall() * .1)
	WDTabsPanel:SetSize( TabsPanelBox:GetWide() * 1, TabsPanelBox:GetTall() * .9 )
	PaintFrame(WDTabsPanel)
	
	TabsButtoner:UnselectAllButtons()
	WD.tabs[lastTab]:Open()
	TabsButtoner:SelectButton(lastTab)
end

local WARDROBE = {}

WARDROBE.id = "Wardrobe"

WD = {}
WD.tabs = {}

function WD:CloseAllTabs()
	for i = 1, table.Count(self.tabs) do
		self.tabs[i]:Close()
	end
end

function WARDROBE:GetID()
	return self.id
end

function WARDROBE:Open()
	CHMenu:CloseAllTabs()
	BuildWardrobe()
end

function WARDROBE:Close()
	if(IsValid(WardrobePanel))then
		WardrobePanel:Remove()
	end
end

function WARDROBE:LoadTabs()
	table.Empty(WD.tabs)
	hook.Call("chsh_load_wardrobe")
end

local function Initialize()
	table.insert(CHMenu.categories, 2, WARDROBE)
	WARDROBE:LoadTabs()
end
hook.Add("chsh_load_categories", "load_wardrobe", Initialize)