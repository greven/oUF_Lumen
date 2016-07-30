local _, ns = ...

local core, cfg, math, oUF = ns.core, ns.cfg, ns.math, ns.oUF

-- ------------------------------------------------------------------------
-- > Custom Tags
-- ------------------------------------------------------------------------

local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

local floor = floor

-- Name
tags["lumen:name"] = function(unit, rolf)
  return UnitName(rolf or unit)
end
events["lumen:name"] = "UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE"

-- Health Value
tags['lumen:hpvalue'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	if min == 0 or not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
		return ''
	end
	return math:shortNumber(min)
end
events['lumen:hpvalue'] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE"

-- Health Percent
tags['lumen:hpperc'] = function(unit)
    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local percent = floor((min / max) * 100+0.5)

    if percent < 100 then
    	return percent .. "%"
    else
    	return ''
    end
  end
events['lumen:hpperc'] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"

-- Power value
tags['lumen:powervalue'] = function(unit)
	local min, max = UnitPower(unit, UnitPowerType(unit)), UnitPowerMax(unit,  UnitPowerType(unit))
	if min == 0 or min == max or not UnitIsConnected(unit) or UnitIsGhost(unit) or UnitIsDead(unit) then
		return ''
	end

  local _, ptype = UnitPowerType(unit)
  if ptype == "MANA" then
	   return floor(min / max * 100).."%"
  else
    return min
  end
end
events['lumen:powervalue'] = "UNIT_MAXPOWER UNIT_POWER UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE"
