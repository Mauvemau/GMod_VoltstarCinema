
function GetAllItems(ply)
	local itemTable = {}

	if CLIENT then
		for k, v in pairs(eqInventoryCL) do
			table.insert(itemTable, v)
		end
		for k, v in pairs(pmInventoryCL) do
			table.insert(itemTable, v)
		end
		for k, v in pairs(acInventoryCL) do
			table.insert(itemTable, v)
		end
	else
		for k, v in pairs(ply.items) do
			table.insert(itemTable, v)
		end
		for k, v in pairs(ply.pms) do
			table.insert(itemTable, v)
		end
		for k, v in pairs(ply.accs) do
			table.insert(itemTable, v)
		end
	end
	
	return itemTable
end

function OwnsItem(ply, itemID)
	local items = GetAllItems(ply)
	
	for k, v in pairs(items) do
		if(math.Round(v.uid) == math.Round(itemID))then return true end
	end

	return false
end