--- garden_2022_stats
--
-- Computes how many turns it takes in average to get a pepper
-- using different strategies in TFM's Garden Event 2022.
-- See `https://transformice.fandom.com/wiki/Vegetable_Garden_2022#Seeds`.
--
-- @author: TFM:Pshy#3752 DC:Pshy#7998
SAMPLE_SIZE = 10000

print("SAMPLE_SIZE == " .. tostring(SAMPLE_SIZE))
math.randomseed(os.time())

local plants = {
	[1] = {name = "DAISY", grow_time = 3};
	[2] = {name = "TOMATO", grow_time = 5};
	[3] = {name = "BLUEBERRY", grow_time = 7};
	[4] = {name = "GRAPE", grow_time = 11};
	[5] = {name = "LEMON", grow_time = 15};
	[6] = {name = "PEPPER", grow_time = 20};
	[7] = {name = "NOTHING"};
}

-- Test every strategy:
for convert_from = 1, 6 do

	-- One test of this strategy:
	function test()
		local turns = 0

		local inventory = {
			[1] = 0;
			[2] = 0;
			[3] = 0;
			[4] = 0;
			[5] = 0;
			[6] = 0;
		}

		while inventory[6] < 1 do
			for i = 5,0,-1 do
				local plant_index
				if i == 0 or i >= convert_from then
					if i == 0 then
						-- planting a mystery seed
						local rnd = math.random()
						if rnd <= 0.01 then
							plant_index = 6
						elseif rnd <= 0.03 then
							plant_index = 5
						elseif rnd <= 0.10 then
							plant_index = 4
						elseif rnd <= 0.20 then
							plant_index = 3
						elseif rnd <= 0.35 then
							plant_index = 2
						elseif rnd <= 1 then
							plant_index = 1
						end
					else
						if inventory[i] >= 3 then
							-- planting a specific seed
							inventory[i] = inventory[i] - 3
							plant_index = i + 1
						end
					end
				end
				if plant_index then
					turns = turns + plants[plant_index].grow_time
					inventory[plant_index] = inventory[plant_index] + 1
					break
				end
			end
		end

		return turns
	end

	-- Run several tests and compute the average
	local avg = 0
	for i = 1, SAMPLE_SIZE do
		avg = avg + test()
	end
	avg = avg / SAMPLE_SIZE
	print(string.format("Only planting mystery or %10s or better:\t%.2f turns", plants[convert_from + 1].name, avg))
end
