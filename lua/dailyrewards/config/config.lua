--This is what will display in the open space at the top of the menu.
DAILYREWARDS.CONFIG.ServerName = "Daily Rewards"
--If true then the menu will open when the player joins the server.
DAILYREWARDS.CONFIG.OpenOnConnect = true
--This will store data of the rewards a player claims.
--This can use high amounts of storage space, so if set to true it is recommended that ClearOldClaims is also true.
DAILYREWARDS.CONFIG.StoreClaimed = true
--This will clear stored claim data that is from a previous week every time the server starts.
--Only set to true if StoreClaimed is set to true.
DAILYREWARDS.CONFIG.ClearOldClaims = true
--If true then ranks that are not in AccessRanks will be able to open the menu, but they won't be able to claim rewards.
DAILYREWARDS.CONFIG.AllowRistrictedViewAccess = true
--This is the language that will be used, possible languages can be found dailyrewards\language\languages.lua
DAILYREWARDS.CONFIG.Language = "en"

--These are the ranks that can use the menu.
--You can allow ranks that don't have access to view the menu just not claim rewards with the previous option.
--This supports Secondary User Groups and rank systems that use "GetUserGroup()"
--Leave the table empty to give access to everyone.
--Follow the current format when changing the accessed ranks.
DAILYREWARDS.CONFIG.AccessRanks = {
	--["Bronze"] = true
}

--These are the commands that will open the menu.
--Follow the current format when changing the commands.
DAILYREWARDS.CONFIG.Commands = {
	["/rewards"] = true,
	["!rewards"] = true,
	["/dailyrewards"] = true,
	["!dailyrewards"] = true,
	["/dr"] = true,
	["!dr"] = true
}

--These are where you can configure the possible rewards.
--Rewards will restart to day 1 at the end of every week.
--Rewards are random for each client, when the player clicks the reward it will randomly choose a reward from that day.
--This will repeat for each reward, the amount of reward that day can be changed with the "Amount" value.
--The amount can be 0 to 3, only 3 rewards can be per day.
--If you want there to be no rewards in a day, set "Amount" to 0, do not delete the full table for that day.
--Rewards can be added under DAILYREWARDS.REWARDS.Reward[DAY].Rewards.
--You can add custom reward types in dailyrewards\rewards\reward_types.lua

--Here is an example day.
--[[
DAILYREWARDS.REWARDS.Reward[1] = { --The 1 represents the day of the reward, this is based on the first day of the week.
	Amount = 3, --Amount is how many rewards there will be that day, max is 3.
	Rewards = {
		{
			Name = "Crowbar", --This is what will be displayed when the reward is claimed.
			Display = "models/weapons/w_crowbar.mdl", --This is what will be displayed when the reward is claimed. Can be a model(.mdl) or an image link.
			Type = "Weapon", --This is the type of reward, there are some setup already, however you can create your own easily.
			RewardData = "weapon_crowbar" --This is the data for the reward, this will be needed data for the reward type, ex. amount or weapon class.
		}
	}
}
]]

--This is where the actual rewards are.
DAILYREWARDS.REWARDS.Reward[1] = { --This is the first day.
	Amount = 1, --There will be 3 claimable rewards on this day.
	Rewards = {
		{Name = "Crowbar", Display = "models/weapons/w_crowbar.mdl", Type = "Weapon", RewardData = "weapon_crowbar"} --This is a reward of a crowbar with a model.
	}
}
DAILYREWARDS.REWARDS.Reward[2] = {
	Amount = 2,
	Rewards = {
		{Name = "5000 XP", Display = "https://i.imgur.com/wn3rFDH.png", Type = "XP", RewardData = "5000"} --This is a reward of 5000 XP with an image.
	}
}
DAILYREWARDS.REWARDS.Reward[3] = {
	Amount = 3,
	Rewards = {
		{Name = "100K DarkRP Cash", Display = "models/props/cs_assault/money.mdl", Type = "DarkRP Cash", RewardData = "100000"}, --This is a reward of 100 thousand DarkRP Cash with a model.
		{Name = "100 Pointshop 1 Points", Display = "https://i.imgur.com/fnbIlGn.png", Type = "PS1", RewardData = "100"} --This is a reward of 100 Pointshop 1 Points with an image.
	}
}
DAILYREWARDS.REWARDS.Reward[4] = {
	Amount = 1,
	Rewards = {
		{Name = "100 Pointshop 2 Points", Display = "https://i.imgur.com/fnbIlGn.png", Type = "PS2", RewardData = "100"} --This is a reward of 100 Pointshop 2 Points with an image.
	}
}
DAILYREWARDS.REWARDS.Reward[5] = {
	Amount = 2,
	Rewards = {
		{Name = "100 Pointshop 2 Premium Points", Display = "https://i.imgur.com/fnbIlGn.png", Type = "PS2 Premium", RewardData = "100"} --This is a reward of 100 Pointshop 2 Premium Points with an image.
	}
}
DAILYREWARDS.REWARDS.Reward[6] = {
	Amount = 1,
	Rewards = {
		{Name = "HEV Suit", Display = "models/items/hevsuit.mdl", Type = "Entity", RewardData = "item_suit"} --This is a reward of a HEV suit with a model.
	}
}
DAILYREWARDS.REWARDS.Reward[7] = {
	Amount = 2,
	Rewards = {
		{Name = "5 Levels", Display = "https://i.imgur.com/wn3rFDH.png", Type = "Level", RewardData = "5"} --This is a reward of 5 Levels with an image.
	}
}

--This is were you can change the menu's colors.
DAILYREWARDS.CONFIG.UI = {
	background = Color(35, 35, 35),
	header = Color(45, 45, 45),
	buttonbg = Color(70, 70, 70),
	buttonHover = Color(80, 80, 80),
	closeButton = Color(225, 50, 65),
	grayText = Color(180, 180, 180),
	rewardPanel = Color(55, 55, 55),
	rewardHidden = Color(50, 50, 50),
	rewardBlocked = Color(200, 90, 90)
}