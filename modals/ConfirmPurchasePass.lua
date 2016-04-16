require("core.Modal")

ConfirmPurchasePass = Modal:new()

function ConfirmPurchasePass:initializeContent()
	if iapManager:doesAllowInAppPurchase() then
		self:initializeQuestion()
		if not adsDisabled() then
			self:initializeAdStatement()
		end

		self.buttonOffset = 13
		self:initialize3Button()
		self:initialize10Button()
		self:initialize20Button()
		self:initializeNoButton()
	else
		self.buttonOffset = 13
		self:initializeNoPurchaseStatement()
		self:initializeCancelButton()
	end
end

function ConfirmPurchasePass:initializePopup(w, h)
	self.width = w or display.contentWidth * .55
	self.height = h or display.contentHeight * .36
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.darkbrown
	self:addDisplayObject(self.popup)

	local innerFrame = display.newRect( self.centerX, self.centerY, self.width, self.height - 85 )
	innerFrame.fill = colors.brown
	self:addDisplayObject(innerFrame)

	local bannerFrame = display.newRect( self.centerX, self.centerY - 87, self.width, 65)
	bannerFrame.fill = colors.darkbrown
	self:addDisplayObject(bannerFrame)	
end

function ConfirmPurchasePass:initializeCloseButton(closeAction)
end

function ConfirmPurchasePass:initializeQuestion()
	local question = "Buy more free passes?"
	local x = self.centerX
	local y = self.centerY - self.height * .25 - 30
	local fontSize = 36
	local font = "Desyrel"

	local question = label(question, x, y, font, fontSize)
	question.fill = colors.brown
	self:addDisplayObject(question)
end

function ConfirmPurchasePass:initializeNoPurchaseStatement()
	local question = "Sorry, you can't purchase more free passes."
	local x = self.centerX
	local y = self.centerY - self.height * .25 - 30
	local fontSize = 28
	local font = "Desyrel"

	local question = label(question, x, y, font, fontSize)
	question.fill = colors.brown
	self:addDisplayObject(question)
end

function ConfirmPurchasePass:initializeAdStatement()
	local question = "Ads are disabled with any purchase."
	local x = self.centerX
	local y = self.centerY + (self.height * .25 + 50)
	local fontSize = 24
	local font = "Desyrel"

	local question = label(question, x, y, font, fontSize)
	question.fill = colors.brown
	self:addDisplayObject(question)
end

function ConfirmPurchasePass:initialize3Button()
	local price = iapManager:getProductPrice("FREE_PASS_PACK_3")
	local width, height = 100,75
	local yOffset = self.buttonOffset
	local posX = self.centerX - width * 2
	local posY = self.centerY + yOffset

	-- local button = confirmConsumePassButton(posX, posY, width, height, self.parent.sceneLoader)
	local button = purchaseFreePassButton(posX, posY, width, height, "3", price, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("3 Passes", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmPurchasePass:initialize10Button()
	local price = iapManager:getProductPrice("FREE_PASS_PACK_10")
	local width, height = 100,75
	local yOffset = self.buttonOffset
	local posX = self.centerX - width / 1.5
	local posY = self.centerY + yOffset

	-- local button = confirmConsumePassButton(posX, posY, width, height, self.parent.sceneLoader)
	local button = purchaseFreePassButton(posX, posY, width, height, "10", price, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("10 Passes", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmPurchasePass:initialize20Button()
	local price = iapManager:getProductPrice("FREE_PASS_PACK_20")
	local width, height = 100,75
	local yOffset = self.buttonOffset
	local posX = self.centerX + width / 1.5
	local posY = self.centerY + yOffset

	-- local button = confirmConsumePassButton(posX, posY, width, height, self.parent.sceneLoader)
	local button = purchaseFreePassButton(posX, posY, width, height, "20", price, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("20 Passes", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmPurchasePass:initializeNoButton()
	local width, height = 100,75
	local yOffset = self.buttonOffset
	local posX = self.centerX + width * 2
	local posY = self.centerY + yOffset

	local button = cancelButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("No", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmPurchasePass:initializeCancelButton()
	local width, height = 100,75
	local yOffset = self.buttonOffset
	local posX = self.centerX
	local posY = self.centerY + yOffset

	local button = cancelButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Cancel", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end