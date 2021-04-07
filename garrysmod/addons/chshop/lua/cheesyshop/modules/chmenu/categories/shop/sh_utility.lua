
-- Globals
defaultPlayermodels = {
{path = "models/player/alyx.mdl"},
{path = "models/player/barney.mdl"},
{path = "models/player/breen.mdl"},
{path = "models/player/p2_chell.mdl"},
{path = "models/player/eli.mdl"},
{path = "models/player/gman_high.mdl"},
{path = "models/player/kleiner.mdl"},
{path = "models/player/monk.mdl"},
{path = "models/player/mossman.mdl"},
{path = "models/player/mossman_arctic.mdl"},
{path = "models/player/odessa.mdl"},
{path = "models/player/magnusson.mdl"},
{path = "models/player/police.mdl"},
{path = "models/player/police_fem.mdl"},
{path = "models/player/combine_soldier.mdl"},
{path = "models/player/combine_super_soldier.mdl"},
{path = "models/player/combine_soldier_prisonguard.mdl"},
{path = "models/player/soldier_stripped.mdl"},
{path = "models/player/corpse1.mdl"},
{path = "models/player/charple.mdl"},
{path = "models/player/skeleton.mdl"},
{path = "models/player/zombie_classic.mdl"},
{path = "models/player/zombie_fast.mdl"},
{path = "models/player/zombie_soldier.mdl"},
{path = "models/player/Group01/female_01.mdl"},
{path = "models/player/Group01/female_02.mdl"},
{path = "models/player/Group01/female_03.mdl"},
{path = "models/player/Group01/female_04.mdl"},
{path = "models/player/Group01/female_05.mdl"},
{path = "models/player/Group01/female_06.mdl"},
{path = "models/player/Group03/female_01.mdl"},
{path = "models/player/Group03/female_02.mdl"},
{path = "models/player/Group03/female_03.mdl"},
{path = "models/player/Group03/female_04.mdl"},
{path = "models/player/Group03/female_05.mdl"},
{path = "models/player/Group03/female_06.mdl"},
{path = "models/player/Group03m/female_01.mdl"},
{path = "models/player/Group03m/female_02.mdl"},
{path = "models/player/Group03m/female_03.mdl"},
{path = "models/player/Group03m/female_04.mdl"},
{path = "models/player/Group03m/female_05.mdl"},
{path = "models/player/Group03m/female_06.mdl"},
{path = "models/player/Group01/male_01.mdl"},
{path = "models/player/Group01/male_02.mdl"},
{path = "models/player/Group01/male_03.mdl"},
{path = "models/player/Group01/male_04.mdl"},
{path = "models/player/Group01/male_05.mdl"},
{path = "models/player/Group01/male_06.mdl"},
{path = "models/player/Group01/male_07.mdl"},
{path = "models/player/Group01/male_08.mdl"},
{path = "models/player/Group01/male_09.mdl"},
{path = "models/player/Group02/male_02.mdl"},
{path = "models/player/Group02/male_04.mdl"},
{path = "models/player/Group02/male_06.mdl"},
{path = "models/player/Group02/male_08.mdl"},
{path = "models/player/Group03/male_01.mdl"},
{path = "models/player/Group03/male_02.mdl"},
{path = "models/player/Group03/male_03.mdl"},
{path = "models/player/Group03/male_04.mdl"},
{path = "models/player/Group03/male_05.mdl"},
{path = "models/player/Group03/male_06.mdl"},
{path = "models/player/Group03/male_07.mdl"},
{path = "models/player/Group03/male_08.mdl"},
{path = "models/player/Group03/male_09.mdl"},
{path = "models/player/Group03m/male_01.mdl"},
{path = "models/player/Group03m/male_02.mdl"},
{path = "models/player/Group03m/male_03.mdl"},
{path = "models/player/Group03m/male_04.mdl"},
{path = "models/player/Group03m/male_05.mdl"},
{path = "models/player/Group03m/male_06.mdl"},
{path = "models/player/Group03m/male_07.mdl"},
{path = "models/player/Group03m/male_08.mdl"},
{path = "models/player/Group03m/male_09.mdl"},
{path = "models/player/hostage/hostage_01.mdl"},
{path = "models/player/hostage/hostage_02.mdl"},
{path = "models/player/hostage/hostage_03.mdl"},
{path = "models/player/hostage/hostage_04.mdl"},
{path = "models/player/arctic.mdl"},
{path = "models/player/gasmask.mdl"},
{path = "models/player/guerilla.mdl"},
{path = "models/player/leet.mdl"},
{path = "models/player/phoenix.mdl"},
{path = "models/player/riot.mdl"},
{path = "models/player/swat.mdl"},
{path = "models/player/urban.mdl"},
{path = "models/player/dod_american.mdl"},
{path = "models/player/dod_german.mdl"}
}

function InDefaultTable(value)
	for k, v in pairs(defaultPlayermodels) do
		if(v.path == value) then return true end
	end

	return false
end

function ReplaceCommaWithDot(str)
	local comma = string.find(str, ",")
	if(comma)then
		local rtStr = string.Replace(str, ",", ".")
		return rtStr
	end
	return str
end

function GetDefaultModels()
	local models = {}
	
	for k, v in pairs(defaultPlayermodels)do
		local model = {
			reference = v.path,
			name = player_manager.TranslateToPlayerModelName(v.path)
		}
		table.insert(models, model)
	end
	
	return models
end

