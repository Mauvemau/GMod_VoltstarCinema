

function OpenProfile(ply)
	local h = ScrH()
	local w = ScrH() * 1.8

	local ProfilePanel = vgui.Create("DFrame")
	ProfilePanel:SetTitle("")
	ProfilePanel:SetSize( w * .5, ScrH() * .7 )
	ProfilePanel:Center()
	ProfilePanel:SetDraggable(false)
	ProfilePanel:ShowCloseButton(true)
	ProfilePanel:MakePopup()

	ProfilePanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 215))
	end

	BuildStats(ProfilePanel, ply)
end