local plymeta = FindMetaTable("Player")

if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
	require("mysqloo")
end

local function connectDatabase()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		database = mysqloo.connect(DAILYREWARDS.CONFIG.MySQL.Host, DAILYREWARDS.CONFIG.MySQL.Username, DAILYREWARDS.CONFIG.MySQL.Password, DAILYREWARDS.CONFIG.MySQL.Database, DAILYREWARDS.CONFIG.MySQL.Port)
		
		function database:onConnectionFailed(err)
			print("[Daily Rewards] Failed to connect to database! Error: "..err)
		end
		
		database:setAutoReconnect(true)
		database:connect()

		local query = database:query("CREATE TABLE IF NOT EXISTS DailyRewards (`steamid` VARCHAR(64) NOT NULL PRIMARY KEY UNIQUE, `day` INT, `amount` INT, `time` TEXT)")

		function query:onError(err)
			print("[Daily Rewards] Error: "..err)
		end
		
		query:start()
		
		local query2 = database:query("CREATE TABLE IF NOT EXISTS DailyRewards_claimed (`steamid` VARCHAR(64) NOT NULL, `week` INT, `day` INT, `placement` INT, `data` TEXT)")

		function query2:onError(err)
			print("[Daily Rewards] Error: "..err)
		end

		query2:start()
	else
		local query = sql.Query("CREATE TABLE IF NOT EXISTS DailyRewards (`steamid` VARCHAR(64) NOT NULL PRIMARY KEY UNIQUE, `day` INT, `amount` INT, `time` TEXT)")
		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		end
		
		local query2 = sql.Query("CREATE TABLE IF NOT EXISTS DailyRewards_claimed(`steamid` VARCHAR(64) NOT NULL, `week` INT, `day` INT, `placement` INT, `data` TEXT)")
		
		if query2 == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		end
	end
end

connectDatabase()

function DAILYREWARDS.removeOldRewards()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		local query = database:query("SELECT * FROM DailyRewards_claimed")
		function query:onSuccess(data)
			local query = database:query("DELETE FROM DailyRewards_claimed WHERE week != '"..os.date("%W", os.time()).."'")
				
			function query:onError(err)
				print("[Daily Rewards] Error: "..err)
			end
				
			query:start()
		end
		
		function query:onError(err)
			print("[Daily Rewards] Error: "..err)
		end
		
		query:start()
	else
		local query = sql.Query("DELETE FROM DailyRewards_claimed WHERE week != '"..os.date("%W", os.time()).."'")
		
		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		end
	end
end

function plymeta:DAILYREWARDS_updateTime(day, amt, tme)
	local plyID = self:SteamID64()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		local query = database:query("SELECT * FROM DailyRewards WHERE steamid = '"..plyID.."'")
		function query:onSuccess(data)
			if data[1] then
				local query = database:query("UPDATE DailyRewards SET day = '"..day.."', amount = '"..amt.."', time = '"..database:escape(tme).."' WHERE steamid = '"..plyID.."'")
				
				function query:onSuccess(data)
					self:DAILYREWARDS_UpdateTimeData()
				end
				
				function query:onError(err)
					print("[Daily Rewards] Error: "..err)
				end
				
				query:start()
			else
				local query = database:query("INSERT INTO DailyRewards (`steamid`, `day`, `amount`, `time`) VALUES ('"..database:escape(plyID).."', '"..day.."', '"..amt.."', '"..database:escape(tme).."')")

				function query:onSuccess()
					self:DAILYREWARDS_UpdateTimeData()
				end

				function query:onError(err)
					print("[Daily Rewards] Error: "..err)
				end
				
				query:start()
			end
		end
		
		function query:onError(err)
			print("[Daily Rewards] Error: "..err)
		end
		
		query:start()
	else
		local query = sql.Query("SELECT * FROM DailyRewards WHERE steamid = '"..plyID.."'")
		
		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		else
			if query != nil and query[1] != nil then
				local query = sql.Query("UPDATE DailyRewards SET day = '"..sql.SQLStr(day, true).."', amount = '"..sql.SQLStr(amt, true).."', time = '"..sql.SQLStr(tme, true).."' WHERE steamid = '"..plyID.."'")
				
				if query == false then
					print("[Daily Rewards] Error: "..sql.LastError())
				else
					self:DAILYREWARDS_UpdateTimeData()
				end
			else
				local query = sql.Query("INSERT INTO DailyRewards (`steamid`, `day`, `amount`, `time`) VALUES ('"..sql.SQLStr(plyID, true).."', '"..sql.SQLStr(day, true).."', '"..sql.SQLStr(amt, true).."', '"..sql.SQLStr(tme, true).."')")
				
				if query == false then
					print("[Daily Rewards] Error: "..sql.LastError())
				else
					self:DAILYREWARDS_UpdateTimeData()
				end
			end
		end
	end
end

function plymeta:DAILYREWARDS_updateClaimedRewards(week, day, place, itemData)
	local plyID = self:SteamID64()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		local query = database:query("SELECT * FROM DailyRewards_claimed WHERE steamid = '"..plyID.."' AND day = '"..day.."' AND placement = '"..place.."'")
		function query:onSuccess(data)
			if data[1] then
				local query = database:query("UPDATE DailyRewards_claimed SET week = '"..database:escape(week).."', day = '"..day.."', placement = '"..place.."', data = '"..database:escape(util.TableToJSON(itemData)).."' WHERE steamid = '"..plyID.."' AND day = '"..day.."' AND placement = '"..place.."'")
				
				function query:onSuccess()
					self:DAILYREWARDS_UpdateClaimed()
				end
				
				function query:onError(err)
					print("[Daily Rewards] Error: "..err)
				end
				
				query:start()
			else
				local query = database:query("INSERT INTO DailyRewards_claimed (`steamid`, `week`, `day`, `placement`, `data`) VALUES ('"..database:escape(plyID).."', '"..database:escape(week).."', '"..day.."', '"..place.."', '"..database:escape(util.TableToJSON(itemData)).."')")

				function query:onSuccess()
					self:DAILYREWARDS_UpdateClaimed()
				end

				function query:onError(err)
					print("[Daily Rewards] Error: "..err)
				end
				
				query:start()
			end
		end
		
		function query:onError(err)
			print("[Daily Rewards] Error: "..err)
		end
		
		query:start()
	else
		local query = sql.Query("SELECT * FROM DailyRewards_claimed WHERE steamid = '"..plyID.."' AND day = '"..day.."' AND placement = '"..place.."'")
		
		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		else
			if query != nil and query[1] != nil then
				local query = sql.Query("UPDATE DailyRewards_claimed SET week = '"..sql.SQLStr(week, true).."', day = '"..sql.SQLStr(day, true).."', placement = '"..sql.SQLStr(place, true).."', data = '"..sql.SQLStr(util.TableToJSON(itemData), true).."' WHERE steamid = '"..plyID.."' AND day = '"..day.."' AND placement = '"..place.."'")
				
				if query == false then
					print("[Daily Rewards] Error: "..sql.LastError())
				else
					self:DAILYREWARDS_UpdateClaimed()
				end
			else
				local query = sql.Query("INSERT INTO DailyRewards_claimed (`steamid`, `week`, `day`, `placement`, `data`) VALUES ('"..sql.SQLStr(plyID, true).."', '"..sql.SQLStr(week, true).."', '"..sql.SQLStr(day, true).."', '"..sql.SQLStr(place, true).."', '"..sql.SQLStr(util.TableToJSON(itemData), true).."')")
				
				if query == false then
					print("[Daily Rewards] Error: "..sql.LastError())
				else
					self:DAILYREWARDS_UpdateClaimed()
				end
			end
		end
	end
end

function plymeta:DAILYREWARDS_fetchTime(val)
	local plyID = self:SteamID64()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		local query = database:query("SELECT * FROM DailyRewards WHERE steamid = '"..plyID.."'")
		function query:onSuccess(data)
			if data[1] then
				val(data[1])
			else
				val(nil)
			end
		end
		
		function query:onError(err)
			print("Daily Rewards] Error: "..err)
		end
		
		query:start()
	else
		local query = sql.Query("SELECT * FROM DailyRewards WHERE steamid = '"..plyID.."'")

		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		else
			if query == nil then
				query = {}
			end
			if query[1] then
				val(query[1])
			else
				val(nil)
			end
		end
	end
end

function plymeta:DAILYREWARDS_fetchClaimedRewards(val)
	local plyID = self:SteamID64()
	if DAILYREWARDS.CONFIG.MySQL.UseMySQL then
		local query = database:query("SELECT week, day, placement, data FROM DailyRewards_claimed WHERE steamid = '"..plyID.."'")
		function query:onSuccess(data)
			val(data)
		end
		
		function query:onError(err)
			print("Daily Rewards] Error: "..err)
		end
		
		query:start()
	else
		local query = sql.Query("SELECT week, day, placement, data FROM DailyRewards_claimed WHERE steamid = '"..plyID.."'")

		if query == false then
			print("[Daily Rewards] Error: "..sql.LastError())
		else
			val(query)
		end
	end
end
--{{ user_id }}