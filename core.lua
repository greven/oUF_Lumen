local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local floor, mod = floor, mod

-- ------------------------------------------------------------------------
-- > MATH
-- ------------------------------------------------------------------------

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

-- ------------------------------------------------------------------------
-- > UTILITY FUNCTIONS
-- ------------------------------------------------------------------------

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

-- Class colors
function core:RaidColor(unit)
  local _, x = UnitClass(unit)
  local color = RAID_CLASS_COLORS[x]
  return color and {color.r, color.g, color.b} or {.5, .5, .5}
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

-- Is Player max level?
function core:IsPlayerMaxLevel()
  return G.playerLevel == GetMaxPlayerLevel() and true or false
end

-- Get Unit Experience
function core:GetXP(unit)
  if (unit == "pet") then
    return GetPetExperience()
  else
    return UnitXP(unit), UnitXPMax(unit)
  end
end

function core:GetUnitAura(unit, spell, filter)
  for index = 1, 40 do
    local name, _, count, _, duration, expire, caster, _, _, spellID, _, _, _, _, _, value = UnitAura(unit, index, filter)
    if not name then
      break
    end
    if name and spellID == spell then
      return name, count, duration, expire, caster, spellID, value
    end
  end
end

-- Unit has a Debuff
function core:HasUnitDebuff(unit, name, spell)
  local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
  if spell then
    if count and caster == "player" then
      return count
    end
  else
    if count then
      return count
    end
  end
end

-- Is the player a healer? (healing spec)
function core:IsPlayerHealer()
  local currentSpec = core:GetCurrentSpec()
  local isHealer = core:HasValue(cfg.healingSpecs, currentSpec)
  return isHealer
end

-- Get current specialization name
function core:GetCurrentSpec()
  local specID = GetSpecialization()

  if (specID) then
    local _, currentSpecName = GetSpecializationInfo(specID)
    return currentSpecName
  end

  return nil
end
