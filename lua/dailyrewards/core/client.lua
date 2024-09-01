local plymeta = FindMetaTable("Player")
local DAILYREWARDS_RewardTime = {}
local DAILYREWARDS_RewardsClaimed = {}

hook.Add("InitPostEntity", "DAILYREWARDS.fetchPlayerData.HOOK", function(ply)
	net.Start("DAILYREWARDS_InitPlayer")
	net.SendToServer()
end)

net.Receive("DAILYREWARDS_OpenMenu", function(len, ply)
	DAILYREWARDS.OpenMenu()
end)

net.Receive("DAILYREWARDS_Notify", function(len, ply)
	local notifyString = net.ReadString()

	if not notifyString then return end
	notification.AddLegacy(notifyString, 1, 3)
end)

net.Receive("DAILYREWARDS_ReceiveTime", function(len, ply)
	local rewardTime = net.ReadTable() or {}

	DAILYREWARDS_RewardTime = rewardTime
end)

net.Receive("DAILYREWARDS_ReceiveClaimed", function(len, ply)
	local claimedRewards = net.ReadTable() or {}

	DAILYREWARDS_RewardsClaimed = claimedRewards
end)

function plymeta:DAILYREWARDS_ReceiveTime()
	local ClaimedTime = {}
	
	if self == LocalPlayer() then
		if DAILYREWARDS_RewardTime then
			ClaimedTime = DAILYREWARDS_RewardTime
		end
	elseif self.DAILYREWARDS_RewardTime then
		ClaimedTime = self.DAILYREWARDS_RewardTime
	end
	
	return ClaimedTime
end

function plymeta:DAILYREWARDS_ReceiveClaimed()
	local Claimed = {}
	
	if self == LocalPlayer() then
		if DAILYREWARDS_RewardsClaimed then
			Claimed = DAILYREWARDS_RewardsClaimed
		end
	elseif self.DAILYREWARDS_RewardsClaimed then
		Claimed = self.DAILYREWARDS_RewardsClaimed
	end
	
	return Claimed
end

function DAILYREWARDS.ClaimedReward(day, place)
    for i in ipairs(LocalPlayer():DAILYREWARDS_ReceiveClaimed()) do
        if tonumber(LocalPlayer():DAILYREWARDS_ReceiveClaimed()[i].day) == day and tonumber(LocalPlayer():DAILYREWARDS_ReceiveClaimed()[i].placement) == place then
            return LocalPlayer():DAILYREWARDS_ReceiveClaimed()[i]
        end
    end
	return {}
end

function DAILYREWARDS.ReceiveImage(url, panel)
	local fileType = string.Split(url, ".")
	local fileName = "dailyrewards/"..util.CRC(url).."."..(fileType[#fileType] or "png")

	if not file.IsDir("dailyrewards", "DATA") then
		file.CreateDir("dailyrewards")
	end

	if file.Exists(fileName, "DATA") then
		return Material("data/"..fileName, "noclamp smooth")
	else
		http.Fetch(url, function(body)
			if not body then
				return nil
			end

			file.Write(fileName, body)
			if panel then
				panel.Paint = function(self, w, h)
					if Material("data/"..fileName, "noclamp smooth") then
						surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(Material("data/"..fileName, "noclamp smooth"))
						surface.DrawTexturedRect(0, 0, w, h)
					end
				end
			end
			return Material("data/"..fileName, "noclamp smooth")
		end)
	end
end

function DAILYREWARDS.GetRewardDay(rewardTime)
	if tonumber(rewardTime.day) > 6 and tostring(rewardTime.time) != os.date("%m/%d/%Y/%W", os.time()) then return 1
	elseif os.date("%W" , os.time()) != string.Right(tostring(rewardTime.time), 2) then return 1
	elseif tonumber(string.Right(string.Left(tostring(rewardTime.time), 5), 2)) != tonumber(os.date("%d", os.time())) - 1 and tostring(rewardTime.time) != os.date("%m/%d/%Y/%W", os.time()) then return 1
	elseif tonumber(rewardTime.amount) < DAILYREWARDS.REWARDS.Reward[tonumber(rewardTime.day)].Amount and tostring(rewardTime.time) != os.date("%m/%d/%Y/%W", os.time()) then return 1
	elseif tostring(rewardTime.time) == os.date("%m/%d/%Y/%W", os.time()) then return tonumber(rewardTime.day)
	else return tonumber(rewardTime.day) + 1 end
end