function DAILYREWARDS.AccessPermission(ply)
	if table.IsEmpty(DAILYREWARDS.CONFIG.AccessRanks) then
		return true
	elseif DAILYREWARDS.CONFIG.AccessRanks[ply:GetUserGroup()] then
		return true
	elseif SG then
		if DAILYREWARDS.CONFIG.AccessRanks[ply:GetSecondaryUserGroup()] then
			return true
		end
	end

	return false
end