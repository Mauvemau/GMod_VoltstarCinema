
itemDB = {}
db_sweps = {}
db_playermodels = {}
db_accessories = {}

function GetItemByID(id)
	for k, v in pairs(itemDB) do
		if(math.Round(v.uid) == math.Round(id))then return v end	
	end
	print("[CHSH] Error, item not found, invalid ID.")
end

function FindItemByID(id)
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

net.Receive( "chsh_update_item_database", function()
	local swepsString = net.ReadString()
	local playermodelString = net.ReadString()
	local accessoriesString = net.ReadString()

	db_sweps = util.JSONToTable(swepsString)
	db_playermodels = util.JSONToTable(playermodelString)
	db_accessories = util.JSONToTable(accessoriesString)
	
	table.Empty(itemDB)
	for k, v in pairs(db_sweps) do
		table.insert(itemDB, v)
	end
	
	for k, v in pairs(db_playermodels) do
		table.insert(itemDB, v)
	end
	
	for k, v in pairs(db_accessories) do
		table.insert(itemDB, v)
	end
end)

concommand.Add("check_table", function()
	print("Current table:")
	PrintTable(itemDB)
end)