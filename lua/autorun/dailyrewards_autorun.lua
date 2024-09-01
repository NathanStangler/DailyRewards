DAILYREWARDS = DAILYREWARDS or {}
DAILYREWARDS.REWARDS = DAILYREWARDS.REWARDS or {
	Reward = {
		Rewards = {}
	}
}
DAILYREWARDS.CONFIG = DAILYREWARDS.CONFIG or {}

local function LoadSV(dir)
	if SERVER then
		include(dir)
	end
end

local function LoadCL(dir)
	if SERVER then
		AddCSLuaFile(dir)
	elseif CLIENT then
		include(dir)
	end
end

local function LoadSH(dir)
	LoadSV(dir)
	LoadCL(dir)
end

LoadSH("dailyrewards/config/config.lua")
LoadSH("dailyrewards/core/shared.lua")
LoadSH("dailyrewards/language/languages.lua")
LoadSV("dailyrewards/core/server.lua")
LoadSV("dailyrewards/config/sql_config.lua")
LoadSV("dailyrewards/database/sql.lua")
LoadSV("dailyrewards/rewards/reward_types.lua")
LoadCL("dailyrewards/core/client.lua")
LoadCL("dailyrewards/ui/components.lua")
LoadCL("dailyrewards/ui/menu.lua")

if CLIENT then
	surface.CreateFont("DRCloseButton", {font = "Default", size = 30, weight = 750})
	surface.CreateFont("DR80", {font = "Marlett", size = 80, weight = 650})
	surface.CreateFont("DR40", {font = "Marlett", size = 40, weight = 700})
	surface.CreateFont("DR24", {font = "Marlett", size = 24, weight = 600})
	surface.CreateFont("DR20", {font = "Marlett", size = 20, weight = 650})
	surface.CreateFont("DR17", {font = "Marlett", size = 17, weight = 650})
end