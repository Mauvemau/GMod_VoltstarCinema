
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
	"sci_1.wav",
	"sci_2.wav",
	"sci_3.wav",
	"sci_4.wav",
	"sci_5.wav",
	"sci_6.wav",
	"sci_7.wav",
	"sci_8.wav"
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
	
	ply:ConCommand("effect missingtexture")
	
	if( SERVER ) then
	
		--CUSTOMSOUNDS:PlaySoundAtLocation( eat_sounds[math.random(1,8)] , ply )
	
	end

	weaponTime = CurTime() + 2.5
	
end

function SWEP:SecondaryAttack()
end