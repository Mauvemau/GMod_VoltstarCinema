
SWEP.ViewModel = "models/unconid/popcorn/popcorn_small_w.mdl"
SWEP.WorldModel = "models/unconid/popcorn/popcorn_small_w.mdl"
SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.Category = "Food"


SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

--[[
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
]]
SWEP.DrawAmmo = false
SWEP.Slot				= 1
SWEP.SlotPos			= 0
SWEP.HoldType 			= "slam"

local eat_sounds = {
	"yoda_death.wav"
}

weaponTime = 0


function SWEP:Deploy()
end

function SWEP:Initialize()

	weaponTime = CurTime()
	
end

function SWEP:PrimaryAttack()
	
	if( weaponTime >  CurTime() ) then return end;
	
	local ply = self:GetOwner()
	
	ply:ConCommand("effect yodag")
	
	if( SERVER ) then
	
		--CUSTOMSOUNDS:PlaySoundAtLocation( eat_sounds[1] , ply )
	
	end

	weaponTime = CurTime() + 2.5
	
end

function SWEP:SecondaryAttack()
end