DAILYREWARDS.TYPES = DAILYREWARDS.TYPES or {}

DAILYREWARDS.TYPES["DarkRP Cash"] = {
	OnClaim = function(ply, amt)
		ply:addMoney(amt)
	end
}
DAILYREWARDS.TYPES["Weapon"] = {
	OnClaim = function(ply, class)
		ply:Give(class)
	end
}
DAILYREWARDS.TYPES["Entity"] = {
	OnClaim = function(ply, class)
		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 50
		trace.filter = ply
		local trl = util.TraceLine(trace)
		local entity = ents.Create(class)
		entity:SetPos(trl.HitPos)
		entity:Spawn()
	end
}
DAILYREWARDS.TYPES["PS1"] = {
	OnClaim = function(ply, amt)
		ply:PS_GivePoints(amt)
	end
}
DAILYREWARDS.TYPES["PS2"] = {
	OnClaim = function(ply, amt)
		ply:PS2_AddStandardPoints(amt)
	end
}
DAILYREWARDS.TYPES["PS2 Premium"] = {
	OnClaim = function(ply, amt)
		ply:PS2_AddPremiumPoints(amt)
	end
}
DAILYREWARDS.TYPES["XP"] = {
	OnClaim = function(ply, amt)
		if Sublime then
			ply:SL_AddExperience(amt, "Daily Reward")
		else
			ply:addXP(amt, true)
		end
	end
}
DAILYREWARDS.TYPES["Level"] = {
	OnClaim = function(ply, amt)
		if Sublime then
			ply:SL_LevelUp(amt)
		else
			ply:addLevels(amt)
		end
	end
}