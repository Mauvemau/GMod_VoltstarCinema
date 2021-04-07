
-- item_db

local function AddNewItem(item)
	net.Start("chsh_add_new_item")
		net.WriteTable(item)
	net.SendToServer()
end

local function EditExistingItem(item)
	if(!ItemExists(item.uid))then print("Fake item bruh.") return end
	net.Start("chsh_edit_item")
		net.WriteString(item.uid)
		net.WriteTable(item)
	net.SendToServer()
end

-- Add
local function AddEditItem(id)
	if(!IsValid(AdminFrame))then return end
	if(AdminFrame.current != nil)then AdminFrame.current:Remove() end
	
	local itemsVar = {
		enabled = false,
		name = "",
		description = "",
		iType = "swep",
		price = 0,
		reference = ""
		--icon = ""
	}
	
	if(id)then
		if(!ItemExists(id))then return end
		table.Empty(itemsVar)
		itemsVar = GetItemByID(id)
	end
	
	local NewItemFrame = vgui.Create("DPanel", AdminFrame)
	AdminFrame.current = NewItemFrame
	NewItemFrame:SetPos(0,0)
	NewItemFrame:SetSize(AdminFrame:GetWide() * 1, AdminFrame:GetTall() * 1)
	NewItemFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local text = vgui.Create("DLabel", NewItemFrame)
	text:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .01)
	text:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	text:SetText("Add new item")
	text:SetFont("chsh_bg_font")
	text:SetColor(borderColor)
	
	local nameText = vgui.Create("DLabel", NewItemFrame)
	nameText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .1)
	nameText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	nameText:SetText("Name")
	nameText:SetColor(Color(255,255,255,255))
	
	local nameInput = vgui.Create("DTextEntry", NewItemFrame)
	nameInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .125)
	nameInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	nameInput:SetValue(itemsVar.name)
	
	local descriptionText = vgui.Create("DLabel", NewItemFrame)
	descriptionText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .2)
	descriptionText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	descriptionText:SetText("Description")
	descriptionText:SetColor(Color(255,255,255,255))
	
	local descriptionInput = vgui.Create("DTextEntry", NewItemFrame)
	descriptionInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .225)
	descriptionInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	descriptionInput:SetValue(itemsVar.description)
	
	local typeText = vgui.Create("DLabel", NewItemFrame)
	typeText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .3)
	typeText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	typeText:SetText("Type")
	typeText:SetColor(Color(255,255,255,255))
	
	local typeInput = vgui.Create("DComboBox", NewItemFrame)
	typeInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .325)
	typeInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	typeInput:SetValue(itemsVar.iType)
	typeInput:AddChoice("swep")
	typeInput:AddChoice("playermodel")
	--typeInput:AddChoice("usable - (Not available)")
	typeInput:AddChoice("accessory")
	--typeInput:AddChoice("pet - (Not available)")
	
	local enabledTest = vgui.Create("DLabel", NewItemFrame)
	enabledTest:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .4)
	enabledTest:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	enabledTest:SetText("Active")
	enabledTest:SetColor(Color(255,255,255,255))
	
	local checkbox = vgui.Create("DCheckBox", NewItemFrame)
	checkbox:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .435)
	checkbox:SetValue(itemsVar.enabled)
	
	local priceText = vgui.Create("DLabel", NewItemFrame)
	priceText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .5)
	priceText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	priceText:SetText("Price")
	priceText:SetColor(Color(255,255,255,255))
	
	local priceInput = vgui.Create("DNumberWang", NewItemFrame)
	priceInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .525)
	priceInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	priceInput:SetMin(0)
	priceInput:SetMax(30000)
	priceInput:SetDecimals(0)
	priceInput:SetValue(itemsVar.price)
	
	local referenceText = vgui.Create("DLabel", NewItemFrame)
	referenceText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .6)
	referenceText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	referenceText:SetText("Reference")
	referenceText:SetColor(Color(255,255,255,255))
	
	local referenceInput = vgui.Create("DTextEntry", NewItemFrame)
	referenceInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .625)
	referenceInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	referenceInput:SetValue(itemsVar.reference)
	--[[
	local iconText = vgui.Create("DLabel", NewItemFrame)
	iconText:SetPos(NewItemFrame:GetWide() * .05, NewItemFrame:GetTall() * .7)
	iconText:SetSize(NewItemFrame:GetWide() * .4, NewItemFrame:GetTall() * .1)
	iconText:SetText("Custom Icon (Optional)")
	iconText:SetColor(Color(255,255,255,255))
	
	local iconInput = vgui.Create("DTextEntry", NewItemFrame)
	iconInput:SetPos(NewItemFrame:GetWide() * .25, NewItemFrame:GetTall() * .725)
	iconInput:SetSize(NewItemFrame:GetWide() * .3, NewItemFrame:GetTall() * .05)
	iconInput:SetValue(itemsVar.icon or "")
	]]
	local AddButton = vgui.Create("DButton", NewItemFrame)
	AddButton:SetPos(NewItemFrame:GetWide() * .35, NewItemFrame:GetTall() * .85)
	AddButton:SetSize(NewItemFrame:GetWide() * .2, NewItemFrame:GetTall() * .05)
	AddButton:SetText("Add")
	if(id)then
		AddButton:SetText("Edit")
	end
	AddButton:SetFont("chsh_bg_font")
	PaintButton(AddButton)
	
	function SetValues()
		itemsVar.enabled = checkbox:GetChecked()
		itemsVar.name = nameInput:GetValue()
		itemsVar.description = descriptionInput:GetValue()
		itemsVar.iType = typeInput:GetValue()
		itemsVar.price = priceInput:GetValue()
		itemsVar.reference = referenceInput:GetValue()
		--itemsVar.icon = iconInput:GetValue()
	end
	
	AddButton.DoClick = function()
		SetValues()
		if(!id)then
			AddNewItem(itemsVar)
		else
			EditExistingItem(itemsVar)
		end
	end
	
end

local function DatabaseManager()
	if(!IsValid(AdminFrame))then return end
	if(AdminFrame.current != nil)then AdminFrame.current:Remove() end
	
	local DatabasePanel = vgui.Create("DPanel", AdminFrame)
	AdminFrame.current = DatabasePanel
	DatabasePanel:SetPos(0,0)
	DatabasePanel:SetSize(AdminFrame:GetWide() * 1, AdminFrame:GetTall() * 1)
	DatabasePanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local ItemList = vgui.Create("DListView", DatabasePanel)
	ItemList:Dock(FILL)
	ItemList:SetMultiSelect(false)
	ItemList:AddColumn("ID")
	ItemList:AddColumn("Enabled")
	ItemList:AddColumn("Name")
	ItemList:AddColumn("Type")
	ItemList:AddColumn("Price")
	ItemList:AddColumn("Reference")
	
	if(!itemDB)then return end
	if(table.Count(itemDB) < 1)then return end
	
	for k, v in pairs(itemDB) do
		ItemList:AddLine(tonumber(v.uid), v.enabled, v.name, v.iType, v.price, v.reference)
	end
	
	ItemList.DoDoubleClick = function(lineID, line)
		AddEditItem(ItemList:GetLine(line):GetValue(1))
	end
end

local function BuildSHAdmin()
	if(!IsValid(SHTabsPanel))then return end
	
	SHAdminFrame = vgui.Create("DPanel", SHTabsPanel)
	SHAdminFrame:SetSize( SHTabsPanel:GetWide() * 1, SHTabsPanel:GetTall() * 1 )
	SHAdminFrame:SetPos( 0, 0)
	SHAdminFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local scroll = vgui.Create("DScrollPanel", SHAdminFrame)
	scroll:SetPos(SHAdminFrame:GetWide() * .01, SHAdminFrame:GetTall() * .01)
	scroll:SetSize(SHAdminFrame:GetWide() * .28, SHAdminFrame:GetTall() * .98)
	scroll.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	local ypos = 0
	
	AdminFrame = vgui.Create("DPanel", SHAdminFrame)
	AdminFrame:SetPos(SHAdminFrame:GetWide() * .295, SHAdminFrame:GetTall() * .01)
	AdminFrame:SetSize(SHAdminFrame:GetWide() * .695, SHAdminFrame:GetTall() * .98)
	PaintFrame(AdminFrame)
	AdminFrame.current = nil
	
	local DatabaseButton = vgui.Create("DButton", scroll)
	DatabaseButton:SetPos(0, ypos)
	DatabaseButton:SetSize(scroll:GetWide() * 1, SHAdminFrame:GetTall() * .12)
	DatabaseButton:SetFont("chsh_bg_font")
	DatabaseButton:SetText("Item Manager")
	PaintButton(DatabaseButton)
	
	ypos = ypos + DatabaseButton:GetTall() * 1.1
	
	
	DatabaseButton.DoClick = function()
		DatabaseManager()
	end
	
	local ItemAddButton = vgui.Create("DButton", scroll)
	ItemAddButton:SetPos(0, ypos)
	ItemAddButton:SetSize(scroll:GetWide() * 1, SHAdminFrame:GetTall() * .12)
	ItemAddButton:SetFont("chsh_bg_font")
	ItemAddButton:SetText("Add New Item")
	PaintButton(ItemAddButton)
	
	ypos = ypos + ItemAddButton:GetTall() * 1.1
	
	ItemAddButton.DoClick = function()
		AddEditItem(false)
	end
	
	
	if(IsValid(SHHelpSign))then
		SHHelpSign:SetText("Admin panel for the shop, if you aren't an admin then you aren't supposed to be seeing this. Report bugs below.")
		SHHelpSign:SizeToContents()
	end
	
end

local SHADMIN = {}

SHADMIN.id = "Admin Panel"

function SHADMIN:GetID()
	return self.id
end

function SHADMIN:Open()
	SH:CloseAllTabs()
	BuildSHAdmin()
end

function SHADMIN:Close()
	if(IsValid(SHAdminFrame))then
		SHAdminFrame:Remove()
	end
end

local function Initialize()
	if(CHIsAdmin(LocalPlayer()))then
		table.insert(SH.tabs, SHADMIN)
	end
end
hook.Add("chsh_load_shop", "load_admin", Initialize)