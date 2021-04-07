
local function BuildPlayermodelSelector()
	if(!IsValid(WDTabsPanel))then return end
	
	PMFrame = vgui.Create("DPanel", WDTabsPanel)
	PMFrame:SetSize( WDTabsPanel:GetWide() * 1, WDTabsPanel:GetTall() * 1 )
	PMFrame:SetPos( 0, 0)
	PMFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	-- Settings
	local slotsize = 14
	local maxRow = 10
	local currentColumn = 1
	local amountSlots = 48
	--
	
	slotsize = slotsize * .01
	
	local Scroll = vgui.Create("DScrollPanel", PMFrame)
	Scroll:SetPos( PMFrame:GetWide() * .01, PMFrame:GetTall() * .08)
	Scroll:SetSize( PMFrame:GetWide() * .99, PMFrame:GetTall() * .91)
	
	local TopBar = vgui.Create("DPanel", PMFrame)
	TopBar:SetPos(0, PMFrame:GetTall() * .01)
	TopBar:SetSize(PMFrame:GetWide() * 1, PMFrame:GetTall() * .06)
	PaintFrame(TopBar)
	
	local models = GetAllOwnedModels(LocalPlayer())
	local defaults = GetDefaultModels()
	local displayModels = models
	local custom = true
	
	local ypos = 0
	local xpos = 0
	local function LoadModels()
		if(!IsValid(Scroll))then return end
		Scroll:GetCanvas():Clear()
		ypos = 0
		xpos = 0
		currentColumn = 1
		
		if(table.Count(models) < 1 && custom)then
			local Sign = vgui.Create("DLabel", Scroll)
			Sign:SetPos(0, Scroll:GetTall() * .45)
			Sign:SetSize(Scroll:GetWide() * 1, Scroll:GetTall() * .1)
			Sign:SetContentAlignment(5)
			Sign:SetFont("chsh_under_construction_font_small")
			Sign:SetText("Get a free playermodel from the shop! :)")
			return
		end
		
		for k, v in SortedPairsByMemberValue(displayModels, "name", false) do
			local Slot = vgui.Create("DPanel", Scroll)
			Slot:SetPos( xpos, ypos)
			Slot:SetSize(PMFrame:GetTall() * slotsize, PMFrame:GetTall() * slotsize)
			PaintFrame(Slot)

			local icon = vgui.Create( "SpawnIcon", Slot)
			icon:SetModel( v.reference )
			icon:SetPos(2, 2)
			icon:SetSize(Slot:GetTall() - 4, Slot:GetTall() - 4)
			icon:SetTooltip( v.name )
			icon.playermodel = v.name
			icon.model_path = v.reference
			
			icon.DoClick = function()
				pmSelected = icon.model_path
				--
				if(!IsValid(PlayermodelView)) then return end
				PlayermodelView:SetModel(icon.model_path)
				
				local mn, mx = PlayermodelView.Entity:GetRenderBounds()
				local size = 0
				size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
				size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
				size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
				
				PlayermodelView:SetFOV(25)
				PlayermodelView:SetCamPos(Vector(size, size, size))
				PlayermodelView:SetLookAt((mn + mx) * 0.5)
				
				skSelected = LocalPlayer():GetSkin()
				bgSelected = {}
				RunConsoleCommand( "cl_playerbodygroups", "0" )
				RunConsoleCommand( "cl_playerskin", "0" )
			end
			
			xpos = xpos + Slot:GetWide() * 1.05
			currentColumn = currentColumn + 1
			if(currentColumn > maxRow) then
				xpos = 0
				currentColumn = 1
				ypos = ypos + Slot:GetTall() * 1.05
			end
		end
	end
	LoadModels()
	
	local Buttons = {}
	
	local function UnselectAllButtons()
		for k, v in pairs(Buttons)do
			ButtonToggleSelected(v, false)
		end
	end
	
	local buttonxpos = 0
	local CustomButton = vgui.Create("DButton", TopBar)
	CustomButton:SetPos(buttonxpos, 0)
	CustomButton:SetSize(TopBar:GetWide() * .15, TopBar:GetTall() * 1)
	CustomButton:SetFont("chsh_topbar_font")
	CustomButton:SetText("Custom Models")
	CustomButton.selected = false
	PaintButton(CustomButton)
	table.insert(Buttons, CustomButton)
	ButtonToggleSelected(CustomButton, true)
	
	buttonxpos = buttonxpos + CustomButton:GetWide()
	
	local DefaultButton = vgui.Create("DButton", TopBar)
	DefaultButton:SetPos(buttonxpos, 0)
	DefaultButton:SetSize(TopBar:GetWide() * .15, TopBar:GetTall() * 1)
	DefaultButton:SetFont("chsh_topbar_font")
	DefaultButton:SetText("Default Models")
	DefaultButton.selected = false
	PaintButton(DefaultButton)
	table.insert(Buttons, DefaultButton)
	ButtonToggleSelected(DefaultButton, false)
	
	buttonxpos = buttonxpos + DefaultButton:GetWide()
	
	local SearchLabel = vgui.Create("DLabel", TopBar)
	SearchLabel:SetPos(TopBar:GetWide() * .67, 0)
	SearchLabel:SetSize(TopBar:GetWide() * .13, TopBar:GetTall() * 1)
	SearchLabel:SetContentAlignment(4)
	SearchLabel:SetFont("chsh_topbar_font")
	SearchLabel:SetText("Search Model")
	SearchLabel:SetColor(Color(245, 245, 245, 255))
	
	local SearchBarPanel = vgui.Create("DPanel", TopBar)
	SearchBarPanel:SetPos(TopBar:GetWide() * .8, 0)
	SearchBarPanel:SetSize(TopBar:GetWide() * .2, TopBar:GetTall() * 1)
	PaintFrame(SearchBarPanel)
	
	local SearchBar = vgui.Create("DTextEntry", SearchBarPanel)
	SearchBar:SetPos(2, 2)
	SearchBar:SetSize(SearchBarPanel:GetWide() - 4, SearchBarPanel:GetTall() -4)
	SearchBar:SetUpdateOnType(true)
	SearchBar:SetPlaceholderText("")
	
	SearchBar.OnValueChange = function(s, str)
		displayModels = {}
		local searchlist = {}
		
		if(custom) then
			searchlist = models
		else
			searchlist = defaults
		end
		
		for k, v in pairs(searchlist) do
			local name = v.name
			if(string.match(name:lower(), str:lower()))then
				table.insert(displayModels, v)
			end
		end
		LoadModels()
	end
	
	CustomButton.DoClick = function()
		if(CustomButton.selected)then return false end
		UnselectAllButtons()
		ButtonToggleSelected(CustomButton, true)
		displayModels = {}
		SearchBar:SetValue("")
		custom = true
		displayModels = models
		LoadModels()
	end
	
	DefaultButton.DoClick = function()
		if(DefaultButton.selected)then return false end
		UnselectAllButtons()
		ButtonToggleSelected(DefaultButton, true)
		displayModels = {}
		SearchBar:SetValue("")
		custom = false
		displayModels = defaults
		LoadModels()
	end

	if(IsValid(WDHelpSign))then
		WDHelpSign:SetText("All of your PURCHASED PLAYERMODELS. [CLICK] on any playermodel icon to equip it!")
		WDHelpSign:SizeToContents()
	end
	
end

local PLAYERMODELS = {}

PLAYERMODELS.id = "My Models"

function PLAYERMODELS:GetID()
	return self.id
end

function PLAYERMODELS:Open()
	WD:CloseAllTabs()
	BuildPlayermodelSelector()
end

function PLAYERMODELS:Close()
	if(IsValid(PMFrame))then
		PMFrame:Remove()
	end
end

local function Initialize()
	table.insert(WD.tabs, 1, PLAYERMODELS)
end
hook.Add("chsh_load_wardrobe", "load_playermodels", Initialize)