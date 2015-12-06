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
	miniFireSpouts = {
	 {x = 512, y = 384, rotation = 0, rotate = true}

	},
	secondsAllowed = 60,
	lengthObjective = 80,
	instructions = "Yum!"
}

return level