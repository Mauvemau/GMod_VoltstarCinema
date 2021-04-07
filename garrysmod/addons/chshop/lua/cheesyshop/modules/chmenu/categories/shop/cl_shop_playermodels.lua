
CreateConVar( "chsh_disable_preview", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "Disables model preview when you hover your mouse over a shop slot." )

local function BuildPMS()
	if(!IsValid(SHTabsPanel))then return end
	
	SHPlFrame = vgui.Create("DPanel", SHTabsPanel)
	SHPlFrame:SetSize( SHTabsPanel:GetWide() * 1, SHTabsPanel:GetTall() * 1 )
	SHPlFrame:SetPos( 0, 0)
	SHPlFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local TopBar = vgui.Create("DPanel", SHPlFrame)
	TopBar:SetPos(0, 0)
	TopBar:SetSize(SHPlFrame:GetWide() * 1, SHPlFrame:GetTall() * .06)
	PaintFrame(TopBar)
	
	local disablePreview = false
	
	if(GetConVar("chsh_disable_preview"):GetInt() != 0)then
		disablePreview = true
	end
	
	local DisablePreview = vgui.Create("DCheckBoxLabel", TopBar)
	DisablePreview:SetPos(TopBar:GetWide() * .01, TopBar:GetTall() * .1)
	DisablePreview:SetFont("chsh_topbar_font")
	DisablePreview:SetText("Disable Preview")
	DisablePreview:SetValue(disablePreview)
	DisablePreview:SetTooltip("Disables model preview when you hover your mouse over a shop slot.")
	DisablePreview:SetTextColor(Color(255, 255, 255, 255))
	
	local scroll = vgui.Create("DScrollPanel", SHPlFrame)
	scroll:SetPos( 0, SHPlFrame:GetTall() * .065)
	scroll:SetSize( SHPlFrame:GetWide() * .999, SHPlFrame:GetTall() * .925)
	
	local models = db_playermodels
	local displayModels = models
	
	local ypos = 0
	
	local function LoadPMShop()
		if(!IsValid(scroll))then return end
		scroll:GetCanvas():Clear()
		ypos = 0
		
		for k, v in SortedPairsByMemberValue(displayModels, "name", false) do
			if(v.enabled)then
				
				local PMPanel = vgui.Create("DPanel", scroll)
				PMPanel:SetPos(SHPlFrame:GetWide() * .005, ypos)
				PMPanel:SetSize(SHPlFrame:GetWide() * .975, SHPlFrame:GetTall() * .175)
				PaintFrame(PMPanel)
				
				local PicPanel = vgui.Create("DPanel", PMPanel)
				PicPanel:SetPos(PMPanel:GetWide() * .01, PMPanel:GetTall() * .1)
				PicPanel:SetSize(PMPanel:GetTall() * .8, PMPanel:GetTall() * .8)
				PaintFrame(PicPanel)
				
				local icon = vgui.Create("SpawnIcon", PicPanel)
				icon:SetModel(v.reference)
				icon:SetPos(2, 2)
				icon:SetSize(PicPanel:GetTall() - 4, PicPanel:GetTall() - 4)
				
				local PMName = vgui.Create("DLabel", PMPanel)
				PMName:SetPos(PMPanel:GetWide() * .12, PMPanel:GetTall() * .1)
				PMName:SetSize(PMPanel:GetWide() * .7, PMPanel:GetTall() * .3)
				PMName:SetFont("chsh_shop_title_font")
				PMName:SetText(v.name)
				PMName:SetColor(Color(255, 255, 255, 255))
				
				if(string.len(v.description) > 0)then
					local Description = vgui.Create("DLabel", PMPanel)
					Description:SetPos(PMPanel:GetWide() * .122, PMPanel:GetTall() * .4)
					Description:SetColor(Color(150, 150, 150, 255))
					Description:SetFont("chsh_shop_description_font")
					Description:SetText("\"".. v.description .."\"")
					Description:SizeToContents()
				end
				
				local PriceSlot = vgui.Create("DPanel", PMPanel)
				PriceSlot:SetPos(0, 0)
				PriceSlot:SetSize(0, PMPanel:GetTall() * .3)
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
				
				local SlotButton = vgui.Create("DButton", PMPanel)
				SlotButton:SetPos(2, 2)
				SlotButton:SetSize(PMPanel:GetWide() - 4, PMPanel:GetTall() - 4)
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
						
						PlayermodelView:SetFOV(25)
						PlayermodelView:SetCamPos(Vector(size, size, size))
						PlayermodelView:SetLookAt((mn + mx) * 0.5)
					end
					
				end
				SlotButton.OnCursorExited = function()
					SlotButton.Paint = function(self, w, h)
						draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
					end
				end
				
				local posW = PMPanel:GetWide() * .8
				local posT = PMPanel:GetTall() * .1
				
				local PurchaseButton = vgui.Create("DButton", PMPanel)
				PurchaseButton:SetPos(posW, posT)
				PurchaseButton:SetSize(PMPanel:GetWide() * .18, PMPanel:GetTall() * .3)
				PurchaseButton:SetFont("chsh_bg_font")
				
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
				elseif(GetPMCoupons(LocalPlayer()) > 0)then
					
					CurrencyIco:SetSize(PriceSlot:GetTall() * 1.4, (PriceSlot:GetTall() * 1) - 8)
					CurrencyIco:SetPos(0, 4)
					CurrencyIco.Paint = function(self, w, h)
						surface.SetDrawColor(Color(100, 235, 130, 255))
						surface.SetMaterial(couponIcoLocal)
						surface.DrawTexturedRect(0, 0, w, h)
					end
					
					Price:SetPos((CurrencyIco:GetWide() * 1) + 5, 0)
					Price:SetText("")
					Price:SizeToContents()
					
					PriceSlot:SetWide((CurrencyIco:GetWide() * 1) + 5 + (Price:GetWide() * 1))
					PriceSlot:SetPos(posW - (PriceSlot:GetWide() * 1) - 10, posT)
					
					PurchaseButton:SetText("Use Coupon")
					PaintButton(PurchaseButton)
					Price:SetColor(Color(255, 255, 255, 255))
					
					PurchaseButton.DoClick = function()
						if(GetPMCoupons(LocalPlayer()) < 1)then return end
						if(OwnsItem(LocalPlayer(), v.uid))then return end
						PURCHASE:Open(v.uid, true)
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
				
				ypos = ypos + PMPanel:GetTall() * 1.05
				
			end
			
		end
		
	end
	LoadPMShop()
	
	local SearchLabel = vgui.Create("DLabel", TopBar)
	SearchLabel:SetPos(TopBar:GetWide() * .67, 0)
	SearchLabel:SetSize(TopBar:GetWide() * .13, TopBar:GetTall() * 1)
	SearchLabel:SetContentAlignment(4)
	SearchLabel:SetFont("chsh_topbar_font")
	SearchLabel:SetText("Search Models")
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
		local searchlist = models
		
		for k, v in pairs(searchlist) do
			local name = v.name
			if(string.match(name:lower(), str:lower()))then
				table.insert(displayModels, v)
			end
		end
		LoadPMShop()
	end
	
	function DisablePreview:OnChange(val)
	
		if(!val)then
			RunConsoleCommand( "chsh_disable_preview", "0")
			disablePreview = false
			LoadPMShop()
		else
			RunConsoleCommand( "chsh_disable_preview", "1")
			disablePreview = true
			LoadPMShop()
		end
		
	end
	
	if(IsValid(SHHelpSign))then
		SHHelpSign:SetText("Purchase playermodels with credits, or using a playermodel coupon!")
		SHHelpSign:SizeToContents()
	end
	
end

local SHPMS = {}

SHPMS.id = "Playermodels"

function SHPMS:GetID()
	return self.id
end

function SHPMS:Open()
	SH:CloseAllTabs()
	BuildPMS()
end

function SHPMS:Close()
	if(IsValid(SHPlFrame))then
		SHPlFrame:Remove()
	end
end

local function Initialize()
	table.insert(SH.tabs, 1, SHPMS)
end
hook.Add("chsh_load_shop", "load_playermodel_shop", Initialize)