local _, ns = ...

local core = ns.core

local floor, mod = floor, mod

-- Shortens Numbers
function core:shortNumber(v)
  if v > 1E10 then
    return (floor(v / 1E9)) .. "|cff999999b|r"
  elseif v > 1E9 then
    return (floor((v / 1E9) * 10) / 10) .. "|cff999999b|r"
  elseif v > 1E7 then
    return (floor(v / 1E6)) .. "|cff999999m|r"
  elseif v > 1E6 then
    return (floor((v / 1E6) * 10) / 10) .. "|cff999999m|r"
  elseif v > 1E4 then
    return (floor(v / 1E3)) .. "|cff999999k|r"
  elseif v > 1E3 then
    return (floor((v / 1E3) * 10) / 10) .. "|cff999999k|r"
  else
    return v
  end
end

function core:NumberToPerc(v1, v2)
  return floor(v1 / v2 * 100 + 0.5)
end

function core:formatTime(s)
  local day, hour, minute = 86400, 3600, 60

  if s >= day then
    return format("%dd", floor(s / day + 0.5))
  elseif s >= hour then
    return format("%dh", floor(s / hour + 0.5))
  elseif s >= minute then
    return format("%dm", floor(s / minute + 0.5))
  end
  return format("%d", mod(s, minute))
end
