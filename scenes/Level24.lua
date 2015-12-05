local level = {
	worm = {
		x = 100,
		y = 374
	},
	foodTruck = {
		standardWorm = 100
	},
	standardFood = {
		{x=512, y=768-100, count=30, delay=1000},
		{x=512, y=384, count=30, delay=10000},
		{x=512, y=192, count=30, delay=25000}
	},
	walls = {
		{231, 192, 50, 384},
		{743, 192, 50, 384},
		{231, 538, 562, 50},
		{231, 192, 256, 50},
		{537, 192, 256, 50},
		{0, 0, 50, 768},
		{0, 768-50, 1024, 50},
		{1024-50, 0, 50, 768}
	},
	secondsAllowed = 60,
	lengthObjective = 100,
	instructions = "Yum!"
}

return level

--width 50

--three-quarter = 768
--half-width = 512
--quarter = 256


--three-quarter = 576
--halfheight = 384
--quarterheight = 192
--x = quarterWidth
--y = quarterHeight to three-quarter-height
