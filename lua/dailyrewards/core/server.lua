util.AddNetworkString("DAILYREWARDS_InitPlayer")
util.AddNetworkString("DAILYREWARDS_OpenMenu")
util.AddNetworkString("DAILYREWARDS_Notify")
util.AddNetworkString("DAILYREWARDS_ReceiveTime")
util.AddNetworkString("DAILYREWARDS_ReceiveClaimed")
util.AddNetworkString("DAILYREWARDS_ClaimReward")
util.AddNetworkString("DAILYREWARDS_PostReward")

local plymeta = FindMetaTable("Player")

hook.Add("Initialize", "DAILYREWARDS.removeOldData.HOOK", function()
	if DAILYREWARDS.CONFIG.ClearOldClaims then
		DAILYREWARDS.removeOldRewards()
	end
end)

net.Receive("DAILYREWARDS_InitPlayer", function(len, ply)
	ply:DAILYREWARDS_UpdateTimeData()
	if DAILYREWARDS.CONFIG.StoreClaimed then
		ply:DAILYREWARDS_UpdateClaimed()
	end
	DAILYREWARDS.OpenRewardMenu(ply)
end)

hook.Add("PlayerSay", "DAILYREWARDS.commandSend.HOOK", function(ply, text)
	if DAILYREWARDS.CONFIG.Commands[text:lower()] then
		DAILYREWARDS.OpenRewardMenu(ply)
		return ""
	end
end)

function DAILYREWARDS.OpenRewardMenu(ply)
	if not IsValid(ply) then return end

	if DAILYREWARDS.AccessPermission(ply) or DAILYREWARDS.CONFIG.AllowRistrictedViewAccess then
		net.Start("DAILYREWARDS_OpenMenu")
		net.Send(ply)
	else
		DAILYREWARDS.Notify(DAILYREWARDS:GetLang("no_perms"), ply)
	end
end

function DAILYREWARDS.Notify(msg, ply)
	if not IsValid(ply) then return end
	
	net.Start("DAILYREWARDS_Notify")
		net.WriteString(msg)
	net.Send(ply)
end

function plymeta:DAILYREWARDS_UpdateTimeData()
	self:DAILYREWARDS_fetchTime(function(val)
		local timetbl = {day = 1, amount = 0, time = os.date("%m/%d/%Y/%W", os.time())}
		if val then
			timetbl = {day = val.day, amount = val.amount, time = val.time}
		end
		net.Start("DAILYREWARDS_ReceiveTime")
			net.WriteTable(timetbl)
		net.Send(self)
	end)
end

function plymeta:DAILYREWARDS_UpdateClaimed()
	self:DAILYREWARDS_fetchClaimedRewards(function(val)
		local claimedtbl = {}
		if val != nil then
			claimedtbl = val
		end
		net.Start("DAILYREWARDS_ReceiveClaimed")
			net.WriteTable(claimedtbl)
		net.Send(self)
	end)
end

net.Receive("DAILYREWARDS_ClaimReward", function(len, ply)
	local rewardKey = net.ReadUInt(3)
	local rewardPlace = net.ReadUInt(2)
	if not rewardKey then return end
	if not rewardPlace then return end
	if not IsValid(ply) then return end
	if not DAILYREWARDS.AccessPermission(ply) then DAILYREWARDS.Notify(DAILYREWARDS:GetLang("no_perms"), ply) return end
	if rewardPlace == 0 then return end
	local rewardData = DAILYREWARDS.REWARDS.Reward[rewardKey]
	if not rewardData then return end
	if rewardData.Amount == 0 then return end
	if rewardData.Amount > 3 then return end
	local reward = rewardData.Rewards[math.random(1, #rewardData.Rewards)]
	if not reward then return end
	if not reward.Name or not reward.Display or not reward.Type or not reward.RewardData or not reward then return end
	
	ply:DAILYREWARDS_fetchTime(function(val)
		if val then
			if tonumber(val.amount) >= DAILYREWARDS.REWARDS.Reward[tonumber(val.day)].Amount and tostring(val.time) == os.date("%m/%d/%Y/%W", os.time()) then DAILYREWARDS.Notify(DAILYREWARDS:GetLang("all_claimed"), ply) return end

			local rewDay = tostring(val.time) == os.date("%m/%d/%Y/%W", os.time()) and tonumber(val.day) or tonumber(val.day) + 1
			local rewAmt = tostring(val.time) == os.date("%m/%d/%Y/%W", os.time()) and tonumber(val.amount) + 1 or 1
			
			if tonumber(val.day) > 6 and tostring(val.time) != os.date("%m/%d/%Y/%W", os.time()) then rewDay = 1 end
			if os.date("%W" , os.time()) != string.Right(tostring(val.time), 2) then rewDay = 1 end
			if tonumber(string.Right(string.Left(tostring(val.time), 5), 2)) != tonumber(os.date("%d", os.time())) - 1 and tostring(val.time) != os.date("%m/%d/%Y/%W", os.time()) then rewDay = 1 end
			if tonumber(val.amount) < DAILYREWARDS.REWARDS.Reward[tonumber(val.day)].Amount and tostring(val.time) != os.date("%m/%d/%Y/%W", os.time()) then rewDay = 1 end
			if rewardKey != rewDay then DAILYREWARDS.Notify(DAILYREWARDS:GetLang("not_reward_day"), ply) return end
			
			ply:DAILYREWARDS_updateTime(rewDay, rewAmt, os.date("%m/%d/%Y/%W", os.time()))
			if DAILYREWARDS.CONFIG.StoreClaimed then
				ply:DAILYREWARDS_updateClaimedRewards(os.date("%W", os.time()), rewDay, rewardPlace, reward)
			end
			if DAILYREWARDS.TYPES[reward.Type] and DAILYREWARDS.TYPES[reward.Type].OnClaim then
				DAILYREWARDS.TYPES[reward.Type].OnClaim(ply, reward.RewardData)
			end
		else
			if rewardKey != 1 then DAILYREWARDS.Notify(DAILYREWARDS:GetLang("not_reward_day"), ply) return end
			ply:DAILYREWARDS_updateTime(1, 1, os.date("%m/%d/%Y/%W", os.time()))
			if DAILYREWARDS.CONFIG.StoreClaimed then
				ply:DAILYREWARDS_updateClaimedRewards(os.date("%W", os.time()), 1, rewardPlace, reward)
			end
			if DAILYREWARDS.TYPES[reward.Type] and DAILYREWARDS.TYPES[reward.Type].OnClaim then
				DAILYREWARDS.TYPES[reward.Type].OnClaim(ply, reward.RewardData)
			end
		end
	end)

	net.Start("DAILYREWARDS_PostReward")
		net.WriteTable(reward)
	net.Send(ply)
end)
--{{ user_id }}