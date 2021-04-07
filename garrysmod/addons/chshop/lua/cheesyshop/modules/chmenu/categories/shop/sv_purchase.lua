
util.AddNetworkString("chsh_purchase_item")
util.AddNetworkString("chsh_purchase_with_coupon")
util.AddNetworkString("chsh_confirm_purchase")
util.AddNetworkString("chsh_purchase_failure")

local function CanAfford(ply, amount)
	if(GetCredits(ply) >= amount) then return true
	else return false end
end

local function PurchaseItem(ply, itemID, coupon)
	if(!ItemExists(itemID))then 
		net.Start("chsh_purchase_failure")
			net.WriteString("The item you want to purchase doesn't exist!")
		net.Send(ply)
		return
	end
	
	local item = itemDB[FindByID(itemID)]
	
	if(!item.enabled)then
		net.Start("chsh_purchase_failure")
			net.WriteString("You can't purchase this item!")
		net.Send(ply)
		return
	end
	
	if(item.iType == "accessory")then
		net.Start("chsh_purchase_failure")
			net.WriteString("Accessories aren't available for purchase yet.")
		net.Send(ply)
		return
	end
	
	if(item.iType == "playermodel" || item.iType == "swep" || item.iType == "accessory")then
		if(OwnsItem(ply, itemID))then 
			net.Start("chsh_purchase_failure")
				net.WriteString("You already own the item you want to purchase!")
			net.Send(ply)
			return
		end
	end
	
	if(!coupon)then
		if(!CanAfford(ply, item.price))then
			net.Start("chsh_purchase_failure")
				net.WriteString("You can't afford this item!")
			net.Send(ply)
			return
		else
			PlayerVars:RemoveCredits(ply, item.price)
			PlayerVars:AddWastedShop(ply, item.price)
			PlayerData:Save(ply)
		end
	else
		if(GetPMCoupons(ply) < 1)then
			net.Start("chsh_purchase_failure")
				net.WriteString("You don't have any coupons!")
			net.Send(ply)
			return
		else
			PlayerVars:RemoveCoupons(ply, 1)
			PlayerData:Save(ply)
		end
	end
	
	-- Give item to the player
	GiveItem(ply, itemID)
	
	net.Start("chsh_confirm_purchase")
		net.WriteString(itemID)
	net.Send(ply)
	print(ply:Name() .." purchased ".. item.name .."!")
end
net.Receive("chsh_purchase_item", function(len, ply)
	local id = tonumber(net.ReadString())
	PurchaseItem(ply, id, false)
end)
net.Receive("chsh_purchase_with_coupon", function(len, ply)
	local id = tonumber(net.ReadString())
	PurchaseItem(ply, id, true)
end)

