local _, ns = ...

local core, cfg, m, oUF = CreateFrame("Frame"), ns.cfg, ns.m, ns.oUF
ns.core = core

-- ------------------------------------------------------------------------
-- > CORE FUNCTIONS
-- ------------------------------------------------------------------------

-- -----------------------------------
-- > PLAYER SPECIFIC
-- -----------------------------------

core.playerClass = select(2, UnitClass("player"))
core.playerColor = RAID_CLASS_COLORS[core.playerClass]
core.playerName  = UnitName("player")
core.playerLevel = UnitLevel("player")

-- -----------------------------------
-- > API
-- -----------------------------------

-- Is Player max level?
function core:isPlayerMaxLevel()
  return core.playerLevel == GetMaxPlayerLevel() and true or false
end

-- Get Unit Experience
function core:getXp(unit)
  if(unit == 'pet') then
    return GetPetExperience()
  else
    return UnitXP(unit), UnitXPMax(unit)
  end
end

-- Unit has a Debuff
function core:hasUnitDebuff(unit, name, myspell)
  local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
  if myspell then
    if (count and caster == 'player') then return count end
  else
    if count then return count end
  end
end

-- Class colors
function core:raidColor(unit)
  local _, x = UnitClass(unit)
  local color = RAID_CLASS_COLORS[x]
  return color and {color.r, color.g, color.b} or {.5, .5, .5}
  -- return oUF.colors.class[x]
end

-- -----------------------------------
-- > EXTRA FUNCTIONS
-- -----------------------------------

-- Generates the Name String
function core:createNameString(self, font, size, outline, x, y, point, width)
  self.Name = core:createFontstring(self.Health, font, size, outline)
  self.Name:SetPoint(point, self.Health, x, y)
  self.Name:SetJustifyH(point)
  self.Name:SetWidth(width)
  self.Name:SetHeight(size)
end

-- Generates the Party Name String
function core:createPartyNameString(self, font, size)
  self.Name = core:createFontstring(self, font, size, "THINOUTLINE")
  self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
  self.Name:SetJustifyH("LEFT")
end

function core:createHPString(self, font, size, outline, x, y, point)
	self.Health.value = core:createFontstring(self.Health, font, size, outline)
	self.Health.value:SetPoint(point, self.Health, x, y)
	self.Health.value:SetJustifyH(point)
	self.Health.value:SetTextColor(1,1,1)
end

function core:createHPPercentString(self, font, size, outline, x, y, point, layer)
  self.Health.percent = core:createFontstring(self.Health, font, size, outline, layer)
  self.Health.percent:SetPoint(point, self.Health.value, x, y)
  self.Health.percent:SetJustifyH("RIGHT")
  self.Health.percent:SetTextColor(0.5, 0.5, 0.5, 0.5)
  self.Health.percent:SetShadowColor(0, 0, 0, 0)
  self:Tag(self.Health.percent, '[lumen:hpperc]')
end

-- Generates the Power Percent String
function core:createPowerString(self, font, size, outline, x, y, point)
  self.Power.value = core:createFontstring(self.Power, font, size, outline)
  self.Power.value:SetPoint(point, self.Power, x, y)
  self.Power.value:SetJustifyH(point)
  self:Tag(self.Power.value, '[lumen:powervalue]')
end

-- Create Glow Border
function core:setglowBorder(self)
  self.Glowborder = CreateFrame("Frame", nil, self)
  self.Glowborder:SetFrameLevel(0)
  self.Glowborder:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
  self.Glowborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
  self.Glowborder:SetBackdrop({bgFile = m.textures.white_square, edgeFile =  m.textures.glow_texture,
    tile = false, tileSize = 16, edgeSize = 4, insets = {left = -4, right = -4, top = -4, bottom = -4}})
  self.Glowborder:SetBackdropColor(0, 0, 0, 0)
  self.Glowborder:SetBackdropBorderColor(0, 0, 0, 1)
end
