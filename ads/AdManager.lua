require "Base"
require "game.GameState"

AdManager  = Base:new()

AdManager.admobIds = {
	androidBannerAppId = "ca-app-pub-1210803108734891/9132873369",
	androidInterstitial = "ca-app-pub-1210803108734891/1609606566",
	iosBannerAppId = "ca-app-pub-1210803108734891/9272474169",
	iosInterstitial = "ca-app-pub-1210803108734891/6179406969",
}

AdManager.iAdsIds = {
	iosBannerAppId = "org.finchfamily.wormy",
	iosInterstitial = "org.finchfamily.wormy"
}

AdManager.vungleIds = {
	androidVideo = "5682c9c16073d2f323000018",
	iosVideo = "5682c9c16073d2f323000018"
}

function AdManager:initialize(sceneLoader)
	self.adsDisabled = adsDisabled()
	if not self.adsDisabled then
		self.adProvider = require("ads")
		if ( system.getInfo( "platformName" ) == "Android" ) then
			self:loadAdMob(sceneLoader)
			self:loadVungle(sceneLoader)
		else 
			self:loadiAds(sceneLoader)
			self:loadVungle(sceneLoader)
		end
	end
end

function AdManager:loadiAds(sceneLoader)
	self.bannerAppId = self.iAdsIds.iosBannerAppId
	self.interstitialAppId = self.iAdsIds.iosInterstitial

	local function adListener( event)
		local msg = event.response
		local adType = event.type
	    print( "Message from the ads library: ", msg )

	    if ( event.isError ) then
	        print( "Error, no ad received.")
	    else
	        print( "Ad type:", adType)
	    end
	end

	self.adPluginName = "iads"
	self.adProviderName = "iads"

	self.adProvider.init(self.adPluginName, self.bannerAppId, adListener)
end

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

function AdManager:loadVungle(sceneLoader)
	if ( system.getInfo( "platformName" ) == "Android" ) then
		self.videoAppId = self.vungleIds.androidVideo
	else 
		self.videoAppId = self.vungleIds.iosVideo
	end

	local function adListener( event )
		local msg = event.response
		print( "Message from the ads library: ", msg )
		if ( event.type == "adStart" and event.isError ) then
	    	-- Ad has not finished caching and will not play
	    	print( "Vungle ad not loaded yet.")
    		self.adProvider.hide()
    		self:showInterstitial()
	  	end
	  	if ( event.type == "adStart" and not event.isError ) then
	   		-- Ad will play
	   		print( "Vungle ad playing.")
	  	end
	  	if ( event.type == "cachedAdAvailable" ) then
	    	-- Ad has finished caching and is ready to play
	    	print( "Vungle video ad cached.")
	  	end
	  	if ( event.type == "adView" ) then
	    	-- An ad has completed
	    	print( "Vungle video ad completed.")
	  	end
	  	if ( event.type == "adEnd" ) then
	    	print(" Vungle video ad ended.")
	  	end
	end

	self.videoAdProviderName = "vungle"

	self.adProvider.init(self.videoAdProviderName, self.bannerAppId, adListener)
end

function AdManager:showBannerAd(x, y)
	if not self.adsDisabled then
		print("Attempting to show a banner ad.") 
		self.adProvider:setCurrentProvider( self.adProviderName )
		local targetingParams = { tagForChildDirectedTreatment = true }
		self.adProvider.show( "banner", {x=x, y=y, targetingOptions=targetingParams, appId=self.bannerAppId})
	else 
		print("Ads are disabled.")	
	end
end

function AdManager:showInterstitial()
	if not self.adsDisabled then 
		print("Attempting to show an interstitial ad.") 
		self.adProvider:setCurrentProvider( self.adProviderName )
		local targetingParams = { tagForChildDirectedTreatment = true }
		self.adProvider.show( "interstitial", { targetingOptions=targetingParams, appId=self.interstitialAppId } )
	else 
		print("Ads are disabled.")
	end
end

function AdManager:showVideoAd()
	if not self.adsDisabled then
		print("Attempting to show a video ad.") 
		lastVideoAdTime = os.time()
		self.adProvider:setCurrentProvider( self.videoAdProviderName )
		self.adProvider.show( "interstitial", { targetingOptions=targetingParams, appId=self.videoAppId } )
	else 
		print("Ads are disabled.")
	end
end

function AdManager:hideAd()
	if not self.adsDisabled then 
		self.adProvider.hide()
	end
end

local adManager = AdManager:new()
adManager:initialize()

lastVideoAdTime = os.time()
timeBetweenVideoAds = 1 * 60 --5 minutes
print("Video Ad Timer started at ", lastVideoAdTime)
return adManager