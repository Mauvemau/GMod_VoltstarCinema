
local function BuildAccs()
	if(!IsValid(SHTabsPanel))then return end
	
	SHAccessoriesFrame = vgui.Create("DPanel", SHTabsPanel)
	SHAccessoriesFrame:SetSize( SHTabsPanel:GetWide() * 1, SHTabsPanel:GetTall() * 1 )
	SHAccessoriesFrame:SetPos( 0, 0)
	SHAccessoriesFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local TopBar = vgui.Create("DPanel", SHAccessoriesFrame)
	TopBar:SetPos(0, 0)
	TopBar:SetSize(SHAccessoriesFrame:GetWide() * 1, SHAccessoriesFrame:GetTall() * .06)
	PaintFrame(TopBar)
	
	local scroll = vgui.Create("DScrollPanel", SHAccessoriesFrame)
	scroll:SetPos( 0, SHAccessoriesFrame:GetTall() * .065)
	scroll:SetSize( SHAccessoriesFrame:GetWide() * .999, SHAccessoriesFrame:GetTall() * .925)
	
	local items = db_accessories
	local displayItems = items
	
	local ypos = 0
	
	local function LoadPMShop()
		if(!IsValid(scroll))then return end
		scroll:GetCanvas():Clear()
		ypos = 0
		
		for k, v in SortedPairsByMemberValue(displayItems, "name", false) do
			if(v.enabled)then
				
				local ItemPanel = vgui.Create("DPanel", scroll)
				ItemPanel:SetPos(SHAccessoriesFrame:GetWide() * .005, ypos)
				ItemPanel:SetSize(SHAccessoriesFrame:GetWide() * .975, SHAccessoriesFrame:GetTall() * .175)
				PaintFrame(ItemPanel)
				
				local PicPanel = vgui.Create("DPanel", ItemPanel)
				PicPanel:SetPos(ItemPanel:GetWide() * .01, ItemPanel:GetTall() * .1)
				PicPanel:SetSize(ItemPanel:GetTall() * .8, ItemPanel:GetTall() * .8)
				PaintFrame(PicPanel)
				
				local icon = vgui.Create("SpawnIcon", PicPanel)
				icon:SetModel(v.reference)
				icon:SetPos(2, 2)
				icon:SetSize(PicPanel:GetTall() - 4, PicPanel:GetTall() - 4)

				local ItemName = vgui.Create("DLabel", ItemPanel)
				ItemName:SetPos(ItemPanel:GetWide() * .12, ItemPanel:GetTall() * .1)
				ItemName:SetSize(ItemPanel:GetWide() * .7, ItemPanel:GetTall() * .3)
				ItemName:SetFont("chsh_shop_title_font")
				ItemName:SetText(v.name)
				ItemName:SetColor(Color(255, 255, 255, 255))
				
				if(string.len(v.description) > 0)then
					local Description = vgui.Create("DLabel", ItemPanel)
					Description:SetPos(ItemPanel:GetWide() * .122, ItemPanel:GetTall() * .4)
					Description:SetColor(Color(150, 150, 150, 255))
					Description:SetFont("chsh_shop_description_font")
					Description:SetText("\"".. v.description .."\"")
					Description:SizeToContents()
				end
				
				local PriceSlot = vgui.Create("DPanel", ItemPanel)
				PriceSlot:SetPos(0, 0)
				PriceSlot:SetSize(0, ItemPanel:GetTall() * .3)
				PriceSlot.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
				end
				
				local CurrencyIco = vgui.Create("DPanel", PriceSlot)
				CurrencyIco:SetPos(0, 0)
				CurrencyIco:SetSize(PriceSlot:GetTall() * 1, PriceSlot:GetTall() * 1)
				CurrencyIco.Paint = function(self, w, h)
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(currencyIcoLocal)
					surface.DrawTexturedRect(0, 0, w, h)
				end
				
				local Price = vgui.Create("DLabel", PriceSlot)
				Price:SetPos((CurrencyIco:GetWide() * 1) + 5, 0)
				Price:SetFont("chsh_shop_price_font")
				Price:SetText(ReplaceCommaWithDot(string.Comma(v.price)))
				Price:SetContentAlignment(4)
				Price:SetColor(Color(255, 255, 255, 255))
				Price:SizeToContents()
				
				local SlotButton = vgui.Create("DButton", ItemPanel)
				SlotButton:SetPos(2, 2)
				SlotButton:SetSize(ItemPanel:GetWide() - 4, ItemPanel:GetTall() - 4)
				PaintImageButton(SlotButton)
				SlotButton:SetText("")
				
				SlotButton.OnCursorEntered = function()
					SlotButton.Paint = function(self, w, h)
						draw.RoundedBox( 0, 0, 0, w, h, GridSlotMouseover )
					end
					
					if(!disablePreview)then
						if(!IsValid(PlayermodelView))then return end
						PlayermodelView:SetModel(v.reference)
						
						local mn, mx = PlayermodelView.Entity:GetRenderBounds()
						local size = 0
						size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
						size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
						size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
						
						PlayermodelView:SetFOV(75)
						PlayermodelView:SetCamPos(Vector(size, size, size))
						PlayermodelView:SetLookAt((mn + mx) * 0.5)
					end
				end
				SlotButton.OnCursorExited = function()
					SlotButton.Paint = function(self, w, h)
						draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
					end
				end
				
				local posW = ItemPanel:GetWide() * .8
				local posT = ItemPanel:GetTall() * .1
				--[[
				local PurchaseButton = vgui.Create("DButton", ItemPanel)
				PurchaseButton:SetPos(posW, posT)
				PurchaseButton:SetSize(ItemPanel:GetWide() * .18, ItemPanel:GetTall() * .3)
				PurchaseButton:SetFont("chsh_bg_font")
				
				-- Accomodating the price next to the button
				PriceSlot:SetWide((CurrencyIco:GetWide() * 1) + 5 + (Price:GetWide() * 1))
				PriceSlot:SetPos(posW - (PriceSlot:GetWide() * 1) - 10, posT)
				
				if(OwnsItem(LocalPlayer(), v.uid))then
					local col = Color(20, 255, 20, 255)
					local darkerColor = MakeDarkerColor(col)
				
					PurchaseButton:SetText("Owned")
					PaintButtonSpecific(PurchaseButton, col)
					CurrencyIco:Remove()
					Price:Remove()
					
					PurchaseButton.OnCursorEntered = function()
						PurchaseButton:SetText("Thank you! <3")
						PurchaseButton.Paint = function(self, w, h)
							draw.RoundedBox( 0, 0, 0, w, h, darkerColor )
						end
						PurchaseButton:SetColor(backgroundColor)
					end
					PurchaseButton.OnCursorExited = function()
						PurchaseButton:SetText("Owned")
						PurchaseButton.Paint = function(self, w, h)
							draw.RoundedBox( 0, 0, 0, w, h, col)
							draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
						end
						PurchaseButton:SetColor(col)
					end
				elseif(GetCredits(LocalPlayer()) > v.price)then
				
					PurchaseButton:SetText("Purchase")
					PaintButton(PurchaseButton)
					Price:SetColor(Color(255, 255, 255, 255))
					
					PurchaseButton.DoClick = function()
						if(GetCredits(LocalPlayer()) < v.price)then return end
						if(OwnsItem(LocalPlayer(), v.uid))then return end
						PURCHASE:Open(v.uid, false)
					end
					
				else
					local col = Color(125, 125, 125, 255)
					local darkerColor = MakeDarkerColor(col)
				
					PurchaseButton:SetText("Purchase")
					PaintButtonSpecific(PurchaseButton, col)
					Price:SetColor(Color(255, 20, 20, 255))
					
					PurchaseButton.OnCursorEntered = function()
						PurchaseButton:SetText("Insufficient Credits")
						PurchaseButton.Paint = function(self, w, h)
							draw.RoundedBox( 0, 0, 0, w, h, darkerColor )
						end
						PurchaseButton:SetColor(backgroundColor)
					end
					PurchaseButton.OnCursorExited = function()
						PurchaseButton:SetText("Purchase")
						PurchaseButton.Paint = function(self, w, h)
							draw.RoundedBox( 0, 0, 0, w, h, col)
							draw.RoundedBox( 0, 2, 2, w-4, h-4, backgroundColor )
						end
						PurchaseButton:SetColor(col)
					end
				end
				]]
				ypos = ypos + ItemPanel:GetTall() * 1.05
				
			end
			
		end
		
	end
	LoadPMShop()
	
	local SearchLabel = vgui.Create("DLabel", TopBar)
	SearchLabel:SetPos(TopBar:GetWide() * .67, 0)
	SearchLabel:SetContentAlignment(4)
	SearchLabel:SetFont("chsh_topbar_font")
	SearchLabel:SetText("Search Accessories")
	SearchLabel:SetColor(Color(245, 245, 245, 255))
	SearchLabel:SizeToContents()
	SearchLabel:SetTall(TopBar:GetTall())
	
	local SearchBarPanel = vgui.Create("DPanel", TopBar)
	SearchBarPanel:SetPos(TopBar:GetWide() * .8, 0)
	SearchBarPanel:SetSize(TopBar:GetWide() * .2, TopBar:GetTall() * 1)
	PaintFrame(SearchBarPanel)
	
	local SearchBar = vgui.Create("DTextEntry", SearchBarPanel)
	SearchBar:SetPos(2, 2)
	SearchBar:SetSize(SearchBarPanel:GetWide() - 4, SearchBarPanel:GetTall() -4)
	SearchBar:SetUpdateOnType(true)
	SearchBar:SetPlaceholderText("")
	
	SearchLabel:SetPos(TopBar:GetWide() - SearchBar:GetWide() - SearchLabel:GetWide() - 10)
	
	SearchBar.OnValueChange = function(s, str)
		displayItems = {}
		local searchlist = items
		
		for k, v in pairs(searchlist) do
			local name = v.name
			if(string.match(name:lower(), str:lower()))then
				table.insert(displayItems, v)
			end
		end
		LoadPMShop()
	end
	
	if(IsValid(SHHelpSign))then
		SHHelpSign:SetText("Purchase cool accessories for your character.")
		SHHelpSign:SizeToContents()
	end
	
end

local SHACCS = {}

SHACCS.id = "Accessories"

function SHACCS:GetID()
	return self.id
end

function SHACCS:Open()
	SH:CloseAllTabs()
	BuildAccs()
end

function SHACCS:Close()
	if(IsValid(SHAccessoriesFrame))then
		SHAccessoriesFrame:Remove()
	end
end

local function Initialize()
	table.insert(SH.tabs, SHACCS)
end
hook.Add("chsh_load_shop", "load_accessories", Initialize)