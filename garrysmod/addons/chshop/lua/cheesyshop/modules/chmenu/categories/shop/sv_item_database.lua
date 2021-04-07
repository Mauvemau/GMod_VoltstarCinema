util.AddNetworkString("chsh_update_item_database")

util.AddNetworkString("chsh_add_new_item")
util.AddNetworkString("chsh_remove_item")
util.AddNetworkString("chsh_edit_item")
util.AddNetworkString("chsh_disable_item")

itemTypes = {
"swep",
"usable",
"accessory",
"playermodel",
"pet"
}

itemDB = {}
local currentUniqueID = 1

local function GetOnlySweps()
	local sweps = {}
	
	for i = 1, table.Count(itemDB)do
		if(itemDB[i].iType == "swep")then
			table.insert(sweps, itemDB[i])
		end
	end
	
	return sweps
end

local function GetOnlyPlayermodels()
	local models = {}
	
	for i = 1, table.Count(itemDB)do
		if(itemDB[i].iType == "playermodel")then
			table.insert(models, itemDB[i])
		end
	end
	
	return models
end

local function GetOnlyAccessories()
	local accs = {}
	
	for i = 1, table.Count(itemDB)do
		if(itemDB[i].iType == "accessory")then
			table.insert(accs, itemDB[i])
		end
	end
	
	return accs
end

local function UpdateBroadcast()
	local sweps = GetOnlySweps()
	local models = GetOnlyPlayermodels()
	local accessories = GetOnlyAccessories()
	
	net.Start("chsh_update_item_database")
		net.WriteString(util.TableToJSON(sweps))
		net.WriteString(util.TableToJSON(models))
		net.WriteString(util.TableToJSON(accessories))
	net.Broadcast()
end
--
local function UpdateLocal(ply)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[CHSH] Invalid Player") return end
	local sweps = GetOnlySweps()
	local models = GetOnlyPlayermodels()
	local accessories = GetOnlyAccessories()
	
	net.Start("chsh_update_item_database")
		net.WriteString(util.TableToJSON(sweps))
		net.WriteString(util.TableToJSON(models))
		net.WriteString(util.TableToJSON(accessories))
	net.Send(ply)
end
hook.Add("PlayerInitialSpawn", "update_item_database", function(ply)
	UpdateLocal(ply)
end)

function SaveItems()
	print("[CHSH] Saving item database.")
	local dir = "chsh"
	if(!file.Exists(dir, "DATA")) then
		file.CreateDir(dir)
		file.Write(dir.."/items.json","{}")
		file.Write(dir.."/currentID.txt","0")
		return
	end
	
	local JSON = util.TableToJSON(itemDB, true)
	file.Write(dir.."/items.json", JSON)
	file.Write(dir.."/currentID.txt", currentUniqueID)
	print("[CHSH] Item database saved.")
end

function LoadItems()
	print("[CHSH] Loading item database.")
	table.Empty(itemDB)
	
	local dir = "chsh"
	if(!file.Exists(dir, "DATA")) then
		print("[CHSH] No database files found..")
		file.CreateDir(dir)
		file.Write(dir.."/items.json","{}")
		file.Write(dir.."/currentID.txt","1")
		print("[CHSH] Database initialized correctly.")
		return
	end	
	
	currentUniqueID = file.Read(dir .."/currentID.txt", "DATA")
	itemDB = util.JSONToTable(file.Read(dir .."/items.json", "DATA"))
	print("[CHSH] Database loaded with ".. table.Count(itemDB) .." items.")
end

function ModelExists(reference)
	local models = player_manager.AllValidModels()
	
	for k, v in pairs(models) do
		if(v == reference) then return true end
	end
	
	return false
end

function SwepExists(reference)
	local sweps = weapons.GetList()
	
	for i = 1, table.Count(sweps)do
		if(sweps[i].ClassName == reference)then return true end
	end
	
	return false
end

function IsItemValid(item)
	if(!item.iType)then return false end
	if(!table.HasValue(itemTypes, item.iType))then return false end
	
	if(item.iType == itemTypes[1])then if(!SwepExists(item.reference))then print("[CHSH] The swep does not exist.") return false end
	elseif(item.iType == itemTypes[4]) then if(!ModelExists(item.reference))then print("[CHSH] The playermodel does not exist.") return false end
	end
	
	return true
end

function ReferenceInTable(reference)
	for k, v in pairs(itemDB) do
		if(v.reference == reference) then return true end
	end

	return false
end

function GetIDByReference(reference)
	for k, v in pairs(itemDB) do
		if(v.reference == reference) then return v.uid end
	end
	print("[CHSH] Error, item not found, invalid reference.")
end

function FindByID(id)
	for k, v in pairs(itemDB) do
		if(math.Round(v.uid) == math.Round(id))then return k end
	end
	print("[CHSH] Error, item not found, invalid ID.")
end

function ItemExists(id)
	for k, v in pairs(itemDB) do
		if(math.Round(v.uid) == math.Round(id))then return true end
	end
	
	return false
end

function AddItem(item)
	if(!IsItemValid(item))then print("[CHSH] Invalid item.") return end
	LoadItems()
	if(ReferenceInTable(item.reference))then print("[CHSH] Reference to that item is already in the database.") return end
	table.insert(itemDB, item)
	currentUniqueID = currentUniqueID + 1
	SaveItems()
	UpdateBroadcast()
	print("[CHSH] Item added successfully.")
end

function EditItem(id, newItem)
	print("[CHSH] Editing item...")
	LoadItems()
	if(!ItemExists(id))then print("[CHSH] Error, invalid item id.") return end
	itemDB[FindByID(id)] = newItem
	SaveItems()
	UpdateBroadcast()
	print("[CHSH] Item edited successfully.")
end
function SetItemEnabled(id, enabled)
	LoadItems()
	if(!ItemExists(id))then print("[CHSH] Error, invalid item id.") return end
	item[FindByID(id)].enabled = enabled
	SaveItems()
	UpdateBroadcast()
	print("[CHSH] Item edited successfully.")
end

hook.Add("InitPostEntity", "load_items", function()
	LoadItems()
end)

concommand.Add("sv_load_table", function()
	LoadItems()
	UpdateBroadcast()
end)
concommand.Add("sv_check_table", function()
	PrintTable(itemDB)
end)

net.Receive("chsh_add_new_item", function(len, ply)
	if(!IsValid(ply) || !ply:IsPlayer())then return end
	if(!CHIsAdmin(ply))then print("[CHSH] Player is not admin.") return end
	
	local item = net.ReadTable()
	item.uid = currentUniqueID
	AddItem(item)
end)
net.Receive("chsh_edit_item", function(len, ply)
	if(!IsValid(ply) || !ply:IsPlayer())then print("[ERROR] Invalid player.") return end
	if(!CHIsAdmin(ply))then print("[CHSH] Player is not admin.") return end
	
	local id = net.ReadString()
	local item = net.ReadTable()
	EditItem(id, item)
end)
net.Receive("chsh_enable_disable_item", function(len, ply)
	if(!IsValid(ply) || !ply:IsPlayer())then return end
	if(!CHIsAdmin(ply))then return end
	
	local id = net.ReadString()
	local enable = net.ReadBool()
	SetItemEnabled(id, enable)
end)

LoadItems()
UpdateBroadcast()

function AddAllNonDefault()
	local models = player_manager.AllValidModels()
	
	for k, v in pairs(models) do
		if(!InDefaultTable(v))then
			local item = {}
			item.enabled = true
			item.name = k
			item.iType = "playermodel"
			item.price = 5000
			item.reference = v
			item.uid = currentUniqueID
			item.description = ""
			AddItem(item)
		end
	end
end
--AddAllNonDefault()
