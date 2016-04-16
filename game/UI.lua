local widget = require( "widget" )

local commonIconOptions = {
	width = 64,
	height = 64,
	numFrames = 8
}

local commonIconSheet = graphics.newImageSheet( "images/gameicons.png", commonIconOptions )

local commonIconSequence = {
	name = "Icons",
	frames = {1, 2, 3, 4, 5, 6, 7, 8}
}

local wormIconOptions = {
	width = 32,
	height = 32,
	numFrames = 64
}

local wormIconSheet = graphics.newImageSheet( "images/WormSheet.png", wormIconOptions )

local wormIconSequence = {
	name = "Icons",
	frames = {1}
}

function button(label, x, y, width, height, action) 
	local button = widget.newButton
		{
		    label = label,
		    labelColor = { default = colors.black },
		    emboss = true,
		    shape="roundedRect",
		    width = width,
		    height = height,
		    x = x,
		    y = y,
		    cornerRadius = 10,
		    fillColor = { default = colors.brown, over = colors.brown },
		    strokeColor = { default = colors.black, over = colors.black },
		    strokeWidth = 4,
		    onRelease = action,
		    font = "Desyrel",
		    fontSize = 24
		}	
	return button
end

function label(label, x, y, font, fontSize, displayGroup)
	local labelOptions = {
		parentGroup = displayGroup,
		text = label,
		x = x,
		y = y,
		font = font,
		fontSize = fontSize
	}
	local displayLabel = display.newText( labelOptions )
	displayLabel:setFillColor(colors.yellow[1], colors.yellow[2], colors.yellow[3])
	return displayLabel
end

function emptyButton(x, y, w, h, action)
	local buttonGroup = display.newGroup()
	local button = display.newRoundedRect(x, y, w, h, 10 )
	button.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 1.0}
	button.strokeWidth = 4
	button.stroke = colors.black

	buttonGroup:insert(button)
	local function onRelease(event)
		-- if (event.phase == "ended") then
			return action()
		-- end
	end

	buttonGroup:addEventListener( "tap", onRelease )
	return buttonGroup
end

function gameButton(x, y, w, h, iconIndex, action)
	local buttonGroup = display.newGroup()
	local button = display.newRoundedRect(x, y, w, h, 10 )
	button.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	button.strokeWidth = 4
	button.stroke = colors.black
	local icon = display.newSprite( commonIconSheet, commonIconSequence )
	icon:setFrame(iconIndex)
	icon.x = x
	icon.y = y
	icon.width = h - 20
	icon.height = h - 20

	buttonGroup:insert(button)
	buttonGroup:insert(icon)

	local function onRelease(event)
		-- if (event.phase == "ended") then
			return action()
		-- end
	end

	buttonGroup:addEventListener( "tap", onRelease )
	return buttonGroup
end


function homeButton(x, y, w, h, sceneLoader)
	local action = function()
		sceneLoader:menu()
	end

	return gameButton(x, y, w, h, 1, action)
end

function restartButton(x, y, w, h, sceneLoader)
	local action = function()
		sceneLoader:restart()
	end

	return gameButton(x, y, w, h, 2, action)
end

function goButton(x, y, w, h, sceneLoader)
	local action = function()
		sceneLoader:restart()
	end

	return gameButton(x, y, w, h, 4, action)
end


function nextButton(x, y, w, h, sceneLoader)
	local action = function()
		sceneLoader:moveToNextLevel()
	end

	return gameButton(x, y, w, h, 6, action)
end
	
function lockButton(x, y, w, h, sceneLoader)
	local action = function()
		if (freePassesAvailable() > 0) then
			sceneLoader:confirmConsumeFreePass(currentLevel)
		else
			sceneLoader:confirmPurchaseFreePass(currentLevel)
		end
	end

	return gameButton(x, y, w, h, 5, action)
end

function purchaseFreePassButton(x, y, w, h, passCount, price, sceneLoader)
	local openMenu = currentLevel == "Menu"
	local action = function()
		local afterPurchaseAction = function()
			if openMenu then
				sceneLoader:menu()
				return true
			else
				sceneLoader:openModal()
				return true
			end
		end

		iapManager:doPurchase("FREE_PASS_PACK_"..passCount, afterPurchaseAction)
	end

	local btn = button(price, x, y, w, h, action)
	return btn
end

function confirmConsumePassButton(x, y, w, h, sceneLoader)
	local action = function()
		consumeFreePassOnLevel(currentLevel - 1)
		sceneLoader:restart()
	end

	return gameButton(x, y, w, h, 8, action)
end

function cancelButton(x, y, w, h, sceneLoader)
	local openMenu = currentLevel == "Menu"
	local action = function()
		if openMenu then
			sceneLoader:menu()
			return true
		else
			sceneLoader:openModal()
			return true
		end
	end

	return gameButton(x, y, w, h, 7, action)
end

function timeRemainingBox(x, y, w, h, font, fontSize, startTime, noBorder)
	local timeGroup = display.newGroup()
	timeGroup.originX = x

	local iconW = (h - 20)
	local padding = 5
	local iconX = x - (w / 2) + iconW - padding
	local equalsX = iconX + (iconW / 2) + 17
	local textX = equalsX + 30

	local strokeWidth = 4

	if noBorder then strokeWidth = 0 end

	local equalsOptions = {
		text = " = ",
		x = equalsX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	timeGroup.equals = display.newText( equalsOptions )
	timeGroup.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	local labelOptions = {
		text = tostring(startTime),
		x = textX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	timeGroup.label = display.newText( labelOptions )
	timeGroup.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	timeGroup.timeBox = display.newRect(x, y, w, h)
	timeGroup.timeBox.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	timeGroup.timeBox.stroke = colors.black
	timeGroup.timeBox.strokeWidth = strokeWidth

	timeGroup.setTime = function(newTime)
		timeGroup.label.text = tostring(newTime)
	
		-- local labelWidth = timeGroup.label.width
		-- local iconWidth = timeGroup.timeIcon.width
		-- local totalWidth = labelWidth + iconWidth
		-- local halfWidth = totalWidth / 2

		-- timeGroup.timeBox.x = timeGroup.originX - halfWidth
		-- timeGroup.timeBox.width = totalWidth

		-- timeGroup.timeIcon.x = timeGroup.timeBox.x - (timeGroup.timeIcon.width / 2)
		-- timeGroup.label.x = timeGroup.timeBox.x + (timeGroup.timeIcon.width / 2)
	end

	timeGroup.timeIcon = display.newSprite( commonIconSheet, commonIconSequence )
	timeGroup.timeIcon:setFrame(3)
	timeGroup.timeIcon.x = iconX
	timeGroup.timeIcon.y = y
	timeGroup.timeIcon.width = iconW
	timeGroup.timeIcon.height = h - 20

	timeGroup:insert(timeGroup.timeBox)
	timeGroup:insert(timeGroup.timeIcon)
	timeGroup:insert(timeGroup.equals)
	timeGroup:insert(timeGroup.label)

	return timeGroup
end

function objectiveBox(x, y, w, h, font, fontSize, length, objective, wormIndex, noBorder)
	local objGroup = display.newGroup()
	local iconW = (h - 20)
	local padding = 5
	local iconX = x - (w / 2) + iconW - padding
	local equalsX = iconX + (iconW / 2) + 17
	local textX = equalsX + 45

	if length == nil then
		textX = equalsX + 30
	end

	local strokeWidth = 4

	if noBorder then strokeWidth = 0 end

	local equalsOptions = {
		text = " = ",
		x = equalsX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	objGroup.equals = display.newText( equalsOptions )
	objGroup.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	if (length ~= nil) then
		lengthObjective = tostring(length).."/"..tostring(objective)
	else
		lengthObjective = tostring(objective)
	end

	local labelOptions = {
		text = lengthObjective,
		x = textX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	objGroup.label = display.newText( labelOptions )
	objGroup.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	objGroup.box = display.newRect(x, y, w, h)
	objGroup.box.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	objGroup.box.stroke = colors.black
	objGroup.box.strokeWidth = strokeWidth

	objGroup.setLength = function(newLength)
		objGroup.label.text = tostring(newLength).."/"..tostring(objective)
	end

	objGroup.icon = display.newSprite( BaseWorm.wormSheet, BaseWorm.wormSequence )
	objGroup.icon:setFrame(wormIndex)
	objGroup.icon.x = iconX
	objGroup.icon.y = y
	objGroup.icon.width = iconW
	objGroup.icon.height = h - 20

	objGroup:insert(objGroup.box)
	objGroup:insert(objGroup.icon)
	objGroup:insert(objGroup.equals)
	objGroup:insert(objGroup.label)

	return objGroup
end

function keyBox(x, y, w, h, action)
	local group = display.newGroup()
	local iconW = (h - 20)
	local padding = 5
	local iconX = x - (w / 2) + iconW - padding
	local equalsX = iconX + (iconW / 2) + 17
	local textX = equalsX + 25

	local font = "Desyrel"
	local fontSize = 24

	local equalsOptions = {
		text = " = ",
		x = equalsX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	group.equals = display.newText( equalsOptions )
	group.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	local labelOptions = {
		text = tostring(freePassesAvailable()),
		x = textX,
		y = y,
		font = font,
		fontSize = fontSize
	}

	group.label = display.newText( labelOptions )
	group.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	if action ~= nil then 
		group.box = gameButton(x, y, w, h, 5, action)
	else 
		group.box = display.newRect(x, y, w, h)
		group.box.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
		group.box.stroke = colors.black
		group.box.strokeWidth = 4
	end

	group.setRemaining = function(remaining)
		objGroup.label.text = tostring(remaining)
	end

	group.image = display.newImage( "images/key.png" )
	group.image.x = iconX
	group.image.y = y
	group.image.width = iconW
	group.image.height = iconW
	
	group:insert(group.box)
	group:insert(group.image)
	group:insert(group.equals)
	group:insert(group.label)

	return group
end

function keyButton(x, y, w, h, action)
	local group = display.newGroup()
	local iconW = (h - 20)
	local padding = 5
	local iconX = x - (iconW) + padding + 20
	
	local equalsX = x + 20
	local textX = equalsX + 25

	local font = "Desyrel"
	local fontSize = 24

	local equalsOptions = {
		text = " = ",
		x = equalsX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	group.equals = display.newText( equalsOptions )
	group.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	local labelOptions = {
		text = tostring(freePassesAvailable()),
		x = textX,
		y = y,
		font = font,
		fontSize = fontSize
	}

	group.label = display.newText( labelOptions )
	group.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	group.box = emptyButton(x, y, w, h, action)
	-- group.box.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 1.0}

	group.setRemaining = function(remaining)
		objGroup.label.text = tostring(remaining)
	end

	group.image = display.newImage( "images/key.png" )
	group.image.x = iconX
	group.image.y = y
	group.image.width = iconW
	group.image.height = iconW
	
	group:insert(group.box)
	group:insert(group.image)
	group:insert(group.equals)
	group:insert(group.label)

	return group
end