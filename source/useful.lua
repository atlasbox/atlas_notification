function Lerp(a, b, t)
	return a + (b - a) * t
end

function Length(stack)
	local Count = 0

	for Key in pairs(stack) do
		Count = Count + 1
	end

	return Count
end