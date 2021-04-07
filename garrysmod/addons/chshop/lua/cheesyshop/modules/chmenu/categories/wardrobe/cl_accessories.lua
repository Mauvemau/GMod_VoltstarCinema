
local function BuildAccPanel()
	if(!IsValid(WDTabsPanel))then return end
	
	ACCPanel = vgui.Create("DPanel", WDTabsPanel)
	ACCPanel:SetSize( WDTabsPanel:GetWide() * 1, WDTabsPanel:GetTall() * 1 )
	ACCPanel:SetPos( 0, 0)
	ACCPanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local Sign = vgui.Create("DLabel", ACCPanel)
	Sign:SetPos(ACCPanel:GetWide() * .35, ACCPanel:GetTall() * .45)
	Sign:SetSize(ACCPanel:GetWide() * .3, ACCPanel:GetTall() * .1)
	Sign:SetFont("chsh_under_construction_font_small")
	Sign:SetText("Under Construction")
	
	if(IsValid(WDHelpSign))then
		WDHelpSign:SetText("Equip cool ACCESSORIES onto your character. [RIGHT CLICK] on your respective ACCESSORY SLOT to adjust it.")
		WDHelpSign:SizeToContents()
	end
	
end

local ACCESSORIES = {}

ACCESSORIES.id = "Accessories"

function ACCESSORIES:GetID()
	return self.id
end

function ACCESSORIES:Open()
	WD:CloseAllTabs()
	BuildAccPanel()
end

function ACCESSORIES:Close()
	if(IsValid(ACCPanel))then
		ACCPanel:Remove()
	end
end

local function Initialize()
	table.insert(WD.tabs, ACCESSORIES)
end
hook.Add("chsh_load_wardrobe", "load_accessories", Initialize)