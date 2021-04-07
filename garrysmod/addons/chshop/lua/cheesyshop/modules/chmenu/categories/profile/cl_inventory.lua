
local function BuildInventory() -- myEquippedItems
	if(!IsValid(PFTabsPanel))then return end
	
	InvFrame = vgui.Create("DPanel", PFTabsPanel)
	InvFrame:SetSize( PFTabsPanel:GetWide() * 1, PFTabsPanel:GetTall() * 1 )
	InvFrame:SetPos( 0, 0)
	InvFrame.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	-- Settings
	local slotsize = 17.5
	local maxRow = 8
	local currentColumn = 1
	local defaultAmountSlots = 48
	--
	local amountItems = table.Count(eqInventoryCL)
	local amountEmptySlots = defaultAmountSlots - amountItems
	
	
	slotsize = slotsize * .01
	
	local Scroll = vgui.Create("DScrollPanel", InvFrame)
	Scroll:SetPos( InvFrame:GetWide() * .01, InvFrame:GetTall() * .015)
	Scroll:SetSize( InvFrame:GetWide() * .99, InvFrame:GetTall() * .975)
	
	local ypos = 0
	local xpos = 0
	
	local function LoadInventory()
		if(!IsValid(InvFrame))then return end
		if(!IsValid(Scroll))then return end
		Scroll:GetCanvas():Clear()
		
		RefreshEquipLocal()
		
		amountItems = table.Count(eqInventoryCL)
		amountEmptySlots = defaultAmountSlots - amountItems
		ypos = 0
		xpos = 0
		for k, v in pairs(eqInventoryCL)do
		
			local item = GetItemByID(v.uid)
		
			-- Slot
			local Slot = vgui.Create("DPanel", Scroll)
			Slot:SetPos( xpos, ypos)
			Slot:SetSize(InvFrame:GetTall() * slotsize, InvFrame:GetTall() * slotsize)
			if(IsEquipped(v.uid))then
				PaintFrameSpecific(Slot, Color(255, 255, 0, 255))
			else
				PaintFrame(Slot)
			end
			
			local SlotImage = vgui.Create("DImage", Slot)
			SlotImage:SetPos(2, 2)
			SlotImage:SetSize(Slot:GetWide() - 4, Slot:GetTall() -4)
			SlotImage:SetImage("vgui/entities/".. item.reference)
			
			local ELabel = vgui.Create("DLabel", Slot)
			ELabel:SetPos(0, 0)
			ELabel:SetFont("chsh_inventory_font")
			ELabel:SetText("E")
			ELabel:SizeToContents()
			ELabel:SetColor(Color(255, 255, 0, 255))
			ELabel:SetPos((Slot:GetWide() * 1) - (ELabel:GetWide() * 1.7), (Slot:GetTall() * 1) - (ELabel:GetTall() * 1))
			ELabel:SetVisible(IsEquipped(v.uid))
			
			-- Button
			local SlotButton = vgui.Create("DButton", Scroll)
			SlotButton:SetPos( xpos, ypos)
			SlotButton:SetSize(InvFrame:GetTall() * slotsize, InvFrame:GetTall() * slotsize)
			SlotButton:SetText("")
			PaintImageButton(SlotButton)
			SlotButton:SetTooltip(item.name .." (".. item.description ..")")
			
			SlotButton.stats = true
			function SlotButton:ShowStatsWindow()
				statsWindow = true
				--print("Showing stats")
			end
			function SlotButton:HideStatsWindow()
				if(statsWindow)then
					statsWindow = false
					--print("Hiding stats")
				end
			end
			
			SlotButton.DoClick = function()
				if(IsEquipped(v.uid))then
					UnequipLocal(v.uid)
					PaintFrameSpecific(Slot, borderColor)
					ELabel:SetVisible(false)
				else
					EquipLocal(v.uid)
					PaintFrameSpecific(Slot, Color(255, 255, 0, 255))
					ELabel:SetVisible(true)
				end
			end
			SlotButton.DoRightClick = function()
				SlotButton:ShowStatsWindow()
			end
			
			xpos = xpos + Slot:GetWide() * 1.05
			currentColumn = currentColumn + 1
			if(currentColumn > maxRow) then
				xpos = 0
				currentColumn = 1
				ypos = ypos + Slot:GetTall() * 1.05
			end
		end
		
		for i = 1, amountEmptySlots do
			local Slot = vgui.Create("DPanel", Scroll)
			Slot:SetPos( xpos, ypos)
			Slot:SetSize(InvFrame:GetTall() * slotsize, InvFrame:GetTall() * slotsize)
			PaintFrameSpecific(Slot, Color(100, 100, 100))
			
			local SlotButton = vgui.Create("DButton", Scroll)
			SlotButton:SetPos( xpos, ypos)
			SlotButton:SetSize(InvFrame:GetTall() * slotsize, InvFrame:GetTall() * slotsize)
			SlotButton:SetText("")
			PaintImageButton(SlotButton)
		
			xpos = xpos + Slot:GetWide() * 1.05
			currentColumn = currentColumn + 1
			if(currentColumn > maxRow) then
				xpos = 0
				currentColumn = 1
				ypos = ypos + Slot:GetTall() * 1.05
			end
		end
	end
	LoadInventory()
	hook.Add("chsh_refresh_local_inv", "Refresh Inventory", LoadInventory)
	
	if(IsValid(PFHelpSign))then
		PFHelpSign:SetText("All of your EQUIPPABLE items and sweps. [LEFT CLICK] To equip or unequip an item.")
		PFHelpSign:SizeToContents()
	end
	
end

local INVENTORY = {}

INVENTORY.id = "Inventory"

function INVENTORY:GetID()
	return self.id
end

function INVENTORY:Open()
	PF:CloseAllTabs()
	BuildInventory()
end

function INVENTORY:Close()
	if(IsValid(InvFrame))then
		InvFrame:Remove()
	end
end

local function Initialize()
	table.insert(PF.tabs, 2, INVENTORY)
end
hook.Add("chsh_load_profile", "load_inventory", Initialize)