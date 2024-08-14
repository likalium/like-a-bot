--== MISCEALLENOUS FUNCTIONS ==--

local misc = {}

-- Just a ping function. Useful for testing
function misc.ping()
	return {
		embed = {
			title = "Ping",
			fields = {
				{
					name = "1",
					value = "Ping"
				},
				{
					name = "2",
					value = "Pong"
				}
			}
		}
	}
end

-- Test command for args, here only for testing purposes
function misc.args(commandArgs)
	local msg = ""
	for i,j in pairs(commandArgs) do
		msg = msg .. tostring(i) .. ": " .. j .. "\n"
	end
	return msg
end
return misc
