
local defaultTab = 1
local lastTab = defaultTab

local function BuildShop()
	if(!IsValid(CHMenuFrame))then return end

	ShopPanel = vgui.Create("DPanel", CHMenuFrame)
	ShopPanel:SetSize( CHMenuFrame:GetWide() * 1, CHMenuFrame:GetTall() * 0.88 )
	ShopPanel:SetPos( 0, CHMenuFrame:GetTall() * .1185 )
	ShopPanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	if(IsValid(BottomBarPanel))then
		BottomBarPanel:MoveToFront()
	end
	
	local PlayerViewBox = vgui.Create("DPanel", ShopPanel)
	PlayerViewBox:SetSize( ShopPanel:GetWide() * .3, ShopPanel:GetTall() * .85 )
	PlayerViewBox:SetPos( ShopPanel:GetWide() * .02, ShopPanel:GetTall() * .035 )
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
	
	--
	
	local TabsPanelBox = vgui.Create("DPanel", ShopPanel)
	TabsPanelBox:SetSize( ShopPanel:GetWide() * .65, ShopPanel:GetTall() * 0.85 )
	TabsPanelBox:SetPos( ShopPanel:GetWide() * .335, ShopPanel:GetTall() * .035 )
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
	
	if(table.Count(SH.tabs) < 1) then return end
	
	local xpos = 0
	for i = 1, table.Count(SH.tabs) do
	
		local Button = vgui.Create("DButton", TabsButtoner)
		Button:SetText(SH.tabs[i]:GetID())
		Button:SetFont("chsh_tabs_buttons_font")
		Button:SetSize( TabsButtoner:GetWide() * .18, TabsButtoner:GetTall() * 1 )
		Button:SetPos(xpos, 0)
		xpos = xpos + Button:GetWide() * 1
		PaintButton(Button)
		
		Button.DoClick = function()
			TabsButtoner:UnselectAllButtons()
			SH.tabs[i]:Open()
			TabsButtoner:SelectButton(i)
			lastTab = i
		end
		
		table.insert(TabsButtoner.buttons, Button)
	end
	
	local InfoIco = vgui.Create("DSprite", ShopPanel)
	InfoIco:SetMaterial(Material("icon16/information.png"))
	InfoIco:SetPos( ShopPanel:GetWide() * .35, ShopPanel:GetTall() * .91 )
	InfoIco:SetSize( ShopPanel:GetTall() * .03, ShopPanel:GetTall() * .03 )
	
	SHHelpSign = vgui.Create("DLabel", ShopPanel)
	SHHelpSign:SetPos( ShopPanel:GetWide() * .362, ShopPanel:GetTall() * .89 )
	SHHelpSign:SetFont("chsh_tips_font")
	SHHelpSign:SetText("")
	
	SHTabsPanel = vgui.Create("DPanel", TabsPanelBox)
	SHTabsPanel:SetPos( 0, TabsPanelBox:GetTall() * .1)
	SHTabsPanel:SetSize( TabsPanelBox:GetWide() * 1, TabsPanelBox:GetTall() * .9 )
	PaintFrame(SHTabsPanel)
	
	TabsButtoner:UnselectAllButtons()
	SH.tabs[lastTab]:Open()
	TabsButtoner:SelectButton(lastTab)
	
end

local SHOP = {}

SHOP.id = "Shop"

SH = {}
SH.tabs = {}

function SH:CloseAllTabs()
	for i = 1, table.Count(self.tabs) do
		self.tabs[i]:Close()
	end
end

function SHOP:GetID()
	return self.id
end

function SHOP:Open()
	CHMenu:CloseAllTabs()
	BuildShop()
end

function SHOP:Close()
	if(IsValid(ShopPanel))then
		ShopPanel:Remove()
	end
end

function SHOP:LoadTabs()
	table.Empty(SH.tabs)
	hook.Call("chsh_load_shop")
end

local function Initialize()
	table.insert(CHMenu.categories, SHOP)
	SHOP:LoadTabs()
end
hook.Add("chsh_load_categories", "load_shop", Initialize)