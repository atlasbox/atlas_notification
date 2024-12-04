function CreateNotification(element, text, style, duration)
	triggerClientEvent(element, "onClientCreateNotification", element, text, style, duration)
end