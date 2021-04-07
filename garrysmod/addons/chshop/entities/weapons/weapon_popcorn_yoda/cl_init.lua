include('shared.lua')

SWEP.PrintName          = "Popcorn Yoda"
SWEP.Slot               = 1
SWEP.SlotPos            = 1
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false

SWEP.WepSelectIcon 		= surface.GetTextureID( "weapons/icon_popcorn_small" )

function SWEP:GetViewModelPosition( pos , ang)
	pos,ang = LocalToWorld(Vector(25,-6,-15),Angle(0,0,0),pos,ang)
	
	return pos, ang
end