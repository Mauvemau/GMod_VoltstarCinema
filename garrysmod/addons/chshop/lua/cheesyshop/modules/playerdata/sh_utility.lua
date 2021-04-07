
function TransformTime(seconds)
	local seconds = tonumber(seconds)
	
	local hours = "0"
	local mins = "0"
	local secs = "0"
	
	if (seconds > 0) then
		hours = string.format("%d", math.floor(seconds / 3600))
		mins = string.format("%d", math.floor(seconds / 60 - (hours * 60)))
		secs = string.format( "%d", math.floor(seconds - hours * 3600 - mins * 60))
	end
	return hours.." hours "..mins.." minutes "..secs.." seconds"
end

function TransformInvalidNames(name)
	local changed = name
	if(string.find(name, ",") || string.find(name, ".") || string.find(name, "+") || string.find(name, "-") || string.find(name, "=") || string.find(name, "/") || string.find(name, "*") || string.find(name, ";") || string.find(name, ":") || string.find(name, "'") || string.find(name, '"') )then
		changed = string.Replace(name, ",", " ")
		changed = string.Replace(name, "+", " ")
		changed = string.Replace(name, "-", " ")
		changed = string.Replace(name, "=", " ")
		changed = string.Replace(name, "/", " ")
		changed = string.Replace(name, "*", " ")
		changed = string.Replace(name, ";", " ")
		changed = string.Replace(name, ":", " ")
		changed = string.Replace(name, "'", " ")
		changed = string.Replace(name, '"', " ")
	end

	return changed
end