local hiddenCol = Color(DAILYREWARDS.CONFIG.UI.rewardHidden.r * 0.8, DAILYREWARDS.CONFIG.UI.rewardHidden.g * 0.8, DAILYREWARDS.CONFIG.UI.rewardHidden.b * 0.8)
local dsplPNL = nil

net.Receive("DAILYREWARDS_PostReward", function(len)
	local rewardClaimed = net.ReadTable() or {}

	if DAILYREWARDS.CONFIG.StoreClaimed and rewardClaimed and rewardClaimed.Display then
		if rewardClaimed.Display:find(".mdl") then
			DAILYREWARDS.Menu.RewardPanel.Reward.Model = dsplPNL:Add("DR.Model")
			DAILYREWARDS.Menu.RewardPanel.Reward.Model:SetModel(rewardClaimed.Display)
		else
			DAILYREWARDS.Menu.RewardPanel.Reward.Image = dsplPNL:Add("DR.Image")
			DAILYREWARDS.Menu.RewardPanel.Reward.Image:SetImage(DAILYREWARDS.ReceiveImage(rewardClaimed.Display, DAILYREWARDS.Menu.RewardPanel.Reward.Image))
		end
	end
	DAILYREWARDS.OpenReceiveReward(rewardClaimed)
end)

function DAILYREWARDS.OpenMenu()
	DAILYREWARDS.Menu = vgui.Create("DR.Frame")
	DAILYREWARDS.Menu:SetSize(ScrW()*.5, ScrH()*.6)
	DAILYREWARDS.Menu:Center()
	DAILYREWARDS.Menu:MakePopup(true)
	DAILYREWARDS.Menu.PaintOver = function(self, w, h)
		draw.SimpleText(DAILYREWARDS.CONFIG.ServerName, "DR40", w / 2, ScrH()*.07, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	DAILYREWARDS.Menu.Header.PaintOver = function(self, w, h)
		draw.SimpleText(DAILYREWARDS:GetLang("daily_rewards"), "DR24", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local rewardSize = ((DAILYREWARDS.Menu:GetWide() - (DAILYREWARDS.Menu:GetWide() * 0.07) - (5 * 7)) / 7)
	local rewardTime = LocalPlayer():DAILYREWARDS_ReceiveTime()

	for i=1, 7 do
		DAILYREWARDS.Menu.RewardPanel = DAILYREWARDS.Menu:Add("DPanel")
		DAILYREWARDS.Menu.RewardPanel:SetSize(rewardSize, DAILYREWARDS.Menu:GetTall() * 0.7)
		DAILYREWARDS.Menu.RewardPanel:SetPos(DAILYREWARDS.Menu:GetWide() / 7 * i - rewardSize - i * 1.5, DAILYREWARDS.Menu:GetTall() * 0.25)
		DAILYREWARDS.Menu.RewardPanel.Paint = function(self, w, h)
			draw.RoundedBoxEx(4, 0, 0, w, h, DAILYREWARDS.CONFIG.UI.rewardPanel, false, false, true, true)
		end
		
		DAILYREWARDS.Menu.DayPanel = DAILYREWARDS.Menu:Add("DButton")
		DAILYREWARDS.Menu.DayPanel:SetText("")
		DAILYREWARDS.Menu.DayPanel:SetSize(rewardSize, DAILYREWARDS.Menu:GetTall() * 0.05)
		local x, y = DAILYREWARDS.Menu.RewardPanel:GetPos()
		DAILYREWARDS.Menu.DayPanel:SetPos(DAILYREWARDS.Menu:GetWide() / 7 * i - rewardSize - i * 1.5, DAILYREWARDS.Menu:GetTall() * 0.18)
		DAILYREWARDS.Menu.DayPanel.Paint = function(self, w, h)
			draw.RoundedBoxEx(4, 0, 0, w, h, self:IsHovered() and DAILYREWARDS.CONFIG.UI.rewardPanel or DAILYREWARDS.CONFIG.UI.rewardHidden, true, true, false, false)
			draw.RoundedBoxEx(4, 2, 2, w - 4, h - 4, self:IsHovered() and DAILYREWARDS.CONFIG.UI.buttonHover or DAILYREWARDS.CONFIG.UI.buttonbg, true, true, false, false)
			draw.SimpleText(DAILYREWARDS:GetLang("day")..i, "DR20", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		DAILYREWARDS.Menu.DayPanel.DoClick = function()
			DAILYREWARDS.OpenRewardOptions(i)
		end
		
		if DAILYREWARDS.REWARDS.Reward[i] and DAILYREWARDS.REWARDS.Reward[i].Amount then
			for amt=1, DAILYREWARDS.REWARDS.Reward[i].Amount do
				DAILYREWARDS.Menu.RewardPanel.Reward = DAILYREWARDS.Menu.RewardPanel:Add("DR.Button")
				DAILYREWARDS.Menu.RewardPanel.Reward:SetSize((DAILYREWARDS.Menu.RewardPanel:GetTall() / 3) - 16, (DAILYREWARDS.Menu.RewardPanel:GetTall() / 3) - 16)
				DAILYREWARDS.Menu.RewardPanel.Reward:DockMargin(5, 8, 5, 8)
				DAILYREWARDS.Menu.RewardPanel.Reward:Dock(TOP)
				DAILYREWARDS.Menu.RewardPanel.Reward:SetText("?")
				DAILYREWARDS.Menu.RewardPanel.Reward.DoClick = function(self)
					if self:GetEnabled() then
						if DAILYREWARDS.AccessPermission(LocalPlayer()) then
							net.Start("DAILYREWARDS_ClaimReward")
								net.WriteUInt(i, 3)
								net.WriteUInt(amt, 2)
							net.SendToServer()
							
							self:SetText("✓")
							self:SetEnabled(false)
							self:SetReward(DAILYREWARDS:GetLang("not_claimable"))
							dsplPNL = self
						else
							notification.AddLegacy(DAILYREWARDS:GetLang("no_perms"), 1, 3)
						end
					end
				end

				local claimed = DAILYREWARDS.ClaimedReward(i, amt)

				if DAILYREWARDS.GetRewardDay(rewardTime) == i then
					DAILYREWARDS.Menu.RewardPanel.Reward:SetOutlineHoverColor(DAILYREWARDS.CONFIG.UI.rewardHidden)
					DAILYREWARDS.Menu.RewardPanel.Reward:SetOutlineUnhoverColor(hiddenCol)
					if tonumber(rewardTime.amount) >= amt and tostring(rewardTime.time) == os.date("%m/%d/%Y/%W", os.time()) then
						DAILYREWARDS.Menu.RewardPanel.Reward:SetText("✓")
						DAILYREWARDS.Menu.RewardPanel.Reward:SetEnabled(false)
					else
						DAILYREWARDS.Menu.RewardPanel.Reward:SetReward(DAILYREWARDS:GetLang("claimable"))
					end
				else
					DAILYREWARDS.Menu.RewardPanel.Reward:SetOutlineUnhoverColor(DAILYREWARDS.CONFIG.UI.rewardBlocked)
					DAILYREWARDS.Menu.RewardPanel.Reward:SetEnabled(false)
					if DAILYREWARDS.CONFIG.StoreClaimed and tostring(claimed.week) == os.date("%W", os.time()) and tonumber(claimed.day) <= DAILYREWARDS.GetRewardDay(rewardTime) then
						DAILYREWARDS.Menu.RewardPanel.Reward:SetText("✓")
					else
						DAILYREWARDS.Menu.RewardPanel.Reward:SetText("X")
					end
				end

				if DAILYREWARDS.CONFIG.StoreClaimed and tostring(claimed.week) == os.date("%W", os.time()) and tonumber(claimed.day) <= DAILYREWARDS.GetRewardDay(rewardTime) and not DAILYREWARDS.Menu.RewardPanel.Reward:GetEnabled() then
					if util.JSONToTable(claimed.data).Display:find(".mdl") then
						DAILYREWARDS.Menu.RewardPanel.Reward.Model = DAILYREWARDS.Menu.RewardPanel.Reward:Add("DR.Model")
						DAILYREWARDS.Menu.RewardPanel.Reward.Model:SetModel(util.JSONToTable(claimed.data).Display)
					else
						DAILYREWARDS.Menu.RewardPanel.Reward.Image = DAILYREWARDS.Menu.RewardPanel.Reward:Add("DR.Image")
						DAILYREWARDS.Menu.RewardPanel.Reward.Image:SetImage(DAILYREWARDS.ReceiveImage(util.JSONToTable(claimed.data).Display, DAILYREWARDS.Menu.RewardPanel.Reward.Image))
					end
				end
				
			end
		end
	end
end

function DAILYREWARDS.OpenReceiveReward(reward)
	if IsValid(DAILYREWARDS.RewardOptions) then DAILYREWARDS.RewardOptions:Remove() end
	if IsValid(DAILYREWARDS.ReceiveReward) then DAILYREWARDS.ReceiveReward:Remove() end
	
	DAILYREWARDS.ReceiveReward = vgui.Create("DR.Frame")
	surface.SetFont("DR24")
	local pnlW = surface.GetTextSize(DAILYREWARDS:GetLang("reward"))
	DAILYREWARDS.ReceiveReward:SetSize(pnlW + 35 >= ScrW()*.14 and pnlW + 55 or ScrW()*.14, ScrW()*.18)
	DAILYREWARDS.ReceiveReward:Center()
	DAILYREWARDS.ReceiveReward:MakePopup(true)
	DAILYREWARDS.ReceiveReward.Header.PaintOver = function(self, w, h)
		draw.SimpleText(DAILYREWARDS:GetLang("reward"), "DR24", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	DAILYREWARDS.ReceiveReward.ModelPanel = DAILYREWARDS.ReceiveReward:Add("DPanel")
	DAILYREWARDS.ReceiveReward.ModelPanel:Dock(FILL)
	DAILYREWARDS.ReceiveReward.ModelPanel:DockMargin(15, 10, 15, 60)
	DAILYREWARDS.ReceiveReward.ModelPanel.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, DAILYREWARDS.CONFIG.UI.buttonbg)
		draw.RoundedBox(8, 3, 3, w - 6, h - 6, DAILYREWARDS.CONFIG.UI.rewardHidden)
	end
	
	if reward.Display then
		if reward.Display:find(".mdl") then
			DAILYREWARDS.ReceiveReward.Model = DAILYREWARDS.ReceiveReward.ModelPanel:Add("DR.Model")
			DAILYREWARDS.ReceiveReward.Model:DockMargin(6, 6, 6, 6)
			DAILYREWARDS.ReceiveReward.Model:SetModel(reward.Display)
		else
			DAILYREWARDS.ReceiveReward.Image = DAILYREWARDS.ReceiveReward.ModelPanel:Add("DR.Image")
			DAILYREWARDS.ReceiveReward.Image:DockMargin(6, 6, 6, 6)
			DAILYREWARDS.ReceiveReward.Image:SetImage(DAILYREWARDS.ReceiveImage(reward.Display, DAILYREWARDS.ReceiveReward.Image))
		end
	end
	
	if reward.Name then
		DAILYREWARDS.ReceiveReward.TextPanel = DAILYREWARDS.ReceiveReward:Add("DPanel")
		DAILYREWARDS.ReceiveReward.TextPanel:Dock(FILL)
		DAILYREWARDS.ReceiveReward.TextPanel:DockMargin(15, ScrW()*.18-80, 15, 10)
		DAILYREWARDS.ReceiveReward.TextPanel.Paint = function(self, w, h)
			draw.RoundedBox(8, 0, 0, w, h, DAILYREWARDS.CONFIG.UI.buttonbg)
			draw.RoundedBox(8, 3, 3, w - 6, h - 6, DAILYREWARDS.CONFIG.UI.rewardHidden)
			draw.SimpleText(reward.Name, "DR17", w / 2, h / 2, DAILYREWARDS.CONFIG.UI.grayText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

function DAILYREWARDS.OpenRewardOptions(reward)
	if IsValid(DAILYREWARDS.ReceiveReward) then DAILYREWARDS.ReceiveReward:Remove() end
	if IsValid(DAILYREWARDS.RewardOptions) then DAILYREWARDS.RewardOptions:Remove() end
	
	DAILYREWARDS.RewardOptions = vgui.Create("DR.Frame")
	surface.SetFont("DR24")
	local pnlW = surface.GetTextSize(DAILYREWARDS:GetLang("possible_reward"))
	DAILYREWARDS.RewardOptions:SetSize(pnlW + 35 >= ScrW()*.14 and pnlW + 55 or ScrW()*.14, ScrW()*.18)
	DAILYREWARDS.RewardOptions:Center()
	DAILYREWARDS.RewardOptions:MakePopup(true)
	DAILYREWARDS.RewardOptions.Header.PaintOver = function(self, w, h)
		draw.SimpleText(DAILYREWARDS:GetLang("possible_reward"), "DR24", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	DAILYREWARDS.RewardOptions.Panel = DAILYREWARDS.RewardOptions:Add("DScrollPanel")
	DAILYREWARDS.RewardOptions.Panel:Dock(FILL)
	DAILYREWARDS.RewardOptions.Panel:DockMargin(0, 10, 0, 10)
	DAILYREWARDS.RewardOptions.Panel:GetVBar():SetWide(0)
	for key, value in pairs(DAILYREWARDS.REWARDS.Reward[reward].Rewards) do
		DAILYREWARDS.RewardOptions.Text = DAILYREWARDS.RewardOptions.Panel:Add("DLabel")
		DAILYREWARDS.RewardOptions.Text:SetText(value.Name)
		DAILYREWARDS.RewardOptions.Text:SetFont("DR20")
		DAILYREWARDS.RewardOptions.Text:Dock(TOP)
		DAILYREWARDS.RewardOptions.Text:DockMargin(0, 0, 0, 10)
		DAILYREWARDS.RewardOptions.Text:SetContentAlignment(5)
	end
end

concommand.Add("dailyrewards", function(ply)
	if DAILYREWARDS.AccessPermission(ply) or DAILYREWARDS.CONFIG.AllowRistrictedViewAccess then
		if IsValid(DAILYREWARDS.Menu) then DAILYREWARDS.Menu:Remove() end
		if IsValid(DAILYREWARDS.ReceiveReward) then DAILYREWARDS.ReceiveReward:Remove() end
		if IsValid(DAILYREWARDS.RewardOptions) then DAILYREWARDS.RewardOptions:Remove() end
		DAILYREWARDS.OpenMenu()
	else
		notification.AddLegacy(DAILYREWARDS:GetLang("no_perms"), 1, 3)
	end
end)