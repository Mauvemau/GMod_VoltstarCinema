
CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )

local function BuildColorSelectorFrame()
	if(!IsValid(WDTabsPanel))then return end
	
	CLFrame = vgui.Create("DPanel", WDTabsPanel)
	CLFrame:SetSize( WDTabsPanel:GetWide() * 1, WDTabsPanel:GetTall() * 1 )
	CLFrame:SetPos( 0, 0)
	CLFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local scroll = vgui.Create("DScrollPanel", CLFrame)
	scroll:SetPos(CLFrame:GetWide() * .01, CLFrame:GetTall() * .01)
	scroll:SetSize(CLFrame:GetWide() * .48, CLFrame:GetTall() * .98)
	scroll.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	local ypos = 0
	
	local ColorFrame = vgui.Create("DPanel", CLFrame)
	ColorFrame:SetPos(CLFrame:GetWide() * .5, CLFrame:GetTall() * .01)
	ColorFrame:SetSize(CLFrame:GetWide() * .49, CLFrame:GetTall() * .98)
	PaintFrame(ColorFrame)
	ColorFrame.Current = nil
	
	local function OpenEditor(obj, defaultColor)
		if(ColorFrame.Current != nil) then ColorFrame.Current:Remove() end
		local newColor = defaultColor
		
		local EditorFrame = vgui.Create("DPanel", ColorFrame)
		EditorFrame:SetPos(0, 0)
		EditorFrame:SetSize(ColorFrame:GetWide() * 1, ColorFrame:GetTall() *1)
		EditorFrame.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		end
		ColorFrame.Current = EditorFrame
		
		local text = vgui.Create("DLabel", EditorFrame)
		text:SetPos(EditorFrame:GetWide() * .2, EditorFrame:GetTall() * .01)
		text:SetSize(EditorFrame:GetWide() * .4, EditorFrame:GetTall() * .1)
		text:SetText(obj.name)
		text:SetFont("chsh_bg_font")
		text:SetColor(defaultColor)
		
		local ColorPickerPanel = vgui.Create("DPanel", EditorFrame)
		ColorPickerPanel:SetPos(EditorFrame:GetWide() * .2, EditorFrame:GetTall() * .1)
		ColorPickerPanel:SetSize(EditorFrame:GetWide() * .6, EditorFrame:GetTall() * .32)
		PaintFrameSpecific(ColorPickerPanel, defaultColor)
		
		local ColorMixer = vgui.Create("DColorMixer", ColorPickerPanel)
		ColorMixer:SetPos(ColorPickerPanel:GetWide() * .01, ColorPickerPanel:GetTall() * .01)
		ColorMixer:SetSize(ColorPickerPanel:GetWide() * .98, ColorPickerPanel:GetTall() * .98)
		ColorMixer:SetAlphaBar(false)
		ColorMixer:SetPalette(false)
		ColorMixer:SetColor(defaultColor)
		
		local SetButton = vgui.Create("DButton", EditorFrame)
		SetButton:SetPos(EditorFrame:GetWide() * .2, EditorFrame:GetTall() * .45)
		SetButton:SetSize(EditorFrame:GetWide() * .25, EditorFrame:GetTall() * .06)
		SetButton:SetText("Set Color")
		SetButton:SetFont("chsh_bg_font")
		PaintButtonSpecific(SetButton, defaultColor)
		
		local UndoButton = vgui.Create("DButton", EditorFrame)
		UndoButton:SetPos(EditorFrame:GetWide() * .55, EditorFrame:GetTall() * .45)
		UndoButton:SetSize(EditorFrame:GetWide() * .25, EditorFrame:GetTall() * .06)
		UndoButton:SetText("Reset Color")
		UndoButton:SetFont("chsh_bg_font")
		PaintButtonSpecific(UndoButton, defaultColor)
		
		local function ChangeAllColors(color)
			text:SetColor(color)
			PaintFrameSpecific(ColorPickerPanel, color)
			PaintButtonSpecific(SetButton, color)
			PaintButtonSpecific(UndoButton, color)
		end
		
		ColorMixer.ValueChanged = function()
			newColor = ColorMixer:GetColor()
			ChangeAllColors(newColor)
		end
		
		UndoButton.DoClick = function()
			newColor = defaultColor
			ColorMixer:SetVector(defaultColor:ToVector())
			ChangeAllColors(defaultColor)
		end
		SetButton.DoClick = function()
			obj:SwitchColors(newColor)
		end
		
	end
	--[[
	-- Name
	local NameColorFrame = vgui.Create("DPanel", scroll)
	NameColorFrame:SetPos(0, ypos)
	NameColorFrame:SetSize(scroll:GetWide() * 1, CLFrame:GetTall() * .12)
	PaintFrameSpecific(NameColorFrame, team.GetColor(LocalPlayer():Team()))
	NameColorFrame.name = "Name Color"
	
	ypos = ypos + NameColorFrame:GetTall() * 1.1
	
	local text = vgui.Create("DLabel", NameColorFrame)
	text:SetPos(NameColorFrame:GetWide() * .05, NameColorFrame:GetTall() * .32)
	text:SetSize(NameColorFrame:GetWide() * .4, NameColorFrame:GetTall() * .35)
	text:SetText(NameColorFrame.name)
	text:SetFont("chsh_bg_font")
	text:SetColor(team.GetColor(LocalPlayer():Team()))
	
	local CustomizeButton = vgui.Create("DButton", NameColorFrame)
	CustomizeButton:SetPos(NameColorFrame:GetWide() * .7, NameColorFrame:GetTall() * .3)
	CustomizeButton:SetSize(NameColorFrame:GetWide() * .25, NameColorFrame:GetTall() * .45)
	CustomizeButton:SetText("Customize")
	CustomizeButton:SetFont("chsh_bg_font")
	PaintButtonSpecific(CustomizeButton, team.GetColor(LocalPlayer():Team()))
	
	function NameColorFrame:SwitchColors(newColor)
		PaintFrameSpecific(self, newColor)
		text:SetColor(newColor)
		PaintButtonSpecific(CustomizeButton, newColor)
	end
	
	CustomizeButton.DoClick = function()
		OpenEditor(NameColorFrame, team.GetColor(LocalPlayer():Team()))
	end
	]]
	-- Interface
	local InterfaceColorFrame = vgui.Create("DPanel", scroll)
	InterfaceColorFrame:SetPos(0, ypos)
	InterfaceColorFrame:SetSize(scroll:GetWide() * 1, CLFrame:GetTall() * .12)
	PaintFrame(InterfaceColorFrame)
	InterfaceColorFrame.name = "Interface Color"
	
	ypos = ypos + InterfaceColorFrame:GetTall() * 1.1
	
	local text = vgui.Create("DLabel", InterfaceColorFrame)
	text:SetPos(InterfaceColorFrame:GetWide() * .05, InterfaceColorFrame:GetTall() * .32)
	text:SetSize(InterfaceColorFrame:GetWide() * .4, InterfaceColorFrame:GetTall() * .35)
	text:SetText(InterfaceColorFrame.name)
	text:SetFont("chsh_bg_font")
	text:SetColor(borderColor)
	
	local CustomizeButton = vgui.Create("DButton", InterfaceColorFrame)
	CustomizeButton:SetPos(InterfaceColorFrame:GetWide() * .7, InterfaceColorFrame:GetTall() * .3)
	CustomizeButton:SetSize(InterfaceColorFrame:GetWide() * .25, InterfaceColorFrame:GetTall() * .45)
	CustomizeButton:SetText("Customize")
	CustomizeButton:SetFont("chsh_bg_font")
	PaintButtonSpecific(CustomizeButton, borderColor)
	
	function InterfaceColorFrame:SwitchColors(newColor)
		CHMenu:Close()
		ChangeInterfaceColors(newColor)
		CHMenu:Open()
	end
	
	CustomizeButton.DoClick = function()
		OpenEditor(InterfaceColorFrame, borderColor)
	end
	
	-- Model
	local color = Vector(GetConVarString( "cl_playercolor" )):ToColor()
	
	local ModelColorFrame = vgui.Create("DPanel", scroll)
	ModelColorFrame:SetPos(0, ypos)
	ModelColorFrame:SetSize(scroll:GetWide() * 1, CLFrame:GetTall() * .12)
	PaintFrameSpecific(ModelColorFrame, color)
	ModelColorFrame.name = "Model Color"
	
	ypos = ypos + ModelColorFrame:GetTall() * 1.1
	
	local text = vgui.Create("DLabel", ModelColorFrame)
	text:SetPos(ModelColorFrame:GetWide() * .05, ModelColorFrame:GetTall() * .32)
	text:SetSize(ModelColorFrame:GetWide() * .4, ModelColorFrame:GetTall() * .35)
	text:SetText(ModelColorFrame.name)
	text:SetFont("chsh_bg_font")
	text:SetColor(color)
	
	local CustomizeButton = vgui.Create("DButton", ModelColorFrame)
	CustomizeButton:SetPos(ModelColorFrame:GetWide() * .7, ModelColorFrame:GetTall() * .3)
	CustomizeButton:SetSize(ModelColorFrame:GetWide() * .25, ModelColorFrame:GetTall() * .45)
	CustomizeButton:SetText("Customize")
	CustomizeButton:SetFont("chsh_bg_font")
	PaintButtonSpecific(CustomizeButton, color)
	
	function ModelColorFrame:SwitchColors(newColor)
		PaintFrameSpecific(self, newColor)
		text:SetColor(newColor)
		PaintButtonSpecific(CustomizeButton, newColor)
		
		newVector = Vector(newColor.r/255, newColor.g/255, newColor.b/255)
		RunConsoleCommand("cl_playercolor", tostring(newVector))
		net.Start("chsh_change_pColor")
			net.WriteString(LocalPlayer():GetInfo("cl_playercolor"))
		net.SendToServer()
		if(!IsValid(PlayermodelView))then return end
		PlayermodelView.Entity.GetPlayerColor = function() return Vector(GetConVarString( "cl_playercolor" )) end
	end
	
	CustomizeButton.DoClick = function()
		OpenEditor(ModelColorFrame, color)
	end
	
	-- Physgun
	local color = Vector(GetConVarString( "cl_weaponcolor" )):ToColor()
	
	local PhysgunColorFrame = vgui.Create("DPanel", scroll)
	PhysgunColorFrame:SetPos(0, ypos)
	PhysgunColorFrame:SetSize(scroll:GetWide() * 1, CLFrame:GetTall() * .12)
	PaintFrameSpecific(PhysgunColorFrame, color)
	PhysgunColorFrame.name = "Physgun Color"
	
	ypos = ypos + PhysgunColorFrame:GetTall() * 1.1
	
	local text = vgui.Create("DLabel", PhysgunColorFrame)
	text:SetPos(PhysgunColorFrame:GetWide() * .05, PhysgunColorFrame:GetTall() * .32)
	text:SetSize(PhysgunColorFrame:GetWide() * .4, PhysgunColorFrame:GetTall() * .35)
	text:SetText(PhysgunColorFrame.name)
	text:SetFont("chsh_bg_font")
	text:SetColor(color)
	
	local CustomizeButton = vgui.Create("DButton", PhysgunColorFrame)
	CustomizeButton:SetPos(PhysgunColorFrame:GetWide() * .7, PhysgunColorFrame:GetTall() * .3)
	CustomizeButton:SetSize(PhysgunColorFrame:GetWide() * .25, PhysgunColorFrame:GetTall() * .45)
	CustomizeButton:SetText("Customize")
	CustomizeButton:SetFont("chsh_bg_font")
	PaintButtonSpecific(CustomizeButton, color)
	
	function PhysgunColorFrame:SwitchColors(newColor)
		PaintFrameSpecific(self, newColor)
		text:SetColor(newColor)
		PaintButtonSpecific(CustomizeButton, newColor)
		
		newVector = Vector(newColor.r/255, newColor.g/255, newColor.b/255)
		RunConsoleCommand("cl_weaponcolor", tostring(newVector))
		net.Start("chsh_change_wColor")
			net.WriteString(LocalPlayer():GetInfo("cl_weaponcolor"))
		net.SendToServer()
	end
	
	CustomizeButton.DoClick = function()
		OpenEditor(PhysgunColorFrame, color)
	end
	
	if(IsValid(WDHelpSign))then
		WDHelpSign:SetText("Customize the COLORS of your Interface, Model and Physgun. (Donators Only) Change the color of your name!")
		WDHelpSign:SizeToContents()
	end
	
end

local COLORS = {}

COLORS.id = "Colors"

function COLORS:GetID()
	return self.id
end

function COLORS:Open()
	WD:CloseAllTabs()
	BuildColorSelectorFrame()
end

function COLORS:Close()
	if(IsValid(CLFrame))then
		CLFrame:Remove()
	end
end

local function Initialize()
	table.insert(WD.tabs, COLORS)
end
hook.Add("chsh_load_wardrobe", "load_colors", Initialize)