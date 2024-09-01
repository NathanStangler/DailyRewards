DAILYREWARDS.Language = DAILYREWARDS.Language or {}

function DAILYREWARDS:CreateLang(lang, text)
	self.Language[lang] = text
end

function DAILYREWARDS:GetLang(text)
	if not self.Language[DAILYREWARDS.CONFIG.Language] then return "Language not found" end
	if not self.Language[DAILYREWARDS.CONFIG.Language][text] then return "Text not found" end
	return self.Language[DAILYREWARDS.CONFIG.Language][text]
end

DAILYREWARDS:CreateLang("en", {
	daily_rewards = "Daily Rewards",
	reward = "Reward",
	possible_reward = "Possible Rewards",
	day = "Day ",
	all_claimed = "You have claimed all rewards today!",
	not_reward_day = "You can't claim a reward for this day yet!",
	no_perms = "You don't have the proper rank to do this!",
	claimable = "Claimable",
	not_claimable = "Not Claimable"
})