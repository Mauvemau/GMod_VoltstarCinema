function StartScripts()
	if SERVER then
	include("cheesyshop/init.lua")
	end
	if CLIENT then
		include("cheesyshop/cl_init.lua")
	end
end
StartScripts()
hook.Add( "ch_refresh_scripts", "refresh_all_scripts_manually", StartScripts)