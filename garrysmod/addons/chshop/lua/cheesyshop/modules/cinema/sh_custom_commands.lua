-- By Phonka

Actions = {
	["meditate"] = "sit_zen",
	["sit"] = "sit_zen",
	["lay"] = "zombie_slump_idle_01",
	["thumbsup"] = "pose_standing_04",
	["cower"] = "idle_all_cower",
	["showoff"] = "pose_standing_03",
	["crossarms"] = "pose_standing_01",
	["sitback"] = "zombie_slump_idle_02",
	["kneel"] = "pose_ducking_01"
}

hook.Add("CalcMainActivity", "Actions.Activity", function(ply)
	if ply:GetNWBool("ActionsToogle") then
	
		local ActionSequence = Actions[ply:GetNWString("ActionCMD")]
		if ActionSequence and type(ActionSequence) == "string" then
			return ply.CalcIdeal,  ply:LookupSequence(ActionSequence)
		end
	end
end)

if SERVER then
	concommand.Add("ActionRestart", function(ply, cmd, args)
		if !IsValid(ply) then return end

		if ply:GetNWBool("ActionsToogle") then
			ply:SetNWBool("ActionsToogle", false)
			ply:SetNWString("ActionCMD", "")
			ply.ActionExitTime = RealTime()

			ply.taunts_LockPlayerAngles = nil
			ply.taunts_CustomAngles = Angle(0, 0, 0)
		end
	end)

	hook.Add("PlayerDeath", "ActionOnDeath", function(ply)
		if IsValid(ply) and ply:GetNWBool("ActionsToogle") then
			ply:ConCommand("ActionRestart")
		end
	end)
	--[[
	hook.Add("PlayerSay", "ChatCommands", function(ply, msg)
		local command = string.match(msg, "^/(.+)") or string.match(msg, "^!(.+)")

		if command then
			command = string.Trim(string.lower(command))

			if Actions[command] then
				if (ply.ActionExitTime and RealTime() - ply.ActionExitTime < 3) or ply:GetNWBool("ActionsToogle") or ply:IsPlayingTaunt() or ply:InVehicle() then
					return ""
				end

				ply:SetNWString("ActionCMD", command)
				ply:SetNWBool("ActionsToogle", true)
			
				
				net.Start("TheaterAnnouncement")

				net.WriteTable({
				    'CuteActions',
					ply:Nick(),
					message[command]
				})

				net.Send(Location.GetPlayersInLocation(ply:GetLocation()))
				
			end

				return ""
			end
	end)
	]]
end

if CLIENT then
	hook.Add("UpdateAnimation", "Animations", function(ply)
		if IsValid(ply) then
			local Anim = Actions[ply:GetNWString("ActionCMD")]
			if ply:GetNWBool("ActionsToogle") then
				if Anim and type(Anim) == "table" then
					for modType, modBones in pairs(Anim) do
						for bone, mod in pairs(modBones) do
							local boneID = ply:LookupBone(bone)
							if bone then
								if type(mod) == "function" then mod = mod() end

								if modType == "ang" then
								end
							end
						end
					end
				end

				if !ply.lastAnim then
					ply.ActionSetup = true
					ply.lastAnim = Anim
				end
			elseif ply.ActionSetup and !ply:GetNWBool("ActionsToogle") then
				ply:InvalidateBoneCache()

				ply.ActionSetup = false
				ply.lastAnim = nil
				if LocalPlayer() == ply then
					ply.taunts_LockPlayerAngles = nil
					ply.taunts_CustomAngles = Angle(0, 0, 0)
				end
			end
		end
	end)

	hook.Add("CalcView", "CalcView", function(ply, pos, ang, fov)
		if ply:GetNWBool("ActionsToogle") then
			pos = pos - Vector(0, 0, 30)

			local tr = util.QuickTrace(pos, ply.taunts_CustomAngles:Forward()*-75, player.GetAll())
			return {
				origin = tr.HitPos,
				angles = (pos - tr.HitPos):Angle(),
				fov = fov
			}
		end
	end)

	hook.Add("ShouldDrawLocalPlayer", "LocalPlayerDraw", function(ply)
		if ply:GetNWBool("ActionsToogle") then return true end
	end)
end

hook.Add("StartCommand", "StartCommand", function(ply, cmd)
	if ply:GetNWBool("ActionsToogle") then
		if ply.taunts_LockPlayerAngles == nil then
			ply.taunts_LockPlayerAngles = ply:EyeAngles()
			ply.taunts_CustomAngles = ply:EyeAngles()
		end

		ply.taunts_CustomAngles.pitch = math.Clamp(ply.taunts_CustomAngles.pitch + cmd:GetMouseY()*0.01, -89, 89)
		ply.taunts_CustomAngles.yaw = ply.taunts_CustomAngles.yaw - cmd:GetMouseX()*0.01
		ply.taunts_CustomAngles:Normalize()

		cmd:SetViewAngles(ply.taunts_LockPlayerAngles)
		cmd:ClearMovement()
		cmd:RemoveKey(IN_DUCK)

		if SERVER and cmd:KeyDown(IN_JUMP) then
			ply:ConCommand("ActionRestart")
		end
	end
end)