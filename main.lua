local discordia = require('discordia')
local client = discordia.Client()

local ttrpg = require('ttrpg')

-- {{{ Useful variables
-- Loading token
local file = io.open("token")
local token = file:read("*l")
file:close()

local prefix = ',' -- Change this to the wanted prefix
local prefixLen = prefix:len()

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
		local commandText = message.content:sub(prefixLen+1) -- Remove the prefix to only get the command
		if insensitive then commandText = commandText:lower() end -- If chosen so, make commands case-insensitive
		-- Converting the text in a table, separating arguments
		local command = {}
		for i in commandText:gmatch("[^' ',]+") do
			table.insert(command, i)
		end
		-- Separate main command from args
		local args = command
		command = table.remove(args, 1)

		-- {{{ Commands
		-- Simple ping command to easily check if the bot is connected
		if command == 'ping' then
			prior_time = os.clock()
			message.channel:send("Pong!")
			current_time = (os.clock()-prior_time)*1000
			time_extension = "ms"
			if current_time >= 1000 then
				time_extension = "s"
				current_time = current_time / 1000
			end
			message.channel:send("Latency for this message was `" .. tostring(current_time) .. "ms`")
		end
		-- Test command for args, here only for testing purposes
		if command == "args" then
			local msg = ""
			for i,j in pairs(args) do
				msg = msg .. tostring(i) .. ": " .. j .. "\n"
			end
			message.channel:send(msg)
		end
		if command == "dice" then
			message.channel:send(ttrpg.dice(args))
		end
		-- }}}
	end
end)

client:run('Bot ' .. token)
