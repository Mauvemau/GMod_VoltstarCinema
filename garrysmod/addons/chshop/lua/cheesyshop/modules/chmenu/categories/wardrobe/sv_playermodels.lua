util.AddNetworkString("chsh_change_playermodel")
util.AddNetworkString("chsh_change_skins")
util.AddNetworkString("chsh_change_bgroups")

local function ApplySkin(ply, val)
	ply:SetSkin(val)
end
net.Receive("chsh_change_skins", function(len, ply)
	if( !IsValid(ply) || !ply:IsPlayer() ) then return end
	local val = math.Round(net.ReadFloat())
	ApplySkin(ply, val)
end)
local function ApplyBodyGroups(ply, bodygroups)
	for k, v in pairs(bodygroups) do
		ply:SetBodygroup(k, v)
	end
end
net.Receive("chsh_change_bgroups", function(len, ply)
	if( !IsValid(ply) || !ply:IsPlayer() ) then return end
	local bgJson = net.ReadString()
	bgroups = util.JSONToTable(bgJson)
	ApplyBodyGroups(ply, bgroups)
end)

local function EquipDefault(ply, path)
	util.PrecacheModel(path)
	ply:SetModel(path)
	ApplySkin(ply, 0)
	for k = 0, ply:GetNumBodyGroups() - 1 do
		ply:SetBodygroup(k, 0)
	end
	ply:SetupHands()
	ply:ConCommand("cl_playermodel ".. player_manager.TranslateToPlayerModelName(path))
end

local function ChangePlayermodel(ply, path)
	if(InDefaultTable(path))then
		EquipDefault(ply, path)
		return
	end
	if(!ReferenceInTable(path))then
		EquipDefault(ply, "models/player/kleiner.mdl")
		ply:ChatPrint("Error, the playermodel you want to equip does not exist.")
		return
	end
	if(!OwnsItem(ply, GetIDByReference(path)))then 
		EquipDefault(ply, "models/player/kleiner.mdl")
		--ply:ChatPrint("Error, you don't own the playermodel you want to equip.")
		return
	end
	
	util.PrecacheModel(path)
	ply:SetModel(path)
	ApplySkin(ply, 0)
	for k = 0, ply:GetNumBodyGroups() - 1 do
		ply:SetBodygroup(k, 0)
	end
	ply:SetupHands()
	ply:ConCommand("cl_playermodel ".. player_manager.TranslateToPlayerModelName(path))
end
net.Receive("chsh_change_playermodel", function(len, ply)
	if( !IsValid(ply) || !ply:IsPlayer() ) then return end
	local modelpath = net.ReadString()
	ChangePlayermodel(ply, modelpath)
end)

hook.Add("PlayerSetModel", "chsh_setmodel", function(ply)
	timer.Simple(2, function()
		
		local cl_playermodel = ply:GetInfo( "cl_playermodel" )
		local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
		
		if(InDefaultTable(modelname))then
			EquipDefault(ply, modelname)
			return
		end
		if(!ReferenceInTable(modelname))then
			EquipDefault(ply, "models/player/kleiner.mdl")
			ply:ChatPrint("Error, the playermodel you want to equip does not exist.")
			return
		end
		if(!OwnsItem(ply, GetIDByReference(modelname)))then 
			EquipDefault(ply, "models/player/kleiner.mdl")
			--ply:ChatPrint("Error, you don't own the playermodel you want to equip.")
			return
		end
		util.PrecacheModel( modelname )
		ply:SetModel( modelname )
		
		local skin = ply:GetInfoNum( "cl_playerskin", 0 )
		ply:SetSkin( skin )

		local groups = ply:GetInfo( "cl_playerbodygroups" )
		if ( groups == nil ) then groups = "" end
		local groups = string.Explode( " ", groups )
		for k = 0, ply:GetNumBodyGroups() - 1 do
			ply:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
		ply:SetupHands()
	end)
end)