addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function()
		if (isElement(NOTIFICATION_CONFIGURATION.ElementsCache.Fonts.Regular)) then
			destroyElement(NOTIFICATION_CONFIGURATION.ElementsCache.Fonts.Regular)
		end

		NOTIFICATION_CONFIGURATION.ElementsCache.Fonts.Regular = dxCreateFont("assets/regular.ttf", 11, false)

		for Key, FilePath in pairs(NOTIFICATION_CONFIGURATION.BackgroundFiles) do
			if (NOTIFICATION_CONFIGURATION.ElementsCache.Sections[Key] and isElement(NOTIFICATION_CONFIGURATION.ElementsCache.Sections[Key])) then
				destroyElement(NOTIFICATION_CONFIGURATION.ElementsCache.Sections[Key])
			end

			NOTIFICATION_CONFIGURATION.ElementsCache.Sections[Key] = dxCreateTexture(FilePath, "argb", false, "clamp")
		end
	end
)