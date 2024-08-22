-- by likalium & procham :)

local discordia = require('discordia')

local client = discordia.Client()

-- {{{ Loading features files
local ttrpg = require('ttrpg') -- ttrpg functions
local money = require('money') -- bot's economy functions
local misc = require('misc') -- Various useful functions
local settings = require('settings') -- Commands for bot related settings
local bot = require('bot') -- Not commands but functions useful for the bot
require("variables") -- Variables that are likely to be fetched in multiple files
-- }}}

-- Loading token
local tokenFile = io.open("token")
if not tokenFile then
	print("Error: No token found. Make sure to have, in the directory of the bot, a tokenFile named 'token' that contains ONLY your bot's token")
	os.exit()
end
local token = tokenFile:read("*l")
tokenFile:close()

-- Loading data.json which will be our database
local data = bot.readDb("data.json")

client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
end)

-- Add guild to server's database if needed
client:on("guildAvailable", function (guild)
	if not data[guild.id] then
		bot.addGuild(guild, data)
		bot.writeDb(data, "data.json")
	end
end)

-- Prefix-related data, for now we just initialize some variables
local prefix = ""
local previousGuild = ""
local prefixLen = 0

client:on('messageCreate', function(message)
	if message.author.bot then return end -- Making sure the bot cannot execute commands

	-- We fetch server prefix only if last command wasn't sent in the server
	if previousGuild == "" or previousGuild ~= message.guild.id then
		prefix = data[message.guild.id].prefix
		prefixLen = prefix:len()
		previousGuild = message.guild.id
	end

	-- Try to execute command only of the message starts with the prefix
	if message.content:sub(0,prefixLen) == prefix then
		local commandText = message.content:sub(prefixLen+1) -- Remove the prefix to only get the command
		if CASE_INSENSITIVE then commandText = commandText:lower() end -- If chosen so, make commands case-insensitive
		-- Converting the text in a table, separating arguments
		local command = {}
		for i in commandText:gmatch("[^' ']+") do
			table.insert(command, i)
		end
		-- Separate main command from arguments
		local commandArgs = command
		command = table.remove(commandArgs, 1)

		-- {{{ Commands
		-- See files the functions belong to for description of each command
		if command == 'ping' then
			message.channel:send(misc.ping())
		end
		if command == "args" then
			message.channel:send(misc.args(commandArgs))
		end
		if command == "dice" then
			message.channel:send(ttrpg.dice(commandArgs))
		end
		if command == "prefix" then
			if commandArgs[1] then
				-- Setting up & saving new prefix
				local caller = message.guild:getMember(message.author)
				message.channel:send(settings.prefix(caller, message.guild, commandArgs[1], data))
				bot.writeDb(data, "data.json")

				-- Reload database & prefix
				data = bot.readDb("data.json")
				prefix = data[message.guild.id].prefix
			else
				message.channel:send("Current prefix: `" .. prefix .. "`")
			end
		end
		-- }}}
	end
end)

client:run('Bot ' .. token)
