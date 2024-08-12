--== TTRPG UTILITIES ==--

local ttrpg = {}

-- Simulates dice throwing, Accepts "3d8"-like notation
function ttrpg.dice(throw)
	local output = table.concat(throw, " + ")
	local diceResults = {}
	output = output .. " = "
	for index,die in pairs(throw) do
		-- {{{ Separate parts of the "dice string"
		local dieTable = {} -- Convert the dice string into a table
		diceResults[index] ={}
		print(die, die[1])
		if string.sub(die, 1, 1) == "d" then table.insert(dieTable, 1) end -- No number before the "d" means we throw one dice
		for i in die:gmatch("[^d]+") do
			if tonumber(i) then
				table.insert(dieTable,tonumber(i))
			else
				return "Error: Enter valid Input."
			end
		end
		if string.sub(die, 1, -1) == "d" then table.insert(dieTable, 6) end -- No number after then "d" means we throw a d6
		-- }}}
		-- {{{ Generate dice results
		math.randomseed(os.time()) -- Setting the seed to OS time for better randomness
		if dieTable[1] > 1 then output = output .. "(" end
		for i=1,dieTable[1] do
			-- Each set of dice results is a table which is inside diceResults
			diceResults[index][i] = math.random(dieTable[2])
			-- Append the result to the output string
			output = output .. tostring(diceResults[index][i])
			if i ~= dieTable[1] then output = output .. " + " end
		end
		if dieTable[1] > 1 then output = output .. ")" end
		if index ~= #throw then output = output .. " + " end
		-- Each set of dice results gets it's result as last item of the set
		local setSum = 0 -- Sum of all the dices results of the set
		for _,j in pairs(diceResults[index]) do
			setSum = setSum + j
		end
		table.insert(diceResults[index],setSum)
		-- }}}
	end
	output = output .. " = "
	local totalSum = 0 -- total sums of all the dices
	for i,j in pairs(diceResults) do
		output = output .. tostring(j[#j]) -- Adding sums to the output string
		if i ~= #diceResults then output = output .. " + " end
		totalSum = totalSum + j[#j]
	end
	-- Adding the total sum to the output string
	output = output .. " = " .. totalSum
	return output
end

return ttrpg
