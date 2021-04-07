-- Global
eqInventoryCL = {} -- Equippables
pmInventoryCL = {} -- Playermodels
acInventoryCL = {} -- Accessories

myEquippedItems = {}

local madeChanges = false

function EquipSingleServer(itemID)
	
	net.Start("chsh_equip_single_item")
		net.WriteString(itemID)
	net.SendToServer()
end

function UpdateEquippedServer()
	if(!madeChanges)then return end
	local equips = util.TableToJSON(myEquippedItems)
	
	net.Start("chsh_equip_multiple_items")
		net.WriteString(equips)
	net.SendToServer()
end

function IsEquipped(itemID)
	for k, v in pairs(myEquippedItems)do
		if(tonumber(v) == tonumber(itemID))then return true end
	end
	
	return false
end

function EquipLocal(itemID)
	if(!ItemExists(itemID))then return end
	if(!OwnsItem(LocalPlayer(), itemID))then return end
	if(IsEquipped(itemID))then return end
	
	table.insert(myEquippedItems, itemID)
	madeChanges = true
end

function UnequipLocal(itemID)
	if(!IsEquipped(itemID))then return end
	
	for k, v in pairs(myEquippedItems)do
		if(v == itemID)then 
			table.remove(myEquippedItems, k)
		end
	end
	madeChanges = true
end

function RefreshEquipLocal()
	table.Empty(myEquippedItems)

	for k, v in pairs(eqInventoryCL)do
		if(v.equipped)then
			EquipLocal(v.uid)
		end
	end
	
	madeChanges = false
end

function GetAllOwnedModels()
	local models = {}
	
	for k, v in pairs(pmInventoryCL) do
		if(!ItemExists(v.uid))then return end
		item = GetItemByID(v.uid)
		if(item.iType == "playermodel")then
			table.insert(models, item)
		end
	end
	
	return models
end

local function RefreshLocalInventory(eq, pm, ac)
	eqInventoryCL = util.JSONToTable(eq)
	pmInventoryCL = util.JSONToTable(pm)
	acInventoryCL = util.JSONToTable(ac)
	hook.Call("chsh_refresh_local_inv")
end
net.Receive("chsh_refresh_inventory", function()
	local eqString = net.ReadString()
	local pmString = net.ReadString()
	local acString = net.ReadString()
	RefreshLocalInventory(eqString, pmString, acString)
end)