
PURCHASE = {}

local purchasing = false

function PURCHASE:Failure(msg)
	if(!IsValid(PurchaseFrame)) then return end
	if(PurchaseFrame.current != nil)then PurchaseFrame.current:Remove() end
	
	local FailPanel = vgui.Create("DPanel", PurchaseFrame)
	FailPanel:SetPos(0, 0)
	FailPanel:SetSize(PurchaseFrame:GetWide() * 1, PurchaseFrame:GetTall() * 1)
	FailPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	PurchaseFrame.current = FailPanel
	
	local Label1 = vgui.Create("DLabel", FailPanel)
	Label1:SetPos(FailPanel:GetWide() * .1, FailPanel:GetTall() * .3)
	Label1:SetSize(FailPanel:GetWide() * .8, FailPanel:GetTall() * .1)
	Label1:SetContentAlignment(8)
	Label1:SetFont("chsh_purchasing_font")
	Label1:SetText("Purchase Failed")
	Label1:SetColor(Color(255, 20, 20, 255))
	
	local Label2 = vgui.Create("DLabel", FailPanel)
	Label2:SetPos(FailPanel:GetWide() * .1, FailPanel:GetTall() * .38)
	Label2:SetSize(FailPanel:GetWide() * .8, FailPanel:GetTall() * .1)
	Label2:SetAutoStretchVertical(true)
	Label2:SetContentAlignment(8)
	Label2:SetFont("chsh_purchase_error_font")
	Label2:SetText(msg)
	Label2:SetColor(Color(255, 255, 255, 255))
	
	local CloseButton = vgui.Create("DButton", FailPanel)
	CloseButton:SetPos(FailPanel:GetWide() * .3, FailPanel:GetTall() * .85)
	CloseButton:SetSize(FailPanel:GetWide() * .4, FailPanel:GetTall() * .1)
	CloseButton:SetFont("chsh_bg_font")
	CloseButton:SetText("Close")
	PaintButtonSpecific(CloseButton, Color(255, 20, 20, 255))
	
	CloseButton.DoClick = function()
		PURCHASE:Close()
	end
	
end
net.Receive("chsh_purchase_failure", function()
	local msg = net.ReadString()
	PURCHASE:Failure(msg)
end)

function PURCHASE:ConfirmPurchase(id)
	if(!IsValid(PurchaseFrame)) then return end
	if(PurchaseFrame.current != nil)then PurchaseFrame.current:Remove() end
	
	local item = itemDB[FindItemByID(id)]
	
	local ConfirmPanel = vgui.Create("DPanel", PurchaseFrame)
	ConfirmPanel:SetPos(0, 0)
	ConfirmPanel:SetSize(PurchaseFrame:GetWide() * 1, PurchaseFrame:GetTall() * 1)
	ConfirmPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	PurchaseFrame.current = ConfirmPanel
	
	local Label1 = vgui.Create("DLabel", ConfirmPanel)
	Label1:SetPos(ConfirmPanel:GetWide() * .1, ConfirmPanel:GetTall() * .3)
	Label1:SetSize(ConfirmPanel:GetWide() * .8, ConfirmPanel:GetTall() * .1)
	Label1:SetContentAlignment(8)
	Label1:SetFont("chsh_purchasing_font")
	Label1:SetText("Success!")
	Label1:SetColor(Color(20, 255, 20, 255))
	
	local Label2 = vgui.Create("DLabel", ConfirmPanel)
	Label2:SetPos(ConfirmPanel:GetWide() * .1, ConfirmPanel:GetTall() * .38)
	Label2:SetSize(ConfirmPanel:GetWide() * .8, ConfirmPanel:GetTall() * .1)
	Label2:SetContentAlignment(8)
	Label2:SetFont("chsh_shop_title_font")
	Label2:SetText("You purchased ".. item.name ..".")
	Label2:SetColor(Color(255, 255, 255, 255))
	
	local ReturnButton = vgui.Create("DButton", ConfirmPanel)
	ReturnButton:SetPos( ConfirmPanel:GetWide() * .55, ConfirmPanel:GetTall() * .85 )
	ReturnButton:SetSize( ConfirmPanel:GetWide() * .4, ConfirmPanel:GetTall() * .1 )
	ReturnButton:SetFont("chsh_bg_font")
	ReturnButton:SetText("Return to Shop")
	PaintButton(ReturnButton)
	
	ReturnButton.DoClick = function()
		CHMenu:Close()
		CHMenu:Open()
		PURCHASE:Close()
	end
	
	if(item.iType == "playermodel")then
		local EquipButton = vgui.Create("DButton", ConfirmPanel)
		EquipButton:SetPos( ConfirmPanel:GetWide() * .05, ConfirmPanel:GetTall() * .85 )
		EquipButton:SetSize( ConfirmPanel:GetWide() * .4, ConfirmPanel:GetTall() * .1 )
		EquipButton:SetFont("chsh_bg_font")
		EquipButton:SetText("Equip Playermodel")
		PaintButtonSpecific(EquipButton, Color(20, 255, 20, 255))
		
		EquipButton.DoClick = function()
			pmSelected = item.reference
			if(!IsValid(PlayermodelView)) then return end
			PlayermodelView:SetModel(item.reference)
			skSelected = LocalPlayer():GetSkin()
			bgSelected = {}
			RunConsoleCommand( "cl_playerbodygroups", "0" )
			RunConsoleCommand( "cl_playerskin", "0" )
		
			CHMenu:Close()
			CHMenu:Open()
			PURCHASE:Close()
		end
	elseif(item.iType == "swep")then
		local EquipButton = vgui.Create("DButton", ConfirmPanel)
		EquipButton:SetPos( ConfirmPanel:GetWide() * .05, ConfirmPanel:GetTall() * .85 )
		EquipButton:SetSize( ConfirmPanel:GetWide() * .4, ConfirmPanel:GetTall() * .1 )
		EquipButton:SetFont("chsh_bg_font")
		EquipButton:SetText("Equip Item")
		PaintButtonSpecific(EquipButton, Color(20, 255, 20, 255))
		
		EquipButton.DoClick = function()
			EquipSingleServer(item.uid)
			CHMenu:Close()
			CHMenu:Open()
			PURCHASE:Close()
		end
		
	else
	
	end
	
end
net.Receive("chsh_confirm_purchase", function()
	local id = tonumber(net.ReadString())
	PURCHASE:ConfirmPurchase(id)
end)


function PURCHASE:SetPurchasing()
	if(!IsValid(PurchaseFrame)) then return end
	if(PurchaseFrame.current != nil)then PurchaseFrame.current:Remove() end
	
	local PurchasingPanel = vgui.Create("DPanel", PurchaseFrame)
	PurchasingPanel:SetPos(0, 0)
	PurchasingPanel:SetSize(PurchaseFrame:GetWide() * 1, PurchaseFrame:GetTall() * 1)
	PurchasingPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	PurchaseFrame.current = PurchasingPanel
	
	local Label1 = vgui.Create("DLabel", PurchasingPanel)
	Label1:SetPos(PurchasingPanel:GetWide() * .1, PurchasingPanel:GetTall() * .4)
	Label1:SetSize(PurchasingPanel:GetWide() * .8, PurchasingPanel:GetTall() * .1)
	Label1:SetContentAlignment(8)
	Label1:SetFont("chsh_purchasing_font")
	Label1:SetText("Purchasing...")
	Label1:SetColor(Color(255, 255, 255, 255))
	
	timer.Simple(8, function()
		if(!IsValid(PurchasingPanel))then return end
		Label1:SetText("Server is not responding.")
		Label1:SetColor(Color(255, 20, 20, 255))
		
		local CloseButton = vgui.Create("DButton", PurchasingPanel)
		CloseButton:SetPos(PurchasingPanel:GetWide() * .3, PurchasingPanel:GetTall() * .85)
		CloseButton:SetSize(PurchasingPanel:GetWide() * .4, PurchasingPanel:GetTall() * .1)
		CloseButton:SetFont("chsh_bg_font")
		CloseButton:SetText("Close")
		PaintButtonSpecific(CloseButton, Color(255, 20, 20, 255))
		
		CloseButton.DoClick = function()
			PURCHASE:Close()
		end
	end)
	
end

function PURCHASE:AddElements(itemID, coupon)
	if(!IsValid(PurchaseFrame)) then return end
	if(PurchaseFrame.current != nil)then PurchaseFrame.current:Remove() end
	
	local item = itemDB[FindItemByID(itemID)]
	local funds = GetCredits(LocalPlayer())
	local fundsAfterPurchase = funds - item.price
	
	BackScreen.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	end
	
	PaintFrameBlur(PurchaseFrame)
	
	local separator = "a"
	if(string.StartWith("a" or "i", string.lower(item.iType)))then separator = "an" end
	
	local PurchasePanel = vgui.Create("DPanel", PurchaseFrame)
	PurchasePanel:SetPos(0, 0)
	PurchasePanel:SetSize(PurchaseFrame:GetWide() * 1, PurchaseFrame:GetTall() * 1)
	PurchasePanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	PurchaseFrame.current = PurchasePanel
	
	local Label1 = vgui.Create("DLabel", PurchasePanel)
	Label1:SetPos(PurchasePanel:GetWide() * .1, PurchasePanel:GetTall() * .05)
	Label1:SetSize(PurchasePanel:GetWide() * .8, PurchasePanel:GetTall() * .1)
	Label1:SetContentAlignment(8)
	Label1:SetFont("chsh_purchase_font")
	Label1:SetText("You're purchasing ".. separator .." ".. item.iType)
	Label1:SetColor(Color(255, 255, 255, 255))
	
	local Label2 = vgui.Create("DLabel", PurchasePanel)
	Label2:SetPos(PurchasePanel:GetWide() * .1, PurchasePanel:GetTall() * .2)
	Label2:SetSize(PurchasePanel:GetWide() * .8, PurchasePanel:GetTall() * .1)
	Label2:SetContentAlignment(8)
	Label2:SetFont("chsh_purchase_font")
	Label2:SetText(item.name)
	Label2:SetColor(borderColor)
	
	local IconSlot = vgui.Create("DPanel", PurchasePanel)
	IconSlot:SetPos(PurchasePanel:GetWide() * .4, PurchasePanel:GetTall() * .27)
	IconSlot:SetSize(PurchasePanel:GetWide() * .2, PurchasePanel:GetWide() * .2)
	PaintFrame(IconSlot)
	
	if(item.iType == "playermodel")then
		local Icon = vgui.Create("SpawnIcon", IconSlot)
		Icon:SetModel(item.reference)
		Icon:SetPos(2, 2)
		Icon:SetSize(IconSlot:GetTall() - 4, IconSlot:GetTall() - 4)
		Icon:SetTooltip("Could use some bread here...")
	else
		local Icon = vgui.Create("DImage", IconSlot)
		Icon:SetImage("vgui/entities/".. item.reference)
		Icon:SetPos(2, 2)
		Icon:SetSize(IconSlot:GetTall() - 4, IconSlot:GetTall() - 4)
		Icon:SetTooltip("This looks interesting, hope you don't mind if i nibble on it...")
	end
	
	local PriceSlot = vgui.Create("DPanel", PurchasePanel)
	PriceSlot:SetPos(0, 0)
	PriceSlot:SetSize(0, PurchasePanel:GetTall() * .05)
	PriceSlot.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end

	local CurrencyIco = vgui.Create("DHTML", PriceSlot)
	CurrencyIco:SetPos(0, 0)
	CurrencyIco:SetSize(PriceSlot:GetTall() * 1, PriceSlot:GetTall() * 1)
	if(!coupon)then
		CreateWebTexturePanel(CurrencyIco, currencyIco)
	else
		CreateWebTexturePanel(CurrencyIco, couponIco)
	end
	
	local Price = vgui.Create("DLabel", PriceSlot)
	Price:SetPos((CurrencyIco:GetWide() * 1) + 5, 0)
	Price:SetFont("chsh_bg_font")
	if(!coupon)then
		Price:SetText(ReplaceCommaWithDot(string.Comma(item.price)))
		Price:SizeToContents()
		Price:SetWide((Price:GetWide() * 1) + (CurrencyIco:GetWide() * .5))
	else
		Price:SetText("Coupon")
		Price:SizeToContents()
	end
	--Price:SetContentAlignment(4)
	Price:SetColor(Color(255, 255, 255, 255))
	
	PriceSlot:SetWide((CurrencyIco:GetWide() * 1) + 5 + (Price:GetWide() * 1))
	PriceSlot:SetPos((PurchasePanel:GetWide() - PriceSlot:GetWide()) / 2, PurchasePanel:GetTall() * .46)
	
	local Label3 = vgui.Create("DLabel", PurchasePanel)
	Label3:SetPos(PurchasePanel:GetWide() * .1, PurchasePanel:GetTall() * .65)
	Label3:SetSize(PurchasePanel:GetWide() * .8, PurchasePanel:GetTall() * .1)
	Label3:SetContentAlignment(8)
	Label3:SetFont("chsh_purchase_description_font")
	Label3:SetColor(Color(100, 100, 100, 255))
	
	local Label4 = vgui.Create("DLabel", PurchasePanel)
	Label4:SetPos(PurchasePanel:GetWide() * .1, PurchasePanel:GetTall() * .69)
	Label4:SetSize(PurchasePanel:GetWide() * .8, PurchasePanel:GetTall() * .1)
	Label4:SetContentAlignment(8)
	Label4:SetFont("chsh_purchase_description_font")
	Label4:SetColor(Color(100, 100, 100, 255))
	
	if(!coupon)then
		Label3:SetText("You currently have ".. ReplaceCommaWithDot(string.Comma(funds)) .." credits.")
		
		Label4:SetText("You will have ".. ReplaceCommaWithDot(string.Comma(fundsAfterPurchase)) .." credits left after purchase.")
	else
		Label3:SetText("You're purchasing this ".. item.iType .." using a coupon!")
		
		Label4:SetText("You have ".. GetPMCoupons(LocalPlayer()) .." coupons.")
	end
	
	local PriceSlot2 = vgui.Create("DPanel", PurchasePanel)
	PriceSlot2:SetPos(0, 0)
	PriceSlot2:SetSize(0, PurchasePanel:GetTall() * .05)
	PriceSlot2.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end

	local CurrencyIco2 = vgui.Create("DHTML", PriceSlot2)
	CurrencyIco2:SetPos(0, 0)
	CurrencyIco2:SetSize(PriceSlot2:GetTall() * 1, PriceSlot2:GetTall() * 1)
	if(!coupon)then
		CreateWebTexturePanel(CurrencyIco2, currencyIco)
	else
		CreateWebTexturePanel(CurrencyIco2, couponIco)
	end
	
	local Price2 = vgui.Create("DLabel", PriceSlot2)
	Price2:SetPos((CurrencyIco:GetWide() * 1) + 5, 0)
	Price2:SetFont("chsh_bg_font")
	if(!coupon)then
		Price2:SetText(ReplaceCommaWithDot(string.Comma(item.price)))
	else
		Price2:SetText("Coupon")
	end
	Price2:SetContentAlignment(4)
	Price2:SetColor(Color(255, 255, 255, 255))
	Price2:SizeToContents()

	local CloseButton = vgui.Create("DButton", PurchasePanel)
	CloseButton:SetPos( PurchasePanel:GetWide() * .55, PurchasePanel:GetTall() * .85 )
	CloseButton:SetSize( PurchasePanel:GetWide() * .4, PurchasePanel:GetTall() * .1 )
	CloseButton:SetFont("chsh_bg_font")
	CloseButton:SetText("Cancel")
	PaintButtonSpecific(CloseButton, Color(255, 20, 20, 255))
	
	CloseButton.DoClick = function()
		PURCHASE:Close()
	end
	
	local PurchaseButton = vgui.Create("DButton", PurchasePanel)
	PurchaseButton:SetPos( PurchasePanel:GetWide() * .05, PurchasePanel:GetTall() * .85 )
	PurchaseButton:SetSize( PurchasePanel:GetWide() * .4, PurchasePanel:GetTall() * .1 )
	PurchaseButton:SetFont("chsh_bg_font")
	PurchaseButton:SetText("Purchase")
	PaintButton(PurchaseButton)
	
	PriceSlot2:SetWide((CurrencyIco2:GetWide() * 1) + 5 + (Price2:GetWide() * 1))
	PriceSlot2:SetPos((PurchaseButton:GetWide() * 1.2 - PriceSlot2:GetWide()) / 2, PurchasePanel:GetTall() * .79)
	
	if(!coupon)then
		PurchaseButton.DoClick = function()
			self:SetPurchasing()
			
			net.Start("chsh_purchase_item")
				net.WriteString(itemID)
			net.SendToServer()
		end
	else
		PurchaseButton.DoClick = function()
			self:SetPurchasing()
			
			net.Start("chsh_purchase_with_coupon")
				net.WriteString(itemID)
			net.SendToServer()
		end
	end

end

function PURCHASE:Create(itemID, coupon)
	if(!ItemExists(itemID)) then self:Close() return end
	
	local h = ScrH()
	local w = ScrH() * 1.8

	BackScreen = vgui.Create("DFrame")
	BackScreen:SetTitle("")
	BackScreen:SetSize(ScrW() * 1, ScrH() * 1)
	BackScreen:SetDraggable(false)
	BackScreen:ShowCloseButton(false)
	BackScreen:MakePopup()

	PurchaseFrame = vgui.Create("DPanel", BackScreen)
	PurchaseFrame:SetSize( w * .25, h * .5 )
	PurchaseFrame:Center()
	PurchaseFrame.current = nil
	
	self:AddElements(itemID, coupon)
	
end

function PURCHASE:Destroy()
	if(IsValid(BackScreen)) then
		BackScreen:Remove()
	end
end

function PURCHASE:Open(itemID, coupon)
	if(purchasing) then self:Close() return end

	purchasing = true
	self:Create(itemID, coupon)
end

function PURCHASE:Close()
	if( !purchasing ) then return end
	self:Destroy()
	purchasing = false
end