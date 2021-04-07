
local function BuildItems()
	if(!IsValid(SHTabsPanel))then return end
	
	SHItemsFrame = vgui.Create("DPanel", SHTabsPanel)
	SHItemsFrame:SetSize( SHTabsPanel:GetWide() * 1, SHTabsPanel:GetTall() * 1 )
	SHItemsFrame:SetPos( 0, 0)
	SHItemsFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local TopBar = vgui.Create("DPanel", SHItemsFrame)
	TopBar:SetPos(0, 0)
	TopBar:SetSize(SHItemsFrame:GetWide() * 1, SHItemsFrame:GetTall() * .06)
	PaintFrame(TopBar)
	
	local scroll = vgui.Create("DScrollPanel", SHItemsFrame)
	scroll:SetPos( 0, SHItemsFrame:GetTall() * .065)
	scroll:SetSize( SHItemsFrame:GetWide() * .999, SHItemsFrame:GetTall() * .925)
	
	local items = db_sweps
	local displayItems = items
	
	local ypos = 0
	
	local function LoadPMShop()
		if(!IsValid(scroll))then return end
		scroll:GetCanvas():Clear()
		ypos = 0
		
		for k, v in SortedPairsByMemberValue(displayItems, "name", false) do
			if(v.enabled)then
				
				local ItemPanel = vgui.Create("DPanel", scroll)
				ItemPanel:SetPos(SHItemsFrame:GetWide() * .005, ypos)
				ItemPanel:SetSize(SHItemsFrame:GetWide() * .975, SHItemsFrame:GetTall() * .175)
				PaintFrame(ItemPanel)
				
				local PicPanel = vgui.Create("DPanel", ItemPanel)
				PicPanel:SetPos(ItemPanel:GetWide() * .01, ItemPanel:GetTall() * .1)
				PicPanel:SetSize(ItemPanel:GetTall() * .8, ItemPanel:GetTall() * .8)
				PaintFrame(PicPanel)
				
				local icon = vgui.Create("DImage", PicPanel)
				icon:SetImage("vgui/entities/".. v.reference)
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
						PlayermodelView:SetModel(weapons.Get(v.reference).WorldModel)
						
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
				
				ypos = ypos + ItemPanel:GetTall() * 1.05
				
			end
			
		end
		
	end
	LoadPMShop()
	
	local SearchLabel = vgui.Create("DLabel", TopBar)
	SearchLabel:SetPos(TopBar:GetWide() * .67, 0)
	SearchLabel:SetContentAlignment(4)
	SearchLabel:SetFont("chsh_topbar_font")
	SearchLabel:SetText("Search Items")
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
		SHHelpSign:SetText("Buy sweps and items with your credits.")
		SHHelpSign:SizeToContents()
	end
	
end

local SHITEMS = {}

SHITEMS.id = "Items"

function SHITEMS:GetID()
	return self.id
end

function SHITEMS:Open()
	SH:CloseAllTabs()
	BuildItems()
end

function SHITEMS:Close()
	if(IsValid(SHItemsFrame))then
		SHItemsFrame:Remove()
	end
end

local function Initialize()
	table.insert(SH.tabs, 1, SHITEMS)
end
hook.Add("chsh_load_shop", "load_items", Initialize)