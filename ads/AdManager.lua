AdManager  = Base:new()

AdManager.admobIds = {
	androidBannerAppId = "ca-app-pub-5780801091892183/9202734154",
	androidInterstitial = "ca-app-pub-5780801091892183/1679467359",
	iosBannerAppId = "ca-app-pub-5780801091892183/4632933752",
	iosInterstitial = "ca-app-pub-5780801091892183/6109666955",
}

function AdManager:initialize(sceneLoader)
	self:loadAdMob(sceneLoader)
end

function AdManager:loadAdMob(sceneLoader) 
	self.adProvider = require("ads")
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
	local targetingParams = { tagForChildDirectedTreatment = true }
	self.adProvider.show( "banner", {x=x, y=y, targetingOptions=targetingParams, appId=self.bannerAppId})
end

function AdManager:showInterstitial()
	local targetingParams = { tagForChildDirectedTreatment = true }
	self.adProvider.show( "interstitial", { targetingOptions=targetingParams, appId=self.interstitialAppId } )
end

function AdManager:hideAd()
	self.adProvider.hide()
end