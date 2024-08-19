--== SETTINGS FUNCTIONS ==--
-- For bot settings, for example letting users setting up the prefix

local bot = require("bot")

require("variables")

local settings = {}

-- Let users with the right permissions to change server's prefix
function settings.prefix(caller, guild, newPrefix, db)
	-- Only let administrators to change prefix
	if not caller:hasPermission('administrator') then
		return "Sorry, but you don't have enough permissions to do that."
	end
	db[guild.id].prefix = newPrefix
	if db[guild.id].prefix == newPrefix then
		return "Prefix successfully changed to `" .. newPrefix .. "` !"
	else
		return "Sorry, but something went wrong. Prefix is currently set to `" .. db[guild.id].prefix .. "`"
	end
end

return settings
