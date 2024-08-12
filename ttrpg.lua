--== TTRPG UTILITIES ==--

local ttrpg = {}

-- Simulates dice throwing, Accepts "3d8"-like notation
function ttrpg.dice(throw)
	for i,_ in pairs(throw) do
		-- No number before the "d" means we throw one dice
		if string.sub(throw[i], 1, 1) == "d" then throw[i] = 1 .. throw[i] end
		-- No number after then "d" means we throw a d6
		if string.sub(throw[i], -1) == "d" then throw[i] = throw[i] .. 6 end
	end
	local output = table.concat(throw, " + ")
	local diceResults = {}
	diceResults[#throw+1] = {} -- Initializing the table at the very end of diceResults' table that will contain the sums of the dice sets
	output = output .. " = "
	for index,die in pairs(throw) do
		-- {{{ Separate parts of the "dice string"
		local dieTable = {} -- Convert the dice string into a table
		diceResults[index] = {} -- Initializing the table that will contain the results for this dice set
		for i in die:gmatch("[^d]+") do
			if tonumber(i) then
				table.insert(dieTable,tonumber(i))
			else
				return "Error: Enter valid Input."
			end
		end
		-- }}}
		-- {{{ Generate dice results
		if dieTable[1] > 1 and #throw then output = output .. "(" end -- If there is multiple dice, we put the values between brackets
		math.randomseed(os.time()) -- Setting the seed to OS time for better randomness
		local setSum = 0 -- Sum of all the dices results of the set
		for i=1,dieTable[1] do
			-- Each set of dice results is a table which is inside diceResults
			diceResults[index][i] = math.random(dieTable[2])
			setSum = setSum + diceResults[index][i] -- Adding the die result to the sum of the dices of the set
		end
		-- Each set of dice results gets it's result appended in a table, add the very end of the diceResults table
		diceResults[#throw+1][index] = setSum
		-- Append the generated dice
		output = output .. table.concat(diceResults[index], " + ")
		if dieTable[1] > 1 then output = output .. ")" end -- Closing brackets if needed
		if index ~= #throw then output = output .. " + " end -- If not the last dice set, we add a "+" as separator
		-- }}}
	end
	local totalSum = 0 -- total sums of all the dices
	local tmpSum = table.concat(diceResults[#throw+1], " + ")
	-- If there is no brackets, then it means the sum of the dice sets will be the same as the sum of the dices
	-- So, to avoid useless (and not really pretty) repetition, we show the sums of the dice sets only if it differs from the sum of the dices
	-- And the sum of the dices is in our output, that's why we're checking our output
	-- If that's unclear, just remove the if and always append tmpSum to output.
	-- Then try the dice command with something like "d6 d12". You'll see repetition
	if string.find(output,"%(") then
		output = output .. " = "
		output = output .. tmpSum
	end
	for _,j in pairs(diceResults[#diceResults]) do
		totalSum = totalSum + j
	end
	-- Adding the total sum to the output string, only if it differs from the total of the dice sets
	if tmpSum ~= tostring(totalSum) then output = output .. " = " .. totalSum end
	return output
end

return ttrpg
