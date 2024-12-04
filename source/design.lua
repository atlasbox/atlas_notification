local ScreenWidth, ScreenHeight = guiGetScreenSize()
local StateHandler = false

local NotificationsCache = {}
local NotificationMainIndex = 1

local BackgroundInfo = {}
BackgroundInfo.Width = 255
BackgroundInfo.Height = 50
BackgroundInfo.PositionX = ScreenWidth - (BackgroundInfo.Width + 20)

function OnClientRender()
	if (not NOTIFICATION_CONFIGURATION.RenderState) then
		return
	end

	local TickCountNow = getTickCount()

	if (#NotificationsCache > 0) then
		local Top = 0
		local BackgroundColor = NOTIFICATION_CONFIGURATION.Colors["background"]

		for Index = 1, #NotificationsCache do
			local Value = NotificationsCache[Index]

			if (Value) then
				if (Value.Status == "Out") then
					if (Value.Animation.Opacity > 0) then
						Value.Animation.Opacity = Lerp(Value.Animation.Opacity, 0, 0.08)

						if (Value.Animation.Opacity <= 0.02) then
							table.remove(NotificationsCache, Index)

							if (#NotificationsCache <= 0 and StateHandler) then
								StateHandler = false
								removeEventHandler("onClientRender", getRootElement(), OnClientRender)
							end
						end
					end
				elseif (Value.Status == "New") then
					Value.Animation.Height = Lerp(Value.Animation.Height, BackgroundInfo.Height, 0.08)
					Value.Animation.Opacity = Lerp(Value.Animation.Opacity, 1, 0.08)

					if ((TickCountNow - Value.TickCount) >= Value.Duration) then
						Value.Status = "Hidden"
					end
				elseif (Value.Status == "Hidden") then
					Value.Animation.Height = Lerp(Value.Animation.Height, 0, 0.08)
					Value.Animation.Opacity = Lerp(Value.Animation.Opacity, 0, 0.08)

					if (Value.Animation.Opacity <= 0.02) then
						table.remove(NotificationsCache, Index)

						if (NotificationsCache[Index - NotificationMainIndex]) then
							if (Index == NotificationMainIndex and Index <= NotificationMainIndex) then
								NotificationsCache[Index - NotificationMainIndex].Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["top"]
							end
		
							if (Index == NotificationMainIndex and Index >= 3) then
								NotificationsCache[Index + NotificationMainIndex].Section = false
							end
		
							if (Index == NotificationMainIndex and Index >= 2) then
								NotificationsCache[Index - NotificationMainIndex].Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["top"]
							else
								NotificationsCache[Index - NotificationMainIndex].Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["bottom"]
							end
						end

						if (#NotificationsCache <= 0 and StateHandler) then
							StateHandler = false
							removeEventHandler("onClientRender", getRootElement(), OnClientRender)
						end
					end
				end

				Top = Top + Value.Animation.Height

				if Value.Section then
					dxDrawImage(BackgroundInfo.PositionX, Top, BackgroundInfo.Width, Value.Animation.Height + Value.TextSize.Height, Value.Section, 0, 0, 0, tocolor(BackgroundColor[1], BackgroundColor[2], BackgroundColor[3], Value.Animation.Opacity * 240))
				else
					dxDrawRectangle(BackgroundInfo.PositionX, Top, BackgroundInfo.Width, Value.Animation.Height + Value.TextSize.Height, tocolor(BackgroundColor[1], BackgroundColor[2], BackgroundColor[3], Value.Animation.Opacity * 240))
				end

				if Value.Animation.Opacity >= 0.8 then
					if Value.Style then
						dxDrawImage(BackgroundInfo.PositionX + 10, Top + 15, BackgroundInfo.Height - 10, BackgroundInfo.Height - 10, "assets/" .. Value.Style .. ".png")
					end
		
					dxDrawText(Value.Text, Value.Style and BackgroundInfo.PositionX + 60 or BackgroundInfo.PositionX + 10, Top + 15, (Value.Style and (BackgroundInfo.Width - 50) or BackgroundInfo.Width) + BackgroundInfo.PositionX, (BackgroundInfo.Height + 5) + Top, tocolor(255, 255, 255), 1, NOTIFICATION_CONFIGURATION.ElementsCache.Fonts.Regular, "left", "center", false, true)
				end

				Top = Top + Value.TextSize.Height
			end
		end

		if (NotificationsCache == NotificationMainIndex) then
			NotificationsCache[NotificationMainIndex].Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["default"]
		end
	end
end

function CreateNotification(text, style, duration)
	if (#NotificationsCache >= 0 and not StateHandler) then
		StateHandler = true
		addEventHandler("onClientRender", getRootElement(), OnClientRender, false, "low-100")
	end

	local TextWidth, TextHeight = dxGetTextSize(text, BackgroundInfo.Width, 1, 1, NOTIFICATION_CONFIGURATION.ElementsCache.Fonts.Regular, true, false)

	for Index, Value in ipairs(NotificationsCache) do
		if (Index >= 2) then
			Value.Section = false
		end

		if (text == Value.Text) then
			if (Value.TickCount and Value.Status) then
				Value.Status = "New"
				Value.TickCount = getTickCount()
			end

			table.remove(NotificationsCache, Index)
		end
	end

	local Instance = {
		Text = text, 
		Style = style, 

		Duration = duration or 5000, 
		Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["default"], 

		TickCount = getTickCount(), 
		Status = "New", 

		Animation = {Opacity = 0, Height = 0},
		TextSize = {Width = TextWidth, Height = TextHeight}
	}

	table.insert(NotificationsCache, Instance)

	if (#NotificationsCache >= 2) then
		Instance.Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["bottom"]

		if (NotificationsCache[1]) then
			NotificationsCache[1].Section = NOTIFICATION_CONFIGURATION.ElementsCache.Sections["top"]
		end
	end
end
addEvent("onClientCreateNotification", true)
addEventHandler("onClientCreateNotification", getRootElement(), CreateNotification)