--== UTILS FUNCTIONS ==--
-- Not commands for the user, but functions to be used by the bot

package.path = package.path .. ";./modules/?.lua" -- Adding our modules folder to the package path

local lunajson = require("lunajson")

local bot = {}

require("variables")

-- Adds a user to the database, only if the user isn't in the database yet
function bot.addUser(userid, db, guildid)
	-- If the guild itself isn't in the database, first create it
	if not db[guildid] then bot.addGuild(guildid, db) end
	if not db[guildid].users[userid] then
		db[guildid].users[userid] = {}
		db[guildid].users[userid] = {
			id = userid,
			money = 0
		}
	end
end

-- Adds a guild to the database, if the guilds doesn't exists yet in the database
function bot.addGuild(guild, db)
	if not db[guild.id] then
		db[guild.id] = {}
		db[guild.id] = {
			id = guild.id, -- idk, can be useful
			name = guild.name,
			prefix = ",", -- Change this to your wanted default prefix
			users = {}, -- Will be useful to store data related to users of the server (eg, amount of fake money)
		}
	end
end

-- Decodes a JSON file (creates it if it doesn't exists) and returns it
function bot.readDb(file)
	local jsonFile = io.open(file, "a+")
	local dbStr = jsonFile:read("*a")
	jsonFile:close()
	-- if the database is empty, we return an empty table
	if dbStr == "" then
		return {}
	else
		return lunajson.decode(dbStr)
	end
end

-- Writes the database in a JSON file
function bot.writeDb(db,file)
	local jsonDb = lunajson.encode(db)
	local jsonFile = io.open(file, "w")
	jsonFile:write(jsonDb .. "\n")
	jsonFile:close()
end

return bot
