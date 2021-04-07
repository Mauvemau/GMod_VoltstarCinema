
CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

local function MakeNiceName( str )
	local newname = {}

	for _, s in pairs( string.Explode( "_", str ) ) do
		if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
		table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
	end

	return string.Implode( " ", newname )
end

local function UpdateBodyGroups( pnl, val )
	if ( pnl.type == "bgroup" ) then
		bgSelected[pnl.typenum] = math.Round(val)
		PlayermodelView.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )
		
		local str = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
		if ( #str < pnl.typenum + 1 ) then for i = 1, pnl.typenum + 1 do str[ i ] = str[ i ] or 0 end end
		str[ pnl.typenum + 1 ] = math.Round( val )
		RunConsoleCommand( "cl_playerbodygroups", table.concat( str, " " ) )
		
	elseif ( pnl.type == "skin" ) then
		skSelected = math.Round( val )
		PlayermodelView.Entity:SetSkin( math.Round( val ) )
		
		RunConsoleCommand("cl_playerskin", math.Round( val ))
	end
end

local function BuildBodygroupsSelector()
	if(!IsValid(WDTabsPanel))then return end
	
	BGPanel = vgui.Create("DPanel", WDTabsPanel)
	BGPanel:SetSize( WDTabsPanel:GetWide() * 1, WDTabsPanel:GetTall() * 1 )
	BGPanel:SetPos( 0, 0)
	BGPanel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) )
	end
	
	local scroll = vgui.Create("DScrollPanel", BGPanel)
	scroll:SetPos(BGPanel:GetWide() * .01, BGPanel:GetTall() * .01)
	scroll:SetSize(BGPanel:GetWide() * .98, BGPanel:GetTall() * .98)
	scroll.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local ypos = 0
	local nskins = PlayermodelView.Entity:SkinCount() - 1
	if ( nskins > 0 ) then
		local bgslot = vgui.Create("DPanel", scroll)
		bgslot:SetPos( scroll:GetWide() * .15, ypos)
		bgslot:SetSize( scroll:GetWide() * .7, BGPanel:GetTall() * .1 )
		bgslot.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, borderColor)
		end
		
		ypos = ypos + bgslot:GetTall() * 1.05
		
		local skins = vgui.Create( "DNumSlider", bgslot)
		skins:Dock( TOP )
		skins:SetText( "" )
		skins:SetDark( false )
		skins:SetTall( 50 )
		skins:SetWide( 50 )
		skins:SetDecimals( 0 )
		skins:SetMax( nskins )
		skins:SetValue(skSelected)
		skins.type = "skin"
		skins.OnValueChanged = UpdateBodyGroups
		PlayermodelView.Entity:SetSkin(skSelected)
		
		local text = vgui.Create("DLabel", bgslot)
		text:SetPos(bgslot:GetWide() * .05, bgslot:GetTall() * .32)
		text:SetSize(bgslot:GetWide() * .25, bgslot:GetTall() * .35)
		text:SetText("Skins")
		text:SetFont("chsh_bg_font")
		text:SetColor(backgroundColor)
	end
	
	local groups = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
	for k = 0, PlayermodelView.Entity:GetNumBodyGroups() - 1 do
		if ( PlayermodelView.Entity:GetBodygroupCount( k ) <= 1 ) then continue end
		
		local bgslot = vgui.Create("DPanel", scroll)
		bgslot:SetPos( scroll:GetWide() * .15, ypos)
		bgslot:SetSize( scroll:GetWide() * .7, BGPanel:GetTall() * .1 )
		bgslot.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, borderColor)
		end

		ypos = ypos + bgslot:GetTall() * 1.05

		local bgroup = vgui.Create( "DNumSlider", bgslot)
		bgroup:Dock( TOP )
		bgroup:SetDark( true )
		bgroup:SetTall( 50 )
		bgroup:SetDecimals( 0 )
		bgroup.type = "bgroup"
		bgroup.typenum = k
		bgroup:SetMax( PlayermodelView.Entity:GetBodygroupCount( k ) - 1 )
		bgroup:SetValue( groups[ k + 1 ] or 0 )
		if(bgSelected[k])then bgroup:SetValue(bgSelected[k]) end
		bgroup.OnValueChanged = UpdateBodyGroups

		PlayermodelView.Entity:SetBodygroup( k, groups[ k + 1 ] or 0 )
		if(bgSelected[k])then PlayermodelView.Entity:SetBodygroup(k, bgSelected[k]) end
		
		local text = vgui.Create("DLabel", bgslot)
		text:SetPos(bgslot:GetWide() * .05, bgslot:GetTall() * .32)
		text:SetSize(bgslot:GetWide() * .25, bgslot:GetTall() * .35)
		text:SetText(MakeNiceName(PlayermodelView.Entity:GetBodygroupName( k )))
		text:SetFont("chsh_bg_font")
		text:SetColor(backgroundColor)
	end
	
	
	if(IsValid(WDHelpSign))then
		WDHelpSign:SetText("Customize your model's bodygroups.")
		WDHelpSign:SizeToContents()
	end
	
end

local BODYGROUPS = {}

BODYGROUPS.id = "Bodygroups"

function BODYGROUPS:GetID()
	return self.id
end

function BODYGROUPS:Open()
	WD:CloseAllTabs()
	BuildBodygroupsSelector()
end

function BODYGROUPS:Close()
	if(IsValid(BGPanel))then
		BGPanel:Remove()
	end
end

local function Initialize()
	table.insert(WD.tabs, 2, BODYGROUPS)
end
hook.Add("chsh_load_wardrobe", "load_bodygroups", Initialize)