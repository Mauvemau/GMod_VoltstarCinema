
CHMenu = {}

CHMenu.categories = {}

local defaultTab = 1
local lastTab = defaultTab
local chMenuOpen = false

function CHMenu:AddElements()
	if(!IsValid(CHMenuFrame)) then return end
	
	--PaintFrame(CHMenuFrame)
	CHMenuFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color( 0, 0, 0, 200 ))
		Derma_DrawBackgroundBlur(self, SysTime())
	end
	
	local CloseButton = vgui.Create("DButton", CHMenuFrame)
	CloseButton:SetText("X")
	CloseButton:SetSize( CHMenuFrame:GetWide() * .04, CHMenuFrame:GetTall() * .03 )
	CloseButton:SetPos( CHMenuFrame:GetWide() * .957, CHMenuFrame:GetTall() * .008 )
	CloseButton:SetColor( Color(255, 255, 255, 255) )
	
	-- Stylizing.
	CloseButton.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 100, 100, 255 ) )
	end
	CloseButton.OnCursorEntered = function()
		CloseButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 10, 10, 255 ) )
		end
	end
	CloseButton.OnCursorExited = function()
		CloseButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 100, 100, 255 ) )
		end
	end
	CloseButton.DoClickInternal = function()
		CloseButton.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 10, 10, 255 ) )
		end
	end
	--
	
	CloseButton.DoClick = function()
		ApplyChanges()
		UpdateEquippedServer()
		self:Close()
	end
	
	Buttoner = vgui.Create("DPanel", CHMenuFrame)
	Buttoner:SetPos( 0, CHMenuFrame:GetTall() * .042 )
	Buttoner:SetSize( CHMenuFrame:GetWide() * 1, CHMenuFrame:GetTall() * .075 )
	PaintFrame(Buttoner)
	Buttoner.buttons = {}
	
	-- Am i on drugs? haha
	function Buttoner:UnselectAllButtons()
		for i = 1, table.Count(self.buttons) do
			ButtonToggleSelected(self.buttons[i], false)
		end
	end
	function Buttoner:SelectButton(index)
		ButtonToggleSelected(self.buttons[index], true)
	end
	
	local xpos = 0
	for i = 1, table.Count(self.categories) do
	
		local Button = vgui.Create("DButton", Buttoner)
		Button:SetText(self.categories[i]:GetID())
		Button:SetFont("chsh_category_buttons_font")
		Button:SetSize( Buttoner:GetWide() * .18, Buttoner:GetTall() * 1 )
		Button:SetPos(xpos, 0)
		xpos = xpos + Button:GetWide() * 1
		PaintButton(Button)
		Button.selected = false
		
		Button.DoClick = function()
			Buttoner:UnselectAllButtons()
			self.categories[i]:Open()
			Buttoner:SelectButton(i)
			lastTab = i
		end
		
		table.insert(Buttoner.buttons, Button)
	end
	
	local WalletPanel = vgui.Create("DPanel", Buttoner)
	WalletPanel:SetSize(Buttoner:GetWide() * .18, Buttoner:GetTall() * 1)
	WalletPanel:SetPos((Buttoner:GetWide() * 1) - WalletPanel:GetWide(), 0)
	PaintFrame(WalletPanel)
	WalletPanel.coins = {}
	
	local GeneralCurrencyPanel = vgui.Create("DPanel", WalletPanel)
	GeneralCurrencyPanel:SetSize(WalletPanel:GetWide() * 1, WalletPanel:GetTall() * .6)
	GeneralCurrencyPanel:SetPos(0, 0)
	GeneralCurrencyPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local CurrencyIcon = vgui.Create("DHTML", GeneralCurrencyPanel)
	CurrencyIcon:SetSize(GeneralCurrencyPanel:GetTall() - 4, GeneralCurrencyPanel:GetTall() - 4)
	CurrencyIcon:SetPos(5, 2)
	CreateWebTexturePanel(CurrencyIcon, currencyIco)
	
	local currentMoney = 0
	local lastMoney = currentMoney
	local displayMoney = lastMoney
	
	local AmountMoney = vgui.Create("DLabel", GeneralCurrencyPanel)
	AmountMoney:SetPos(5 + (CurrencyIcon:GetWide() + 5), 0)
	AmountMoney:SetFont("chsh_wallet_big")
	AmountMoney:SetText(displayMoney)
	AmountMoney:SetColor(Color(255, 255, 255, 255))
	AmountMoney:SizeToContents()
	
	local SecondaryCurrencyPanel = vgui.Create("DPanel", WalletPanel)
	SecondaryCurrencyPanel:SetSize(WalletPanel:GetWide() * 1, (WalletPanel:GetTall() * 1) - (GeneralCurrencyPanel:GetTall() * 1))
	SecondaryCurrencyPanel:SetPos(0, GeneralCurrencyPanel:GetTall() * 1)
	SecondaryCurrencyPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	PaintFrame(SecondaryCurrencyPanel)
	
	local offset = 0.3
	
	local CouponIcon = vgui.Create("DHTML", SecondaryCurrencyPanel)
	CouponIcon:SetSize(SecondaryCurrencyPanel:GetTall() * (1 + offset), SecondaryCurrencyPanel:GetTall() * (1 + offset))
	CouponIcon:SetPos(6,  0 - SecondaryCurrencyPanel:GetTall() * (offset * .5))
	CreateWebTexturePanel(CouponIcon, couponIco)
	
	local AmountCoupons = vgui.Create("DLabel", SecondaryCurrencyPanel)
	AmountCoupons:SetPos(6 + (CouponIcon:GetWide() + 5), 0)
	AmountCoupons:SetFont("chsh_wallet_small")
	AmountCoupons:SetText(GetPMCoupons(LocalPlayer()))
	AmountCoupons:SetColor(Color(255, 255, 255, 255))
	AmountCoupons:SizeToContents()
	--[[
	local EventCurrencyPanel = vgui.Create("DPanel", WalletPanel)
	EventCurrencyPanel:SetSize(WalletPanel:GetWide() * .5, (WalletPanel:GetTall() * 1) - (GeneralCurrencyPanel:GetTall() * 1))
	EventCurrencyPanel:SetPos(SecondaryCurrencyPanel:GetWide() * 1, GeneralCurrencyPanel:GetTall() * 1)
	EventCurrencyPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	]]
	
	function UpdateWalletInfo()
		if(!IsValid(WalletPanel))then return end
		
		currentMoney = GetCredits(LocalPlayer())
		if(lastMoney != currentMoney)then
			lastMoney = currentMoney
			displayMoney = ReplaceCommaWithDot(string.Comma(lastMoney))
			AmountMoney:SetText(displayMoney)
			AmountMoney:SizeToContents()
			AmountCoupons:SetText(GetPMCoupons(LocalPlayer()))
			AmountCoupons:SizeToContents()
			
			if(GetCredits(LocalPlayer()) > 100000)then
				WalletPanel:SetSize((CurrencyIcon:GetWide() + 12) + (AmountMoney:GetWide() * 1) + 10, Buttoner:GetTall() * 1)
			else
				WalletPanel:SetSize(Buttoner:GetWide() * .1, Buttoner:GetTall() * 1)
			end
			WalletPanel:SetPos((Buttoner:GetWide() * 1) - WalletPanel:GetWide(), 0)
			SecondaryCurrencyPanel:SetSize(WalletPanel:GetWide() * 1, (WalletPanel:GetTall() * 1) - (GeneralCurrencyPanel:GetTall() * 1))
		end
	end
	
	BottomBarPanel = vgui.Create("DPanel", CHMenuFrame)
	BottomBarPanel:SetSize(CHMenuFrame:GetWide() * 1, CHMenuFrame:GetTall() * .03)
	BottomBarPanel:SetPos(0, (CHMenuFrame:GetTall() * 1) - (BottomBarPanel:GetTall() * 1))
	BottomBarPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, backgroundColor)
	end
	
	local BottomLabel = vgui.Create("DLabel", BottomBarPanel)
	BottomLabel:SetPos(BottomBarPanel:GetWide() * .01, 0)
	BottomLabel:SetFont("chsh_bottombar_font")
	BottomLabel:SetText("Volt Interface v0.1.0 developed by Mau")
	BottomLabel:SetContentAlignment(4)
	BottomLabel:SizeToContents()
	BottomLabel:SetTall(BottomBarPanel:GetTall() * 1)
	BottomLabel:SetColor(Color(155, 155, 155, 255))
	
	local BottomButtoner = vgui.Create("DPanel", BottomBarPanel)
	BottomButtoner:SetSize(0, BottomBarPanel:GetTall() * 1)
	BottomButtoner:SetPos((BottomBarPanel:GetWide() * 1) - (BottomButtoner:GetWide() * 1), 0)
	BottomButtoner.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 100))
	end
	
	local buttonwide = BottomBarPanel:GetWide() * .08
	local bbxpos = 0
	BottomButtoner:SetWide(BottomButtoner:GetWide() + buttonwide + 1)
	BottomButtoner:SetPos((BottomBarPanel:GetWide() * 1) - (BottomButtoner:GetWide() * 1), 0)
	
	local DiscordButton = vgui.Create("DButton", BottomButtoner)
	DiscordButton:SetPos(bbxpos, 0)
	DiscordButton:SetSize(buttonwide, BottomButtoner:GetTall() * 1)
	DiscordButton:SetFont("chsh_bottombuttons_font")
	DiscordButton:SetText("Discord")
	PaintButtonSpecific(DiscordButton, Color(115, 138, 219, 255))
	
	DiscordButton.DoClick = function()
		gui.OpenURL("https://discord.com/invite/qJjKkXy")
		CHMenu:Close()
	end
	
	bbxpos = bbxpos + buttonwide + 4
	BottomButtoner:SetWide(BottomButtoner:GetWide() + buttonwide + 4)
	BottomButtoner:SetPos((BottomBarPanel:GetWide() * 1) - (BottomButtoner:GetWide() * 1), 0)
	
	local SteamGroupButton = vgui.Create("DButton", BottomButtoner)
	SteamGroupButton:SetPos(bbxpos, 0)
	SteamGroupButton:SetSize(buttonwide, BottomButtoner:GetTall() * 1)
	SteamGroupButton:SetFont("chsh_bottombuttons_font")
	SteamGroupButton:SetText("Steam Group")
	PaintButtonSpecific(SteamGroupButton, Color(102, 192, 244, 255))
	
	SteamGroupButton.DoClick = function()
		gui.OpenURL("https://steamcommunity.com/groups/voltstarcinema")
		CHMenu:Close()
	end
	--[[
	bbxpos = bbxpos + buttonwide + 4
	BottomButtoner:SetWide(BottomButtoner:GetWide() + buttonwide + 4)
	BottomButtoner:SetPos((BottomBarPanel:GetWide() * 1) - (BottomButtoner:GetWide() * 1), 0)
	
	local DonateButton = vgui.Create("DButton", BottomButtoner)
	DonateButton:SetPos(bbxpos, 0)
	DonateButton:SetSize(buttonwide, BottomButtoner:GetTall() * 1)
	DonateButton:SetFont("chsh_bottombar_font")
	DonateButton:SetText("Donate")
	PaintButtonSpecific(DonateButton, Color(200, 20, 20, 255))
	]]
	
end

function CHMenu:Create()

	local h = ScrH()
	local w = ScrH() * 1.8

	CHMenuFrame = vgui.Create("DFrame")
	CHMenuFrame:SetTitle("")
	CHMenuFrame:SetSize( w * .69, ScrH() * .8 )
	CHMenuFrame:Center()
	CHMenuFrame:SetDraggable(false)
	CHMenuFrame:ShowCloseButton(false)
	CHMenuFrame:MakePopup()
	
	self:AddElements()
	
	Buttoner:UnselectAllButtons()
	self.categories[lastTab]:Open() -- Opens the first of the list.
	Buttoner:SelectButton(lastTab)
end

function CHMenu:Destroy()
	if( IsValid(CHMenuFrame) ) then
		CHMenuFrame:Remove()
	end
end

function CHMenu:CloseAllTabs()
	for i = 1, table.Count(self.categories) do
		self.categories[i]:Close()
	end
end

function CHMenu:Open()
	if( chMenuOpen ) then self:Close() return end
	RunConsoleCommand("chsh_hud_draw", "0")
	if( table.Count(self.categories) > 1 )then
		chMenuOpen = true
		self:Create()
	else
		print("[CHShop] Missing categories, loading them...")
		self:LoadCategories()
	end
end
usermessage.Hook("chsh_open_chmenu", function() 
	CHMenu:Open()
end)

function CHMenu:Close()
	if( !chMenuOpen ) then return end
	RunConsoleCommand("chsh_hud_draw", "1")
	self:Destroy()
	chMenuOpen = false
end

function CHMenu:LoadCategories()
	table.Empty(self.categories)
	hook.Call("chsh_load_categories")
	if( table.Count(self.categories) > 1 )then
		print("[CHShop] Categories loaded! ".. table.Count(self.categories) .. " categories found." )
	else
		print("[CHShop] Error, there is no categories available!")
	end
end

function CHMenu:Initialize()
	self:LoadCategories()
end
hook.Add("Initialize", "chsh_init_menu", function()
	CHMenu:Initialize()
end)
concommand.Add("chsh_reload_shop", function(ply, cmd, args)
	LocalPlayer():ConCommand("sv_load_table")
	LocalPlayer():ConCommand("sv_load_inventory")
	CHMenu:Initialize()
	print("Shop refreshed.")
end)
CHMenu:Initialize()


function CHMenu:Update()
	if(!chMenuOpen) then return end
	UpdateWalletInfo()
	for k, v in pairs(self.categories)do
		if(v.Update)then
			v:Update()
		end
	end
end
hook.Add("HUDPaint", "chsh_menu_update", function()
	CHMenu:Update()
end)
