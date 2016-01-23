local level = {
	title = "Monkey Trap",
	worm = {
		x = 100,
		y = 374
	},
	foodTruck = {
		standardWorm = 90,
		clockWorm = 10
	},
	standardFood = {
		{x=512, y=768-100, count=45, delay=1000},
		{x=512, y=384, count=45, delay=10000},
		{x=512, y=192, count=45, delay=25000}
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
	lengthObjective = 150,
	instructions = "Yum!"
}

return level