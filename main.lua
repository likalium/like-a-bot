local discordia = require('discordia')
local client = discordia.Client()

-- {{{ Useful variables
-- Loading token
local file = io.open("token")
local token = file:read("*l")
file:close()

local prefix = ',' -- Change this to the wanted prefix
local prefixLen = string.len(prefix)

-- Choose if you want the bot to be case-insensitive or not
local insensitive = true

client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
end)
-- }}}

client:on('messageCreate', function(message)
	if message.author.bot then return end -- Making sure the bot cannot execute commands

	-- Try to execute command only of the message starts with the prefix
	if message.content:sub(0,prefixLen) == prefix then
		local command = message.content:sub(prefixLen+1) -- Remove the prefix to only get the command
		if insensitive then command = command:lower() end -- If chosen so, make commands case-insensitive

		-- {{{ Commands
		-- Simple ping command to easily check if the bot is connected
		if command == 'ping' then
			message.channel:send("Pong!")
		end
		-- }}}
	end
end)

client:run('Bot ' .. token)
