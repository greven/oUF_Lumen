local _, ns = ...

local core = CreateFrame("Frame") -- Core methods
ns.core = core

local floor, mod = floor, mod

-- ------------------------------------------------------------------------
-- > MATH
-- ------------------------------------------------------------------------


function core:Round(number, idp)
  idp = idp or 0
  local mult = 10 ^ idp
  return floor(number * mult + .5) / mult
end

-- Shortens Numbers
function core:ShortNumber(v)
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

function core:FormatTime(s)
  local day, hour, minute = 86400, 3600, 60

  if s >= day then
    return format("%dd", floor(s / day + 0.5))
  elseif s >= hour then
    return format("%dh", floor(s / hour + 0.5))
  elseif s >= minute then
    return format("%dm", floor(s / minute + 0.5))
  end

  -- Seconds
  local t = mod(s, minute)
  if t > 1 then
    return format("%d", t)
  end
  return format("%.1f", t)
end

function core:GetTotalElements(elements)
  local count = 0
  for _ in pairs(elements) do
    count = count + 1
  end
  return count
end

-- Check if the array contains a specific value
function core:HasValue(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

-- Convert color to HEX
function core:ToHex(r, g, b)
  if r then
    if (type(r) == "table") then
      if (r.r) then
        r, g, b = r.r, r.g, r.b
      else
        r, g, b = unpack(r)
      end
    end
    return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
  end
end

-- Make color lighter (add white)
function core:TintColor(r, g, b, factor)
  if not r or not factor then
    return
  end

  local R = r + (1 - r) * factor
  local G = g + (1 - g) * factor
  local B = b + (1 - b) * factor

  return R, G, B
end

-- Make color darker (add black)
function core:ShadeColor(r, g, b, factor)
  if not r or not factor then
    return
  end

  local R = r * (1 - factor)
  local G = g * (1 - factor)
  local B = b * (1 - factor)

  return R, G, B
end
