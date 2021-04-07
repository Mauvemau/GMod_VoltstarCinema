
function OpenCHMenu(ply)
    umsg.Start( "chsh_open_chmenu", ply )
    umsg.End()
end
hook.Add("ShowSpare2", "chsh_sv_openmenu", OpenCHMenu)

function OpenSprayMenu(ply)
	ply:Say("/sprays", false)
end
hook.Add("ShowHelp", "chsh_sv_opensprays", OpenSprayMenu)