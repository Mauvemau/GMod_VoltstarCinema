util.AddNetworkString("chsh_refresh_inventory")
util.AddNetworkString("chsh_equip_multiple_items")
util.AddNetworkString("chsh_equip_single_item")

local function UnequipAll(ply)
	
	for k, v in pairs(ply.items)do
		local item = itemDB[FindByID(v.uid)]
		v.equipped = false
		if(ply:HasWeapon(item.reference))then ply:StripWeapon(item.reference) end
	end
end

local function EquipAll(ply)
	if(!ply.items)then return end

	for k, v in pairs(ply.items)do
		local item = itemDB[FindByID(v.uid)]
		if(v.equipped)then
			if(!ply:HasWeapon(item.reference))then ply:Give(item.reference) end
		end
	end
end

function EquipItems(ply, tbl)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	LoadInventory(ply)
	
	UnequipAll(ply)
	
	for k, v in pairs(tbl)do
		if(ItemExists(v))then 
			if(OwnsItem(ply, v))then
				local item = itemDB[FindByID(v)]
				
				for key, it in pairs(ply.items)do
					if(it.uid == v)then
						it.equipped = true
					end
				end
			end
		end
	end
	
	EquipAll(ply)
	
	SaveInventory(ply)
	UpdateInventory(ply)
end
net.Receive("chsh_equip_multiple_items", function(len, ply)

	local ivTbl = net.ReadString()
	local equip = util.JSONToTable(ivTbl)
	
	EquipItems(ply, equip)
end)

function EquipItem(ply, itemID)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	LoadInventory(ply)
	if(!ItemExists(itemID))then print("[CHSH] Error, Invalid item ID.") return end
	if(!OwnsItem(ply, itemID))then print("[CHSH] Player doesn't own this item.") return end
	
	local item = itemDB[FindByID(itemID)]
	
	for k, v in pairs(ply.items)do
		if(v.uid == itemID)then
			if(!v.equipped)then
				v.equipped = true
				if(!ply:HasWeapon(item.reference))then ply:Give(item.reference) end
			end
		end
	end
	
	SaveInventory(ply)
	UpdateInventory(ply)
end
net.Receive("chsh_equip_single_item", function(len, ply)

	local id = tonumber(net.ReadString())
	
	EquipItem(ply, id)
end)

function GiveItem(ply, itemID)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	LoadInventory(ply)
	if(!ItemExists(itemID))then print("[CHSH] Error, Invalid item ID.") return end
	
	local item = itemDB[FindByID(itemID)]
	local slot = {uid = itemID}
	
	if(item.iType == "playermodel")then
		if(OwnsItem(ply, itemID))then print("[CHSH] Error, player already owns this item.") return end
		table.insert(ply.pms, slot)
		print(item.name .." stored into the wardrove of ".. ply:Name())
	elseif(item.iType == "swep")then
		if(OwnsItem(ply, itemID))then print("[CHSH] Error, player already owns this item.") return end
		slot.equipped = false
		table.insert(ply.items, slot)
		print(item.name .." stored into the inventory of ".. ply:Name())
	elseif(item.iType == "accessory")then
		if(OwnsItem(ply, itemID))then print("[CHSH] Error, player already owns this item.") return end
		table.insert(ply.accs, slot)
		print(item.name .." stored into the wardrove of ".. ply:Name())
	end
	
	SaveInventory(ply)
	UpdateInventory(ply)
end

function RemoveItem(ply, itemID)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	LoadInventory(ply)
	if(!OwnsItem(ply, itemID))then return end
	
	for k, v in pairs(ply.items)do
		if(v.uid == itemID)then
			table.remove(ply.items, k)
		end
	end
	
	SaveInventory(ply)
	UpdateInventory(ply)
end

-- Updates inventory clientside for the player.
function UpdateInventory(ply)
	net.Start("chsh_refresh_inventory")
		net.WriteString(util.TableToJSON(ply.items))
		net.WriteString(util.TableToJSON(ply.pms))
		net.WriteString(util.TableToJSON(ply.accs))
	net.Send(ply)
end

local function InitVars(ply)
	ply.items = {}
	ply.pms = {}
	ply.accs = {}
end

function LoadInventory(ply)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	local id = string.Replace(ply:SteamID(), ":", ".")
	local dir = "chsh_player_inventory/".. id
	InitVars(ply)

	if(!file.Exists(dir, "DATA")) then
		print("[CHSH] Player has no saved inventory.")
		file.CreateDir(dir)
		file.Write(dir.."/inventory.json","{}")
		file.Write(dir.."/playermodels.json","{}")
		file.Write(dir.."/accessories.json","{}")
		print("[CHSH] Inventory files created successfully.")
		return
	end
	
	ply.items = util.JSONToTable(file.Read(dir .."/inventory.json", "DATA"))
	ply.pms = util.JSONToTable(file.Read(dir .."/playermodels.json", "DATA"))
	ply.accs = util.JSONToTable(file.Read(dir .."/accessories.json", "DATA"))
	print("[CHSH] Inventory loaded successfully.")
end

function SaveInventory(ply)
	local id = string.Replace(ply:SteamID(), ":", ".")
	local dir = "chsh_player_inventory/".. id
	if(!file.Exists(dir, "DATA")) then
		print("[CHSH] Player has no saved inventory.")
		file.CreateDir(dir)
		print("[CHSH] Inventory files created successfully.")
	end

	local items = util.TableToJSON(ply.items, true)
	local playermodels = util.TableToJSON(ply.pms, true)
	local accessories = util.TableToJSON(ply.accs, true)

	file.Write(dir.."/inventory.json", items)
	file.Write(dir.."/playermodels.json", playermodels)
	file.Write(dir.."/accessories.json", accessories)
	print("[CHSH] Inventory saved successfully.")
end

hook.Add( "PlayerInitialSpawn", "chsh_init_inventory", function(ply)
	timer.Simple(5, function()
		LoadInventory(ply)
		UpdateInventory(ply)
	end)
end)
hook.Add("PlayerSpawn", "chsh_give_equipped", function(ply)
	timer.Simple(1, function()
		EquipAll(ply)
	end)
end)

concommand.Add("sv_load_inventory", function(ply, cmd, args)
	LoadInventory(ply)
	UpdateInventory(ply)
end)