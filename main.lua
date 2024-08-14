-- by likalium & procham :)

package.path = package.path .. ";./modules/?.lua" -- Adding our modules folder to the package path

local discordia = require('discordia')
local lunajson = require("lunajson")

local client = discordia.Client()

-- {{{ Loading features files
local ttrpg = require('ttrpg') -- ttrpg functions
local money = require('money') -- bot's economy functions
local misc = require('misc') -- Various useful functions
-- }}}

-- {{{ Useful variables
-- Loading token
local tokenFile = io.open("token")
if not tokenFile then
	print("Error: No token found. Make sure to have, in the directory of the bot, a tokenFile named 'token' that contains ONLY your bot's token")
	os.exit()
end
local token = tokenFile:read("*l")
tokenFile:close()

-- Loading data.json which will be our "database". Also create it if it doesn't exists
local jsonFile = io.open("data.json", "a+")
local dataStr = jsonFile:read("*a")
jsonFile.close()
print(dataStr)
print("ye")


local prefix = ',' -- Change this to the wanted default prefix
local prefixLen = prefix:len()

-- Choose if you want the bot to be case-insensitive or not
local insensitive = true
-- }}}

client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
	if message.author.bot then return end -- Making sure the bot cannot execute commands

	-- Try to execute command only of the message starts with the prefix
	if message.content:sub(0,prefixLen) == prefix then
		local commandText = message.content:sub(prefixLen+1) -- Remove the prefix to only get the command
		if insensitive then commandText = commandText:lower() end -- If chosen so, make commands case-insensitive
		-- Converting the text in a table, separating arguments
		local command = {}
		for i in commandText:gmatch("[^' ',]+") do
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
		-- }}}
	end
end)

client:run('Bot ' .. token)
