local _, ns = ...

local math = CreateFrame("Frame")
ns.math = math

local floor, mod = floor, mod

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

function math:formatTime(s)
  local day, hour, minute = 86400, 3600, 60

  if s >= day then
    return format('%dd', floor(s/day + 0.5))
  elseif s >= hour then
    return format('%dh', floor(s/hour + 0.5))
  elseif s >= minute then
    return format('%dm', floor(s/minute + 0.5))
  end
  return format('%d', mod(s, minute))
end
