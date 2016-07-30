local _, ns = ...

local math = CreateFrame("Frame")
ns.math = math

-- Shortens Numbers
function math:shortNumber(v)
  if v > 1E10 then
		return (floor(v/1E9)).."b"
	elseif v > 1E9 then
		return (floor((v/1E9)*10)/10).."b"
	elseif v > 1E7 then
		return (floor(v/1E6)).."m"
	elseif v > 1E6 then
		return (floor((v/1E6)*10)/10).."m"
	elseif v > 1E4 then
		return (floor(v/1E3)).."k"
	elseif v > 1E3 then
		return (floor((v/1E3)*10)/10).."k"
	else
		return v
	end
end

-- Format Time
function math:formatTime(time)
  if time >= 86400 then -- Days
    return format("%d|cff999999d|r", floor(time/86400 + 0.5))
  elseif time >= 3600 then -- Hours
    return format("%d|cff999999h|r", floor(time/3600 + 0.5))
  elseif time >= 60 then -- Minutes
    return format("%d|cff999999m|r", floor(time/60 + 0.5))
  elseif time >= 0 then -- Seconds
    return floor(mod(time, 60))
  end
end
