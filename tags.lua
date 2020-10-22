local _, ns = ...

local core, cfg, oUF = ns.core, ns.cfg, ns.oUF

-- ------------------------------------------------------------------------
-- > Custom Tags
-- ------------------------------------------------------------------------

local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

local floor = floor

-- Name
tags["lum:name"] = function(unit, rolf)
  return UnitName(rolf or unit)
end
events["lum:name"] = "UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE"

-- Unit smart level
tags["lum:level"] = function(unit)
  local l = UnitLevel(unit)
  if l <= 0 then
    l = "??"
  end
  return "|cffb9b9b9" .. l .. "|r"
end
events["lum:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- Unit smart level with color and Elite classification
tags["lum:levelplus"] = function(unit)
  local l = UnitLevel(unit)
  local d = GetQuestDifficultyColor(l)

  if l <= 0 then
    l = "??"
  end
  return core:toHex(d.r, d.g, d.b) .. l .. "|r"
end
events["lum:levelplus"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- Unit classification
tags["lum:classification"] = function(unit)
  local c = UnitClassification(unit)
  if (c == "rare") then
    return "|cff008ff7RARE|r"
  elseif (c == "rareelite") then
    return "|cff008ff7RARE|r |cffffe453ELITE|r"
  elseif (c == "elite") then
    return "|cffffe453ELITE|r"
  elseif (c == "worldboss") then
    return "|cfff03a4cBOSS|r"
  elseif (c == "minus") then
    return ""
  end
end
events["lum:classification"] = "UNIT_CLASSIFICATION_CHANGED"

-- Short Unit classification
tags["lum:classificationshort"] = function(unit)
  local c = UnitClassification(unit)
  if (c == "rare") then
    return "|cff008ff7r|r"
  elseif (c == "rareelite") then
    return "|cff008ff7r+|r"
  elseif (c == "elite") then
    return "|cffffe453+|r"
  elseif (c == "worldboss") then
    return "|cfff03a4cb|r"
  elseif (c == "minus") then
    return ""
  end
end
events["lum:classificationshort"] = "UNIT_CLASSIFICATION_CHANGED"

-- Current Spec
tags["lum:spec"] = function()
  return core:GetCurrentSpec()
end
events["lum:spec"] =
  "PLAYER_LOGIN PLAYER_ENTERING_WORLD PLAYER_TALENT_UPDATE CHARACTER_POINTS_CHANGED PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE GROUP_JOINED"

-- Health Value
tags["lum:hpvalue"] = function(unit)
  local min = UnitHealth(unit)
  if min == 0 or not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
    return ""
  end
  return core:shortNumber(min)
end
events["lum:hpvalue"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE"

-- Health Percent
tags["lum:hpperc"] = function(unit)
  local min, max = UnitHealth(unit), UnitHealthMax(unit)
  local percent = floor((min / max) * 100 + 0.5)

  if percent < 100 and percent > 0 then
    return percent .. "%"
  else
    return ""
  end
end
events["lum:hpperc"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"

-- Power value
tags["lum:powervalue"] = function(unit)
  -- Hide it if DC, Ghost or Dead!
  local min, max = UnitPower(unit, UnitPowerType(unit)), UnitPowerMax(unit, UnitPowerType(unit))
  if min == 0 or not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
    return ""
  end

  if min == max and cfg.frames.main.power.text.hideMax then
    return ""
  end

  local _, ptype = UnitPowerType(unit)
  if ptype == "MANA" then
    return floor(min / max * 100) .. "%"
  elseif ptype == "RAGE" or ptype == "RUNIC_POWER" or ptype == "LUNAR_POWER" then
    return floor(min / 10 + 0.5)
  elseif ptype == "INSANITY" then
    return floor(min / 100 + 0.5)
  else
    return min
  end
end
events["lum:powervalue"] = "UNIT_MAXPOWER UNIT_POWER_UPDATE UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE"

-- Alternate Power Percent
tags["lum:altpower"] = function(unit)
  local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)

  if (UnitPowerType(unit) ~= 0) and min ~= max then -- If Power Type is not Mana(it's Energy or Rage) and Mana is not at Maximum
    return floor(min / max * 100) .. "%"
  end
end
events["lum:altpower"] = "UNIT_MAXPOWER UNIT_POWER_UPDATE"

-- Class Power (Combo Points, Insanity, )
tags["lum:classpower"] = function(unit)
  local PlayerClass = core.playerClass
  local num, max, color

  if (PlayerClass == "MONK") then
    -- num = _TAGS['chi']()
    if (GetSpecialization() == SPEC_MONK_WINDWALKER) then
      num = UnitPower("player", Enum.PowerType.Chi)
      max = UnitPowerMax("player", Enum.PowerType.Chi)
      color = "00CC99"
      if (num == max) then
        color = "008FF7"
      end
    end
  elseif (PlayerClass == "WARLOCK") then
    num = UnitPower("player", Enum.PowerType.SoulShards)
    max = UnitPowerMax("player", Enum.PowerType.SoulShards)
    color = "A15CFF"
    if (num == max) then
      color = "FF1A30"
    end
  elseif (PlayerClass == "PALADIN") then
    if (GetSpecialization() == SPEC_PALADIN_RETRIBUTION) then
      num = UnitPower("player", Enum.PowerType.HolyPower)
      max = UnitPowerMax("player", Enum.PowerType.HolyPower)
      color = "FFFF7D"
      if (num == max) then
        color = "FF1A30"
      end
    end
  elseif (PlayerClass == "MAGE") then
    if (GetSpecialization() == SPEC_MAGE_ARCANE) then
      num = UnitPower("player", Enum.PowerType.ArcaneCharges)
      max = UnitPowerMax("player", Enum.PowerType.ArcaneCharges)
      color = "19B6FF"
      if (num == max) then
        color = "0560FA"
      end
    end
  else -- Combo Points
    if (UnitHasVehicleUI("player")) then
      num = GetComboPoints("vehicle", "target")
    else
      num = GetComboPoints("player", "target")
      max = UnitPowerMax("player", Enum.PowerType.ComboPoints)
      color = "FFF569"
      if (num == max) then
        color = "FF1A30"
      end
    end
  end

  if (num and num > 0) then
    return string.format("|cff%s%d|r", color, num)
  end
end
events["lum:classpower"] = "UNIT_POWER_UPDATE SPELLS_CHANGED UNIT_POWER_FREQUENT PLAYER_TARGET_CHANGED"

tags["lum:role"] = function(unit)
  local Role = UnitGroupRolesAssigned(unit)
  local String = ""

  if Role == "TANK" then
    String = "|cff0099CC" .. TANK .. "|r"
  elseif Role == "HEALER" then
    String = "|cff64CC00" .. HEALER .. "|r"
  end

  return String
end
events["lum:role"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

tags["lum:leader"] = function(unit)
  return UnitIsGroupLeader(unit) and "|cffffff00!|r"
end
events["lum:leader"] = "PARTY_LEADER_CHANGED"

tags["lum:afkdnd"] = function(unit)
  if UnitIsAFK(unit) then
    return "|cffCFCFCF " .. AFK .. "|r"
  elseif UnitIsDND(unit) then
    return "|cffCFCFCF " .. DND .. "|r"
  else
    return ""
  end
end
events["lum:afkdnd"] = "PLAYER_FLAGS_CHANGED PLAYER_LOGIN PLAYER_ENTERING_WORLD"

-- AFK and DND status
tags["lum:playerstatus"] = function(unit)
  if UnitIsAFK(unit) then
    return "|cff666666<" .. AFK .. ">|r"
  elseif (UnitIsDead(unit)) then
    return "|cffEA3E3E" .. "<Dead" .. ">|r"
  elseif (UnitIsGhost(unit)) then
    return "|cff3EC1EA" .. "<Ghost" .. ">|r"
  elseif (not UnitIsConnected(unit)) then
    return "|cff828282" .. "<Offline" .. ">|r"
  else
    return ""
  end
end
events["lum:playerstatus"] =
  "UNIT_HEALTH PLAYER_UPDATE_RESTING UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_LOGIN PLAYER_ENTERING_WORLD"
