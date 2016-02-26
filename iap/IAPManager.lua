require "Base"
require "game.GameState"

IAPManager  = Base:new()

IAPManager.products = {
	"FREE_PASS_PACK_3",    --99 cents
	"FREE_PASS_PACK_10",   --2.99 
	"FREE_PASS_PACK_20"    --4.99
}

function IAPManager:initialize()
	self.invertedProducts = self:invertTable(self.products)

	if ( system.getInfo( "platformName" ) == "iPhone OS" ) then
		self.allowInAppPurchase = true
		self:initializeIOS()
	elseif (system.getInfo( "platformName" ) == "Mac OS X" ) then
		self.allowInAppPurchase = true
		self:initializeSimulator()
	else 
		print("In app purchase not enabled on "..system.getInfo("platformName"))
		self.allowInAppPurchase = false
		-- self:initializeSimulator()
	end

	if (self.allowInAppPurchase) then
		self:doLoadProductList()
	end
end

function IAPManager:initializeIOS()
	self.store = require( "store" )
	self.productMap = {
		"org.finchfamily.wormy.freePassPack3",
		"org.finchfamily.wormy.freePassPack10",
		"org.finchfamily.wormy.freePassPack20",
	}
	self.invertedProductMap = self:invertTable(self.productMap)

	self.executePurchase = function(productId)
		self.store.purchase({productId})
	end

	self:initializeCallbacks("apple")
end

function IAPManager:initializeSimulator()
	self.store = {}
	self.store.init = function(storeName, cb)
		self.store.callback = cb
	end
	self.store.finishTransaction = function(transaction) 
		print("Finalizing simulated purchase of "..transaction.productIdentifier) 
	end
	self.store.loadProducts = function(productList, cb)
		local result = {}
		result.products = {}
		table.insert(result.products, {
			priceLocale = "en_US@currency=USD",
			title = "Free Pass 3 Pack",
			price = 0.99,
			localizedPrice = "$0.99",
			productIdentifier = "FREE_PASS_PACK_3",
			description = "A free pass allows you to move past a level that you're stuck on.  This purchase includes 3 free passes.  Ads are disabled with any purchase."
		})
		table.insert(result.products, {
			priceLocale = "en_US@currency=USD",
			title = "Free Pass 10 Pack",
			price = 2.99,
			localizedPrice = "$2.99",
			productIdentifier = "FREE_PASS_PACK_10",
			description = "A free pass allows you to move past a level that you're stuck on.  This purchase includes 10 free passes.  Ads are disabled with any purchase."
		})
		table.insert(result.products, {
			priceLocale = "en_US@currency=USD",
			title = "Free Pass 20 Pack",
			price = 4.99,
			localizedPrice = "$4.99",
			productIdentifier = "FREE_PASS_PACK_20",
			description = "A free pass allows you to move past a level that you're stuck on.  This purchase includes 20 free passes.  Ads are disabled with any purchase."
		})
		cb(result)
	end
	self.store.canMakePurchases = true

	self.productMap = self.products
	self.invertedProductMap = self:invertTable(self.productMap)
	self.executePurchase = function (productId)
		print("Simulating purchase of "..productId)
		local event = {}
		event.transaction = {
			state = "purchased",
			productIdentifier = productId
		}
		self.store.callback(event)
	end

	self:initializeCallbacks("simulator")
end

function IAPManager:initializeCallbacks(storeName)
	local handleStoreCallbacks = function(event)
		local transaction = event.transaction
		local productIdentifier = transaction.productIdentifier

		if transaction.state == "purchased" then
			print "PURCHASED"
			self:handlePurchased(productIdentifier)
		elseif transaction.state == "restored" then
			print "RESTORED"
		elseif transaction.state == "cancelled" then
			print "CANCELLED"
		elseif transaction.state == "failed" then
			print "FAILED"
		elseif transaction.state == "refunded" then
			print "REFUNDED"
		else
			local state = transaction.state
			print(tostring(state))
		end	

		self.store.finishTransaction( event.transaction )	
	end

	self.store.init( storeName, handleStoreCallbacks )
	self.allowInAppPurchase = self.store.canMakePurchases
end

function IAPManager:doPurchase(productName)
	if self.allowInAppPurchase then
		local i = self.invertedProducts[productName]
		local productIdentifier = self.productMap[i]
		self.executePurchase(productIdentifier)
	end
end

function IAPManager:handlePurchased(productIdentifier)
	local productKey = self.invertedProductMap[productIdentifier]
	local product = self.products[productKey]
	print(product.." was purchased.")

	print("Disabling ads.")
	disableAds()

	if product == "FREE_PASS_PACK_3" then
		addFreePasses(3)
	elseif product == "FREE_PASS_PACK_10" then
		addFreePasses(10)
	elseif product == "FREE_PASS_PACK_20" then
		addFreePasses(20)
	end
end

function IAPManager:doLoadProductList()
	local listener = function(event)
		self.productDescriptions = event.products
		local sortFunction = function(a, b)
			return a.price < b.price
		end
		table.sort(self.productDescriptions, sortFunction)
		self:printTable(self.productDescriptions)
	end

	self.store.loadProducts(self.productMap, listener)
end

function IAPManager:allowInAppPurchase()
	return self.allowInAppPurchase
end

function IAPManager:getProductList()
	if (self.productDescriptions == nil) then return {}
	else return self.productDescriptions end
end

function IAPManager:getProductPrice(productIdentifier)
	local products = self.productDescriptions or {}
	local i = self.invertedProducts[productIdentifier]
	local pi = self.productMap[i]
	for index,value in ipairs(products) do
		if value.productIdentifier == pi then
			return value.localizedPrice
		end
	end
end

local iapManager = IAPManager:new()
iapManager:initialize()
return iapManager