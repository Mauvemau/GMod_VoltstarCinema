
function BuildStats(panel, ply)
	if(!IsValid(panel))then return end
	
	StatsFrame = vgui.Create("DPanel", panel)
	StatsFrame:SetSize( panel:GetWide() * 1, panel:GetTall() * 1 )
	StatsFrame:SetPos( 0, 0)
	StatsFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	local BasicStatsBorder = vgui.Create("DPanel", StatsFrame)
	BasicStatsBorder:SetPos(0, 0)
	BasicStatsBorder:SetSize(StatsFrame:GetWide() * 1, StatsFrame:GetTall() * .3)
	PaintFrameSpecific(BasicStatsBorder, team.GetColor(ply:Team()))
	
	local BasicStatsFrame = vgui.Create("DPanel", BasicStatsBorder)
	BasicStatsFrame:SetPos(2, 2)
	BasicStatsFrame:SetSize((BasicStatsBorder:GetWide() * 1) - 4, (BasicStatsBorder:GetTall() * 1) -4)
	BasicStatsFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, GetTransparent(team.GetColor(ply:Team()), 5))
	end
	
	local PicPanel = vgui.Create("DPanel", BasicStatsFrame)
	PicPanel:SetPos(BasicStatsFrame:GetTall() * .1, BasicStatsFrame:GetTall() * .1)
	PicPanel:SetSize(BasicStatsFrame:GetTall() * .8, BasicStatsFrame:GetTall() * .8)
	PaintFrameSpecific(PicPanel, team.GetColor(ply:Team()))
	
	local Avatar = vgui.Create("AvatarImage", PicPanel)
	Avatar:SetPos(2, 2)
	Avatar:SetSize(PicPanel:GetTall() - 4, PicPanel:GetTall() - 4)
	Avatar:SetMouseInputEnabled(false)
	Avatar:SetPlayer(ply, 184)
	
	local ProfileButton = vgui.Create("DButton", PicPanel)
	ProfileButton:SetPos(0, 0)
	ProfileButton:SetSize(PicPanel:GetTall() * 1, PicPanel:GetTall() * 1)
	ProfileButton:SetText("")
	ProfileButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	ProfileButton.DoClick = function()
		ply:ShowProfile()
	end
	
	local RankSlot = vgui.Create("DPanel", BasicStatsFrame)
	RankSlot:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .12)
	RankSlot:SetSize(BasicStatsFrame:GetWide() * .09, BasicStatsFrame:GetTall() * .15)
	PaintFrameSpecific(RankSlot, team.GetColor(ply:Team()))
	
	local RankName = vgui.Create("DLabel", RankSlot)
	RankName:SetPos(0, 0)
	RankName:SetSize(RankSlot:GetWide() * 1, RankSlot:GetTall() * 1)
	RankName:SetContentAlignment(5)
	RankName:SetFont("chsh_stats_rank")
	RankName:SetText(ply:GetUserGroup())
	RankName:SetColor(team.GetColor(ply:Team()))
	
	local Name = vgui.Create("DLabel", BasicStatsFrame)
	Name:SetPos((BasicStatsFrame:GetWide() * .19) + (RankSlot:GetWide() * 1.08), BasicStatsFrame:GetTall() * .12)
	Name:SetSize(BasicStatsFrame:GetWide() * .4, BasicStatsFrame:GetTall() * .15)
	Name:SetContentAlignment(4)
	Name:SetFont("chsh_stats_name")
	Name:SetText(ply:Name())
	Name:SetColor(Color(255, 255, 255, 255))

	local EditIco = vgui.Create("DSprite", BasicStatsFrame)
	EditIco:SetPos(BasicStatsFrame:GetWide() * .2, BasicStatsFrame:GetTall() * .35)
	EditIco:SetMaterial(Material("icon16/cog.png"))
	EditIco:SetSize(ProfilePanel:GetTall() * .02, ProfilePanel:GetTall() * .02)

	if(ply != LocalPlayer())then
		EditIco:SetVisible(false)
	end

	local Title = vgui.Create("DLabel", BasicStatsFrame)
	if(ply == LocalPlayer())then
		Title:SetPos((BasicStatsFrame:GetWide() * .19) + (EditIco:GetWide() * 1) + 4, BasicStatsFrame:GetTall() * .28)
	else
		Title:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .28)
	end
	Title:SetFont("chsh_stats_title")
	Title:SetColor(Color(200, 200, 200, 255))

	local function SetTitle(title)
		if(title == "")then
			title = "No title"
		end

		Title:SetText("<".. title ..">")
		Title:SizeToContents()
	end
	SetTitle(GetTitle(ply))

	if(ply == LocalPlayer())then
		local EditTitleButton = vgui.Create("DButton", BasicStatsFrame)
		EditTitleButton:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .28)
		EditTitleButton:SetSize(ProfilePanel:GetTall() * .026, ProfilePanel:GetTall() * .026)
		EditTitleButton:SetText("")
		EditTitleButton.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
		end

		local titleSiz = 50

		EditTitleButton.DoClick = function()
			EditTitleButton:SetVisible(false)
			Title:SetVisible(false)

			local TitleEditor = vgui.Create("DTextEntry", BasicStatsFrame)
			TitleEditor:SetPos((BasicStatsFrame:GetWide() * .19) + (EditIco:GetWide() * 1) + 4, BasicStatsFrame:GetTall() * .28)
			TitleEditor:SetSize(BasicStatsFrame:GetWide() * .3, Title:GetTall() * 1)
			TitleEditor:SetUpdateOnType(true)

			TitleEditor.OnEnter = function(self)
				local str = self:GetValue()
				if(string.len(str) > titleSiz)then
					str = string.sub(str, 1, titleSiz)
				end

				net.Start("chsh_change_title")
					net.WriteString(str)
				net.SendToServer()

				SetTitle(str)
				EditTitleButton:SetVisible(true)
				Title:SetVisible(true)
				self:Remove()
			end
		end
	end
	local Level = vgui.Create("DLabel", BasicStatsFrame)
	Level:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .54)
	Level:SetSize(BasicStatsFrame:GetWide() * .2, BasicStatsFrame:GetTall() * .15)
	Level:SetContentAlignment(7)
	Level:SetFont("chsh_stats_stats")
	Level:SetText("Level ".. GetLevel(ply))
	Level:SetColor(Color(255, 255, 255, 255))
	
	local XPBar = vgui.Create("DPanel", BasicStatsFrame)
	XPBar:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .67)
	XPBar:SetSize(BasicStatsFrame:GetWide() * .3, BasicStatsFrame:GetTall() * .15)
	PaintFrameSpecific(XPBar, team.GetColor(ply:Team()))
	
	local xp = (GetXP(ply) / GetNeededXP(ply)) * (XPBar:GetWide() - 4)
	local BarFill = vgui.Create("DPanel", XPBar)
	BarFill:SetPos(2, 2)
	BarFill:SetSize(XPBar:GetWide() - 4, XPBar:GetTall() - 4)
	BarFill.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, math.Clamp(xp, 0, w), h, team.GetColor(ply:Team()))
	end
	
	local percent = GetXP(ply)/GetNeededXP(ply)
	percent = percent * 100
	local XPPercentage = vgui.Create("DLabel", BarFill)
	XPPercentage:SetPos(0, 0)
	XPPercentage:SetSize(BarFill:GetWide() * 1, BarFill:GetTall() * 1)
	XPPercentage:SetContentAlignment(5)
	XPPercentage:SetFont("chsh_stats_xp")
	XPPercentage:SetText(math.Round(percent) .."%")
	XPPercentage:SetColor(Color(255, 255, 255, 255))
	
	local XPMarker = vgui.Create("DLabel", BasicStatsFrame)
	XPMarker:SetPos(BasicStatsFrame:GetWide() * .19, BasicStatsFrame:GetTall() * .8)
	XPMarker:SetSize(BasicStatsFrame:GetWide() * .1, BasicStatsFrame:GetTall() * .1)
	XPMarker:SetContentAlignment(7)
	XPMarker:SetFont("chsh_stats_xp_small")
	XPMarker:SetText(math.Round(GetXP(ply)) .." / ".. math.Round(GetNeededXP(ply)) .." xp")
	XPMarker:SetColor(Color(255, 255, 255, 255))
	
	local StID = vgui.Create("DLabel", BasicStatsFrame)
	StID:SetPos(BasicStatsFrame:GetWide() * .82, BasicStatsFrame:GetTall() * .88)
	StID:SetSize((BasicStatsFrame:GetWide() * .18) - 4, (BasicStatsFrame:GetTall() * .12) - 4)
	StID:SetFont("chsh_stats_stats")
	StID:SetContentAlignment(6)
	StID:SetText(ply:SteamID())
	StID:SetColor(Color(80, 80, 80, 255))
	
	local StIDButton = vgui.Create("DButton", BasicStatsFrame)
	StIDButton:SetPos(BasicStatsFrame:GetWide() * .82, BasicStatsFrame:GetTall() * .86)
	StIDButton:SetSize((BasicStatsFrame:GetWide() * .18) - 4, (BasicStatsFrame:GetTall() * .14) - 4)
	StIDButton:SetText("")
	StIDButton:SetTooltip("Click to copy")
	StIDButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	StIDButton.DoClick = function()
		SetClipboardText(ply:SteamID())
		StID:SetContentAlignment(5)
		StID:SetText("Copied!")
		StID:SetColor(Color(125, 125, 125, 255))
		timer.Simple(2, function()
			if(!IsValid(StID))then return end
			StID:SetContentAlignment(6)
			StID:SetText(ply:SteamID())
			StID:SetColor(Color(80, 80, 80, 255))
		end)
	end
	
	--
	
	local DetailedStatsPanel = vgui.Create("DPanel", StatsFrame)
	DetailedStatsPanel:SetPos(0, BasicStatsBorder:GetTall() * 1)
	DetailedStatsPanel:SetSize(StatsFrame:GetWide() * 1, (StatsFrame:GetTall() * 1) - BasicStatsBorder:GetTall() * 1)
	PaintFrame(DetailedStatsPanel)
	
	local Scroll = vgui.Create("DScrollPanel", DetailedStatsPanel)
	Scroll:SetPos(0, 0)
	Scroll:SetSize(DetailedStatsPanel:GetWide() * 1, DetailedStatsPanel:GetTall() * 1)
	Scroll.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	
	ypos = DetailedStatsPanel:GetTall() * .01
	local padding = DetailedStatsPanel:GetWide() * .01
	-- Ply Stats
	local PlyStatsPanel = vgui.Create("DPanel", Scroll)
	PlyStatsPanel:SetPos(DetailedStatsPanel:GetWide() * .005, ypos)
	PlyStatsPanel:SetSize(DetailedStatsPanel:GetWide() * .99, DetailedStatsPanel:GetTall() * .3)
	PaintFrame(PlyStatsPanel)
		local iypos = PlyStatsPanel:GetTall() * .05
	
		local PlyStatsTitle = vgui.Create("DLabel", PlyStatsPanel)
		PlyStatsTitle:SetPos(PlyStatsPanel:GetWide() * .01, iypos)
		PlyStatsTitle:SetFont("chsh_stats_detailed")
		PlyStatsTitle:SetText("● Your stats: ")
		PlyStatsTitle:SetColor(borderColor)
		PlyStatsTitle:SizeToContents()
		
		iypos = iypos + PlyStatsTitle:GetTall()

		local PlaytimeTitle = vgui.Create("DLabel", PlyStatsPanel)
		PlaytimeTitle:SetPos(PlyStatsPanel:GetWide() * .01, iypos)
		PlaytimeTitle:SetFont("chsh_stats_detailed")
		PlaytimeTitle:SetText("Time Played: ")
		PlaytimeTitle:SetColor(Color(240, 180, 60, 255))
		PlaytimeTitle:SizeToContents()
		
		local PlayTime = vgui.Create("DLabel", PlyStatsPanel)
		PlayTime:SetPos(PlaytimeTitle:GetWide() + padding, iypos)
		PlayTime:SetFont("chsh_stats_detailed")
		PlayTime:SetText(TransformTime(GetPlaytime(ply)))
		PlayTime:SetColor(Color(255, 255, 255, 255))
		PlayTime:SizeToContents()
		
		iypos = iypos + PlyStatsTitle:GetTall()

		local CreditsTitle = vgui.Create("DLabel", PlyStatsPanel)
		CreditsTitle:SetPos(PlyStatsPanel:GetWide() * .01, iypos)
		CreditsTitle:SetFont("chsh_stats_detailed")
		CreditsTitle:SetText("Credits Held: ")
		CreditsTitle:SetColor(Color(240, 180, 60, 255))
		CreditsTitle:SizeToContents()
		
		local Credits = vgui.Create("DLabel", PlyStatsPanel)
		Credits:SetPos(CreditsTitle:GetWide() + padding, iypos)
		Credits:SetFont("chsh_stats_detailed")
		Credits:SetText(ReplaceCommaWithDot(string.Comma(GetCredits(ply))))
		Credits:SetColor(Color(255, 255, 255, 255))
		Credits:SizeToContents()
		
		iypos = iypos + PlyStatsTitle:GetTall()

		local AchivTitle = vgui.Create("DLabel", PlyStatsPanel)
		AchivTitle:SetPos(PlyStatsPanel:GetWide() * .01, iypos)
		AchivTitle:SetSize(PlyStatsPanel:GetWide() * .2, PlyStatsPanel:GetTall() * .25)
		AchivTitle:SetFont("chsh_stats_detailed")
		AchivTitle:SetText("Achievements earned: ")
		AchivTitle:SetColor(Color(240, 180, 60, 255))
		AchivTitle:SizeToContents()
		
		local Achivs = vgui.Create("DLabel", PlyStatsPanel)
		Achivs:SetPos(AchivTitle:GetWide() + padding, iypos)
		Achivs:SetFont("chsh_stats_detailed")
		Achivs:SetText(ReplaceCommaWithDot(string.Comma(0)) .." - (".. 0 .."%)")
		Achivs:SetColor(Color(255, 255, 255, 255))
		Achivs:SizeToContents()
	
	ypos = ypos + PlyStatsPanel:GetTall() * 1.05
	--
	
	-- Misc Stats
	local MiscStatsPanel = vgui.Create("DPanel", Scroll)
	MiscStatsPanel:SetPos(DetailedStatsPanel:GetWide() * .005, ypos)
	MiscStatsPanel:SetSize(DetailedStatsPanel:GetWide() * .99, DetailedStatsPanel:GetTall() * .3)
	PaintFrame(MiscStatsPanel)
		local iypos = PlyStatsPanel:GetTall() * .05
	
		local MiscStatsTitle = vgui.Create("DLabel", MiscStatsPanel)
		MiscStatsTitle:SetPos(MiscStatsPanel:GetWide() * .01, iypos)
		MiscStatsTitle:SetFont("chsh_stats_detailed")
		MiscStatsTitle:SetText("● Misc info: ")
		MiscStatsTitle:SetColor(borderColor)
		MiscStatsTitle:SizeToContents()
		
		iypos = iypos + MiscStatsTitle:GetTall()

		local EarnedTitle = vgui.Create("DLabel", MiscStatsPanel)
		EarnedTitle:SetPos(MiscStatsPanel:GetWide() * .01, iypos)
		EarnedTitle:SetFont("chsh_stats_detailed")
		EarnedTitle:SetText("Total Credits Earned: ")
		EarnedTitle:SetColor(Color(240, 180, 60, 255))
		EarnedTitle:SizeToContents()
		
		local Earned = vgui.Create("DLabel", MiscStatsPanel)
		Earned:SetPos(EarnedTitle:GetWide() + padding, iypos)
		Earned:SetFont("chsh_stats_detailed")
		Earned:SetText(ReplaceCommaWithDot(string.Comma(0)))
		Earned:SetColor(Color(255, 255, 255, 255))
		Earned:SizeToContents()
		
		iypos = iypos + MiscStatsTitle:GetTall()
		
		local SpentTitle = vgui.Create("DLabel", MiscStatsPanel)
		SpentTitle:SetPos(MiscStatsPanel:GetWide() * .01, iypos)
		SpentTitle:SetFont("chsh_stats_detailed")
		SpentTitle:SetText("Total Credits Spent: ")
		SpentTitle:SetColor(Color(240, 180, 60, 255))
		SpentTitle:SizeToContents()
		
		local Spent = vgui.Create("DLabel", MiscStatsPanel)
		Spent:SetPos(SpentTitle:GetWide() + padding, iypos)
		Spent:SetFont("chsh_stats_detailed")
		Spent:SetText(ReplaceCommaWithDot(string.Comma(0)))
		Spent:SetColor(Color(255, 255, 255, 255))
		Spent:SizeToContents()
		
		iypos = iypos + MiscStatsTitle:GetTall()
		
		local WatchedTitle = vgui.Create("DLabel", MiscStatsPanel)
		WatchedTitle:SetPos(MiscStatsPanel:GetWide() * .01, iypos)
		WatchedTitle:SetFont("chsh_stats_detailed")
		WatchedTitle:SetText("Amount of videos watched: ")
		WatchedTitle:SetColor(Color(240, 180, 60, 255))
		WatchedTitle:SizeToContents()
		
		local Watched = vgui.Create("DLabel", MiscStatsPanel)
		Watched:SetPos(WatchedTitle:GetWide() + padding, iypos)
		Watched:SetFont("chsh_stats_detailed")
		Watched:SetText(ReplaceCommaWithDot(string.Comma(0)))
		Watched:SetColor(Color(255, 255, 255, 255))
		Watched:SizeToContents()
	
	ypos = ypos + MiscStatsPanel:GetTall() * 1.05
	--
	
	-- Dangerzone Stats
	local DzStatsPanel = vgui.Create("DPanel", Scroll)
	DzStatsPanel:SetPos(DetailedStatsPanel:GetWide() * .005, ypos)
	DzStatsPanel:SetSize(DetailedStatsPanel:GetWide() * .99, DetailedStatsPanel:GetTall() * .24)
	PaintFrame(DzStatsPanel)
		local iypos = PlyStatsPanel:GetTall() * .05
	
		local DzStasTitle = vgui.Create("DLabel", DzStatsPanel)
		DzStasTitle:SetPos(DzStatsPanel:GetWide() * .01, iypos)
		DzStasTitle:SetFont("chsh_stats_detailed")
		DzStasTitle:SetText("● Dangerzone stats: ")
		DzStasTitle:SetColor(borderColor)
		DzStasTitle:SizeToContents()
		
		iypos = iypos + MiscStatsTitle:GetTall()

		local TotalKillsTitle = vgui.Create("DLabel", DzStatsPanel)
		TotalKillsTitle:SetPos(DzStatsPanel:GetWide() * .01, iypos)
		TotalKillsTitle:SetFont("chsh_stats_detailed")
		TotalKillsTitle:SetText("Total dangerzone kills: ")
		TotalKillsTitle:SetColor(Color(240, 180, 60, 255))
		TotalKillsTitle:SizeToContents()
		
		local TotalKills = vgui.Create("DLabel", DzStatsPanel)
		TotalKills:SetPos(TotalKillsTitle:GetWide() + padding, iypos)
		TotalKills:SetFont("chsh_stats_detailed")
		TotalKills:SetText(ReplaceCommaWithDot(string.Comma(0)))
		TotalKills:SetColor(Color(255, 255, 255, 255))
		TotalKills:SizeToContents()
		
		iypos = iypos + MiscStatsTitle:GetTall()
		
		local StreakTitle = vgui.Create("DLabel", DzStatsPanel)
		StreakTitle:SetPos(DzStatsPanel:GetWide() * .01, iypos)
		StreakTitle:SetFont("chsh_stats_detailed")
		StreakTitle:SetText("Total dangerzone deaths: ")
		StreakTitle:SetColor(Color(240, 180, 60, 255))
		StreakTitle:SizeToContents()
		
		local Streak = vgui.Create("DLabel", DzStatsPanel)
		Streak:SetPos(StreakTitle:GetWide() + padding, iypos)
		Streak:SetFont("chsh_stats_detailed")
		Streak:SetText(ReplaceCommaWithDot(string.Comma(0)))
		Streak:SetColor(Color(255, 255, 255, 255))
		Streak:SizeToContents()
		
	ypos = ypos + DzStatsPanel:GetTall() * 1.05
	--
	
	function UpdateStats()
		Level:SetText("Level ".. GetLevel(ply))
		
		xp = (GetXP(ply) / GetNeededXP(ply)) * (XPBar:GetWide() - 4)
		BarFill.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, math.Clamp(xp, 0, w), h, team.GetColor(ply:Team()))
		end
		
		local percent = GetXP(ply)/GetNeededXP(ply)
		percent = percent * 100
		XPPercentage:SetText(math.Round(percent) .."%")
		
		XPMarker:SetText(math.Round(GetXP(ply)) .." / ".. math.Round(GetNeededXP(ply)) .." xp")
		
		-- Stats detailed
		PlayTime:SetText(TransformTime(GetPlaytime(ply)))
		PlayTime:SizeToContents()
		Credits:SetText(ReplaceCommaWithDot(string.Comma(GetCredits(ply))))
		Credits:SizeToContents()
		
		local amountUnlocked = GetAmountAchObtained(ply)
		local percentAchivs = amountUnlocked / table.Count(achievements)
		percentAchivs = percentAchivs * 100
		
		Achivs:SetText(ReplaceCommaWithDot(string.Comma(amountUnlocked)) .."/".. ReplaceCommaWithDot(string.Comma(table.Count(achievements))) .." - (".. math.Round(percentAchivs) .."%)")
		Achivs:SizeToContents()
		Earned:SetText(ReplaceCommaWithDot(string.Comma(GetEarnedGeneral(ply))))
		Earned:SizeToContents()
		Spent:SetText(ReplaceCommaWithDot(string.Comma(GetWastedGeneral(ply))))
		Spent:SizeToContents()
		Watched:SetText(ReplaceCommaWithDot(string.Comma(GetVideosWatched(ply))))
		Watched:SizeToContents()
		TotalKills:SetText(ReplaceCommaWithDot(string.Comma(GetDangerzoneKills(ply))))
		TotalKills:SizeToContents()
		Streak:SetText(ReplaceCommaWithDot(string.Comma(GetDangerzoneDeaths(ply))))
		Streak:SizeToContents()
		--
		
	end
	
	if(IsValid(PFHelpSign))then
		PFHelpSign:SetText("This tab displays all of your player STATS.")
		PFHelpSign:SizeToContents()
	end
	
end

local STATS = {}

STATS.id = "Stats"

function STATS:GetID()
	return self.id
end

function STATS:Open()
	PF:CloseAllTabs()
	BuildStats(PFTabsPanel, LocalPlayer())
end

function STATS:Close()
	if(IsValid(StatsFrame))then
		StatsFrame:Remove()
	end
end

function STATS:Update()
	if(!IsValid(StatsFrame))then return end
	UpdateStats()
end

local function Initialize()
	table.insert(PF.tabs, 1, STATS)
end
hook.Add("chsh_load_profile", "load_stats", Initialize)