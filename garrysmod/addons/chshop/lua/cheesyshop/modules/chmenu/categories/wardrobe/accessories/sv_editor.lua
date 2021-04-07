--[[
local function UpdateLocal()

end

local function RemoveAccessory(ply)
	if(ply.slot1 == nil)then return end
	
	ply.slot1:Remove()
	ply.slot1 = nil
end

local function AddAccessory(ply, accessory, bone)
	if(ply.slot1 != nil)then return end
	
	local slot = ply.accSlot1
	local item = itemDB[FindByID(slot.id)]
	
	local boneindex = ply:LookupBone("ValveBiped.Bip01_Head1")

	local pos = (ply:GetBoneMatrix(boneindex):GetTranslation() + slot.pos)
	local ang = (ply:GetAngles() + slot.ang)
	
	local acc = ents.Create("prop_physics")
	acc:SetModel(item.reference)
	acc:SetMoveType(MOVETYPE_NONE)
	acc:SetPos(pos)
	acc:SetAngles(ang)
	acc:SetModelScale(slot.scale, 0)
	acc:SetParent(ply, 3)
	acc:Spawn()
	
	
	ply.slot1 = acc
end

local function MakeAccessory(itemID)
	if(!ItemExists(itemID))then return end
	local item = itemDB[FindByID(itemID)]
	if(item.iType != "accessory")then return end
	
	local slot = {
	id = itemID,
	
	pos = Vector(0, 0, 7.5),
	ang = Angle(0, 0, 0),
	scale = 0.6
	}
	
	return slot
end

concommand.Add("attach", function(ply, cmd, args)
	if(ply.slot1 == nil)then
		local acc = MakeAccessory(99)
		AddAccessory(ply, acc, "ValveBiped.Bip01_Head1")
	else
		RemoveAccessory(ply)
	end
end)
]]