AddCSLuaFile()
EFFECT.Mat = Material("particle/rain")

EFFECT.PopcornSize = CreateConVar("PopcornSize",2,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Set Popcorn size") -- Particle size
EFFECT.PopcornSpread = CreateConVar("PopcornSpread",10,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE},"Set Popcorn spread")-- Spread of the Popcorn

local function ChangeConvar(cvar, ov, nv)
  if CLIENT then return end
  EFFECT[cvar] = nv
end

cvars.AddChangeCallback("PopcornSize",ChangeConvar)
cvars.AddChangeCallback("PopcornSpread",ChangeConvar)

function EFFECT:Init( data )
 
  local aOrigin = data:GetAngles()
  local vOrigin = data:GetOrigin()
  local emitter = ParticleEmitter( vOrigin, aOrigin )

  for i = 1, 120 do --popcorn amount set to 120

    local particle = emitter:Add( self.Mat, vOrigin , aOrigin)
    if (particle) then

      --Spread of Popcorn
      particle:SetVelocity( Vector(math.Rand(-250, 250),math.Rand(-250, 250),math.Rand(-300, 300)) + data:GetAngles():Forward()*200 )

      --How long the Popcorn lasts
      particle:SetLifeTime( 0 )
      particle:SetDieTime(math.random(3, 7))

      --Transparacy of Popcorn
      particle:SetStartAlpha( 255 )
      particle:SetEndAlpha( 255 )

      --Size of Popcorn pieces
      local Size = math.Rand( self.PopcornSize:GetInt() -1, self.PopcornSize:GetInt() + 2 )
      particle:SetStartSize( Size )
      particle:SetEndSize( 0 )

      particle:SetRoll( math.Rand(0, 7) )
      particle:SetRollDelta( math.Rand(0, 1) )

      --How fast the Popcorn drifts to the ground
      particle:SetAirResistance( 200 )
      particle:SetGravity( Vector(0, 0, -275) )

      --Color of Popcorn
      particle:SetColor( 255, 255, 255 )

      --Collide with other entities
      particle:SetCollide( true ) --don't really want it falling through the map for several reasons

      --Set rotation of pieces, shouldn't need to change this
      particle:SetAngleVelocity( Angle( 2, 2, 2 ) )

      --Set how much the Popcorn will "bounce" off the ground
      particle:SetBounce( math.Rand(0.1, 0.3) )
      particle:SetLighting( false ) --lighting on looks ugly

    end
  end

  emitter:Finish()

end

function EFFECT:Render()
end
