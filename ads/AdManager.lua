require "Base"
require "game.GameState"

AdManager  = Base:new()

AdManager.admobIds = {
	androidBannerAppId = "ca-app-pub-8810482214895944/6131555915",
	androidInterstitial = "ca-app-pub-8810482214895944/7608289119",
	iosBannerAppId = "ca-app-pub-8810482214895944/7375263518",
	iosInterstitial = "ca-app-pub-8810482214895944/1328729919",
}

--AdManager.coronaAds = {
--	appId = "cedf82a2-c058-4d3a-ab56-d5a2e895b8f3",
--}

function AdManager:initialize(sceneLoader)
	self.adsDisabled = adsDisabled()
	if not self.adsDisabled then
		 self.adProvider = require("ads")
		 if ( system.getInfo( "platformName" ) == "Android" ) then
		 	-- self:loadCoronaAds(sceneLoader)
		 	self:loadAdMob(sceneLoader)
		 elseif ( system.getInfo( "platformName" ) == "iPhone OS" ) then 
		 	-- self:loadCoronaAds(sceneLoader)
		 	self:loadAdMob(sceneLoader)
		 end
	end
end

-- function AdManager:loadCoronaAds(sceneLoader)
-- 	self.coronaAds = require( "plugin.coronaAds" )
-- 	self.bannerPlacement = "bottom-banner-320x50"
-- 	self.interstitialPlacement = "interstitial-1"

-- 	local function adListener( event )
-- 		if ( event.phase == "init" ) then
-- 			self.adProvider = "coronaAds"
-- 			self.coronaAdsInitialized = true
-- 			print( "Corona ads successfully initialized.")
-- 		end
-- 	end

-- 	self.adProvider.init(self.coronaAds.appId, adListener)
-- end

function AdManager:loadAdMob(sceneLoader) 
	if ( system.getInfo( "platformName" ) == "Android" ) then
		self.bannerAppId = self.admobIds.androidBannerAppId
		self.interstitialAppId = self.admobIds.androidInterstitial
	else 
		self.bannerAppId = self.admobIds.iosBannerAppId
		self.interstitialAppId = self.admobIds.iosInterstitial
	end

	local function adListener( event )
		local msg = event.response
		local adType = event.type
	    print( "Message from the ads library: ", msg )

	    if ( event.isError ) then
	        print( "Error, no ad received.")
	    else
	        print( "Ad type:", adType)
	    end
	end

	self.adProviderName = "admob"

	self.adProvider.init(self.adProviderName, self.bannerAppId, adListener)
end

function AdManager:showBannerAd(x, y)
	if not adsDisabled() and self.coronaAdsInitialized then 
		print("Attempting to show a corona banner ad.")
		self.coronaAds.show(self.bannerPlacement, false)
	elseif not adsDisabled() and self.adProvider ~= nil then
		print("Attempting to show a banner ad.") 
		self.adProvider:setCurrentProvider( self.adProviderName )
		local targetingParams = { tagForChildDirectedTreatment = true }
		self.adProvider.show( "banner", {x=x, y=y, targetingOptions=targetingParams, appId=self.bannerAppId})
	else 
		print("Ads are disabled.")	
	end
end

function AdManager:showInterstitial()
	lastInterstitialAdTime = os.time()
	if not adsDisabled() and self.coronaAdsInitialized then
		print("Attempting to show a corona interstitial.")
		self.coronaAds(self.interstitialPlacement, true)
	elseif not adsDisabled() and self.adProvider ~= nil then 
		print("Attempting to show an interstitial ad.") 
		self.adProvider:setCurrentProvider( self.adProviderName )
		local targetingParams = { tagForChildDirectedTreatment = true }
		self.adProvider.show( "interstitial", { targetingOptions=targetingParams, appId=self.interstitialAppId } )
	else 
		print("Ads are disabled.")
	end
end

function AdManager:hideAd()
	if not adsDisabled and self.coronaAdsInitialized then
		self.coronaAds.hide()
	elseif not adsDisabled() and self.adProvider ~= nil then 
		self.adProvider.hide()
	end
end

local adManager = AdManager:new()
adManager:initialize()

lastInterstitialAdTime = os.time()
timeBetweenInterstitialAds = 3 * 60 --3 minutes
print("Interstitial Ad Timer started at ", lastInterstitialAdTime)
return adManager