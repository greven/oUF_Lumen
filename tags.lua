local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m,
                                       ns.G, ns.oUF

-- ------------------------------------------------------------------------
-- > Tags
-- ------------------------------------------------------------------------

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local format = string.format
local floor = floor

local events = {
    name = "UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE",
    level = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED",
    levelplus = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED",
    classification = "UNIT_CLASSIFICATION_CHANGED",
    classificationshort = "UNIT_CLASSIFICATION_CHANGED",
    spec = "PLAYER_LOGIN PLAYER_ENTERING_WORLD PLAYER_TALENT_UPDATE CHARACTER_POINTS_CHANGED PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE GROUP_JOINED",
    ishealer = "PLAYER_LOGIN PLAYER_ENTERING_WORLD PLAYER_TALENT_UPDATE CHARACTER_POINTS_CHANGED PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE GROUP_JOINED",
    hpvalue = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE",
    hpperc = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE",
    powervalue = "UNIT_MAXPOWER UNIT_POWER_UPDATE UNIT_CONNECTION PLAYER_DEAD PLAYER_ALIVE",
    altpower = "UNIT_MAXPOWER UNIT_POWER_UPDATE",
    classpower = "UNIT_POWER_UPDATE PLAYER_TARGET_CHANGED",
    role = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE",
    leader = "PARTY_LEADER_CHANGED",
    afkdnd = "PLAYER_FLAGS_CHANGED PLAYER_LOGIN PLAYER_ENTERING_WORLD",
    playerstatus = "UNIT_HEALTH PLAYER_UPDATE_RESTING UNIT_CONNECTION PLAYER_FLAGS_CHANGED PLAYER_LOGIN PLAYER_ENTERING_WORLD"
}

local _tags = {
    -- Unit name
    name = function(unit, rolf) return UnitName(rolf or unit) end,
    -- Unit smart level
    level = function(unit)
        local l = UnitLevel(unit)
        if l <= 0 then l = "??" end
        return "|cffb9b9b9" .. l .. "|r"
    end,
    -- Unit smart level with color and Elite classification
    levelplus = function(unit)
        local l = UnitLevel(unit)
        local d = GetQuestDifficultyColor(l)

        if l <= 0 then l = "??" end
        return core:ToHex(d.r, d.g, d.b) .. l .. "|r"
    end,
    -- Unit classification
    classification = function(unit)
        local c = UnitClassification(unit)

        if c == "worldboss" or UnitLevel(unit) <= 0 then
            return "|cffF5283CBOSS|r"
        elseif c == "rare" then
            return "|cff008FF7RARE|r"
        elseif c == "rareelite" then
            return "|cff008FF7RARE|r |cffFFD700ELITE|r"
        elseif c == "elite" then
            return "|cffFFD700ELITE|r"
        elseif c == "minus" then
            return ""
        end
    end,
    -- Short Unit classification
    classificationshort = function(unit)
        local c = UnitClassification(unit)

        if c == "worldboss" or UnitLevel(unit) <= 0 then
            return "|cffF5283Cb|r"
        elseif c == "rare" then
            return "|cff008FF7r|r"
        elseif c == "rareelite" then
            return "|cff008FF7r+|r"
        elseif c == "elite" then
            return "|cffFFD700+|r"
        elseif c == "minus" then
            return ""
        end
    end,
    -- Current Spec
    spec = function() return GetSpecialization() end,
    ishealer = function() return api:IsPlayerHealer() end,
    -- Health Value
    hpvalue = function(unit)
        local min = UnitHealth(unit)
        if min == 0 or not UnitIsConnected(unit) or UnitIsGhost(unit) or
            UnitIsDead(unit) then return "" end
        return core:ShortNumber(min)
    end,
    -- Health Percent
    hpperc = function(unit)
        local min, max = UnitHealth(unit), UnitHealthMax(unit)
        local percent = floor((min / max) * 100 + 0.5)

        if percent < 100 and percent > 0 then
            return percent .. "%"
        else
            return ""
        end
    end,
    -- Power value
    powervalue = function(unit)
        -- Hide it if DC, Ghost or Dead!
        local min, max = UnitPower(unit, UnitPowerType(unit)),
                         UnitPowerMax(unit, UnitPowerType(unit))
        if min == 0 or not UnitIsConnected(unit) or UnitIsGhost(unit) or
            UnitIsDead(unit) then return "" end

        if min == max and cfg.frames.main.power.text.hideMax then
            return ""
        end

        local _, ptype = UnitPowerType(unit)
        if ptype == "MANA" then
            return floor(min / max * 100) .. "%"
        elseif ptype == "RAGE" or ptype == "RUNIC_POWER" or ptype ==
            "LUNAR_POWER" then
            return floor(min / 10 + 0.5)
        elseif ptype == "INSANITY" then
            return floor(min / 100 + 0.5)
        else
            return min
        end
    end,
    -- Alternate Power Percent
    altpower = function(unit)
        local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)

        if (UnitPowerType(unit) ~= 0) and min ~= max then -- If Power Type is not Mana(it's Energy or Rage) and Mana is not at Maximum
            return floor(min / max * 100) .. "%"
        end
    end,
    -- Class Power (Combo Points, Insanity, )
    classpower = function(unit)
        local SPEC_MAGE_ARCANE = SPEC_MAGE_ARCANE or 1
        local SPEC_MONK_WINDWALKER = SPEC_MONK_WINDWALKER or 3
        local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints or 4
        local SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards or 7
        local SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower or 9
        local SPELL_POWER_CHI = Enum.PowerType.Chi or 12
        local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges or 16

        local GetSpecialization = GetSpecialization

        local ClassPowerID, ClassPowerType, RequireSpec
        local PlayerClass = G.playerClass

        if (PlayerClass == "MONK") then
            ClassPowerID = SPELL_POWER_CHI
            ClassPowerType = "CHI"
            RequireSpec = SPEC_MONK_WINDWALKER
        elseif (PlayerClass == "PALADIN") then
        elseif (PlayerClass == "PALADIN") then
            ClassPowerID = SPELL_POWER_HOLY_POWER
            ClassPowerType = "HOLY_POWER"
        elseif (PlayerClass == "WARLOCK") then
            ClassPowerID = SPELL_POWER_SOUL_SHARDS
            ClassPowerType = "SOUL_SHARDS"
        elseif (PlayerClass == "ROGUE" or PlayerClass == "DRUID") then
            ClassPowerID = SPELL_POWER_COMBO_POINTS
            ClassPowerType = "COMBO_POINTS"
        elseif (PlayerClass == "MAGE") then
            ClassPowerID = SPELL_POWER_ARCANE_CHARGES
            ClassPowerType = "ARCANE_CHARGES"
            RequireSpec = SPEC_MAGE_ARCANE
        end

        local powerID = unit == "vehicle" and SPELL_POWER_COMBO_POINTS or
                            ClassPowerID
        local powerType = unit == "vehicle" and "COMBO_POINTS" or ClassPowerType

        if RequireSpec and RequireSpec ~= GetSpecialization() or not powerID then
            return
        end

        local cur = UnitPower("player", powerID)
        local max = UnitPowerMax("player", powerID)
        local color, maxColor = oUF.colors.power[powerType],
                                oUF.colors.power.max[powerType]

        if cur == max then color = maxColor end

        if cur and cur > 0 then
            return format("%s%d|r", core:ToHex(color), cur)
        end
    end,
    role = function(unit)
        local Role = UnitGroupRolesAssigned(unit)
        local String = ""

        if Role == "TANK" then
            String = "|cff0099CC" .. TANK .. "|r"
        elseif Role == "HEALER" then
            String = "|cff64CC00" .. HEALER .. "|r"
        end

        return String
    end,
    leader = function(unit)
        return UnitIsGroupLeader(unit) and "|cffffff00!|r"
    end,
    afkdnd = function(unit)
        if UnitIsAFK(unit) then
            return "|cffCFCFCF " .. AFK .. "|r"
        elseif UnitIsDND(unit) then
            return "|cffCFCFCF " .. DND .. "|r"
        else
            return ""
        end
    end,
    -- AFK and DND status
    playerstatus = function(unit)
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
}

for tag, func in next, _tags do
    tagMethods["lum:" .. tag] = func
    tagEvents["lum:" .. tag] = events[tag]
end
