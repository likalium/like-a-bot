local discordia = require('discordia')
local client = discordia.Client()

-- Loading token
local file = io.open("token")
local token = file:read("*l")
file:close()

local prefix = ',' -- Change this to the wanted prefix
local prefixLen = string.len(prefix)

client:on('ready', function()
	-- client.user is the path for your bot
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
	if message.content:sub(0,prefixLen) == prefix then
		local command = message.content:sub(prefixLen+1)
		if command == 'ping' then
			local creationDate = message.timestamp
			message.channel:send(creationDate)
		end
	end
end)

client:run('Bot ' .. token)
