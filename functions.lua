local _, ns = ...

local lum = CreateFrame("Frame", "oUF_lumen")
local core, cfg, m, oUF = ns.core, ns.cfg, ns.m, ns.oUF or oUF
ns.lum, ns.oUF = lum, oUF

local font = m.fonts.font

-- -----------------------------------
-- > Heal Prediction
-- -----------------------------------

-- myBar          - A `StatusBar` used to represent incoming heals from the player.
-- otherBar       - A `StatusBar` used to represent incoming heals from others.
-- absorbBar      - A `StatusBar` used to represent damage absorbs.
-- healAbsorbBar  - A `StatusBar` used to represent heal absorbs.
-- overAbsorb     - A `Texture` used to signify that the amount of damage absorb is greater than the unit's missing health.
-- overHealAbsorb - A `Texture` used to signify that the amount of heal absorb is greater than the unit's current health.

function lum:CreateHealPrediction(self)
  local myBar = CreateFrame("StatusBar", nil, self.Health)
  myBar:SetPoint("TOP")
  myBar:SetPoint("BOTTOM")
  myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  myBar:SetWidth(self.cfg.width)
  myBar:SetStatusBarTexture(m.textures.status_texture)
  myBar:SetStatusBarColor(125 / 255, 255 / 255, 50 / 255, .4)

  local otherBar = CreateFrame("StatusBar", nil, self.Health)
  otherBar:SetPoint("TOP")
  otherBar:SetPoint("BOTTOM")
  otherBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  otherBar:SetWidth(self.cfg.width)
  otherBar:SetStatusBarTexture(m.textures.status_texture)
  otherBar:SetStatusBarColor(100 / 255, 235 / 255, 200 / 255, .4)

  local absorbBar = CreateFrame("StatusBar", nil, self.Health)
  absorbBar:SetPoint("TOP")
  absorbBar:SetPoint("BOTTOM")
  absorbBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  absorbBar:SetWidth(self.cfg.width)
  absorbBar:SetStatusBarTexture(m.textures.status_texture)
  absorbBar:SetStatusBarColor(18053 / 255, 255 / 255, 205 / 255, .35)

  local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
  healAbsorbBar:SetPoint("TOP")
  healAbsorbBar:SetPoint("BOTTOM")
  healAbsorbBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
  healAbsorbBar:SetWidth(self.cfg.width)
  healAbsorbBar:SetStatusBarTexture(m.textures.status_texture)
  healAbsorbBar:SetStatusBarColor(183 / 255, 244 / 255, 255 / 255, .35)

  -- Register with oUF
  self.HealthPrediction = {
    myBar = myBar,
    otherBar = otherBar,
    absorbBar = absorbBar,
    healAbsorbBar = healAbsorbBar,
    maxOverflow = 1
  }
end

-- -----------------------------------
-- > Class Power
-- -----------------------------------

-- Post Update ClassPower
local function PostUpdateClassPower(element, cur, max, diff, powerType)
  if (diff) then
    local maxWidth, gap = cfg.frames.main.width, 6

    for index = 1, max do
      local Bar = element[index]
      Bar:SetWidth(((maxWidth / max) - (((max - 1) * gap) / max)))

      if (index > 1) then
        Bar:ClearAllPoints()
        Bar:SetPoint("LEFT", element[index - 1], "RIGHT", gap, 0)
      end
    end
  end

  -- Colorize the last bar
  local LastBarColor = {
    DRUID = {161 / 255, 92 / 255, 255 / 255},
    MAGE = {5 / 255, 96 / 255, 250 / 255},
    MONK = {0 / 255, 143 / 255, 247 / 255},
    PALADIN = {255 / 255, 26 / 255, 48 / 255},
    ROGUE = {161 / 255, 92 / 255, 255 / 255},
    WARLOCK = {255 / 255, 26 / 255, 48 / 255}
  }

  if max then
    local LastBar = element[max]
    local r, g, b = unpack(LastBarColor[core.playerClass])

    if not LastBar then
      return
    end
    LastBar:SetStatusBarColor(r, g, b)
    LastBar.bg:SetColorTexture(r * 0.2, g * 0.2, b * 0.2)
  end
end

-- Post Update ClassPower Texture
local function UpdateClassPowerColor(element)
  -- Default color
  local r, g, b = 102 / 255, 221 / 255, 255 / 255

  if (not UnitHasVehicleUI("player")) then
    if (core.playerClass == "ROGUE") then
      r, g, b = 255 / 255, 26 / 255, 48 / 255
    elseif (core.playerClass == "DRUID") then
      r, g, b = 255 / 255, 26 / 255, 48 / 255
    elseif (core.playerClass == "MONK") then
      r, g, b = 0, 204 / 255, 153 / 255
    elseif (core.playerClass == "WARLOCK") then
      r, g, b = 161 / 255, 92 / 255, 255 / 255
    elseif (core.playerClass == "PALADIN") then
      r, g, b = 255 / 255, 255 / 255, 125 / 255
    elseif (core.playerClass == "MAGE") then
      r, g, b = 25 / 255, 182 / 255, 255 / 255
    end
  end

  for index = 1, #element do
    local Bar = element[index]
    Bar:SetStatusBarColor(r, g, b)
    Bar.bg:SetColorTexture(r * 0.2, g * 0.2, b * 0.2)
  end
end

-- Create Class Power Bars (Combo Points...)
local function CreateClassPower(self)
  local ClassPower = {}
  ClassPower.UpdateColor = UpdateClassPowerColor
  ClassPower.PostUpdate = PostUpdateClassPower

  for index = 1, 10 do
    local Bar = CreateFrame("StatusBar", "oUF_LumenClassPower", self, "BackdropTemplate")
    Bar:SetHeight(cfg.frames.main.classPower.height)
    Bar:SetStatusBarTexture(m.textures.status_texture)
    core:setBackdrop(Bar, 1.5, 1.5, 1.5, 1.5)

    if (index > 1) then
      Bar:SetPoint("LEFT", ClassPower[index - 1], "RIGHT", 6, 0)
    else
      Bar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
    end

    if (index > 5) then
      Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
    end

    local Background = Bar:CreateTexture(nil, "BORDER")
    Background:SetAllPoints()
    Background:SetTexture(m.textures.bg_texture)
    Bar.bg = Background

    ClassPower[index] = Bar
  end

  self.ClassPower = ClassPower
end

-- Death Knight Runebar
local function CreateRuneBar(self)
  local Runes = {}
  Runes.sortOrder = "asc"
  Runes.colorSpec = true -- color runes by spec

  for index = 1, 6 do
    local Rune = CreateFrame("StatusBar", nil, self)
    local numRunes, maxWidth, gap = 6, cfg.frames.main.width, 6
    local width = ((maxWidth / numRunes) - (((numRunes - 1) * gap) / numRunes))

    Rune:SetSize(width, 2)
    Rune:SetStatusBarTexture(m.textures.status_texture)
    core:setBackdrop(Rune, 2, 2, 2, 2) -- Backdrop

    if (index == 1) then
      Rune:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
    else
      Rune:SetPoint("LEFT", Runes[index - 1], "RIGHT", gap, 0)
    end

    local RuneBG = Rune:CreateTexture(nil, "BORDER")
    RuneBG:SetAllPoints()
    RuneBG:SetTexture(m.textures.bg_texture)
    RuneBG.multiplier = 0.2
    Rune.bg = RuneBG

    Runes[index] = Rune
  end

  self.Runes = Runes
end

-- Class Power (Combo Points, Runes, etc...)
function lum:CreateClassPower(self)
  if
    core.playerClass == "ROGUE" or core.playerClass == "DRUID" or core.playerClass == "MAGE" or
      core.playerClass == "MONK" or
      core.playerClass == "PALADIN" or
      core.playerClass == "WARLOCK"
   then
    CreateClassPower(self)
  end

  -- Death Knight Runes
  if core.playerClass == "DEATHKNIGHT" then
    CreateRuneBar(self)
  end
end

-- ----------------------------------------
-- > Additional Power
-- Power bar for specs like Feral Druid
-- ----------------------------------------

-- AdditionalPower post update callback
local function onAdditionalPowerPostUpdate(self, cur, max)
  local powertype = UnitPowerType("player")

  if powertype == 0 then
    return
  end

  -- Hide bar if full
  if cur == max or powertype == 0 then
    self:Hide()
  else
    self:Show()
  end
end

function lum:CreateAdditionalPower(self)
  local height = -18
  local r, g, b = unpack(oUF.colors.power[ADDITIONAL_POWER_BAR_NAME])

  local AdditionalPower = CreateFrame("StatusBar", nil, self, "BackdropTemplate")
  AdditionalPower:SetStatusBarTexture(m.textures.status_texture)
  AdditionalPower:GetStatusBarTexture():SetHorizTile(false)
  AdditionalPower:SetSize(self.cfg.width, self.cfg.altpower.height)
  AdditionalPower:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, height)
  AdditionalPower:SetStatusBarColor(r, g, b)
  AdditionalPower.frequentUpdates = true

  -- Add a background
  local bg = AdditionalPower:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(AdditionalPower)
  bg:SetTexture(m.textures.bg_texture)
  bg:SetVertexColor(r * 0.3, g * 0.3, b * 0.3)

  -- Value
  local PowerValue = core:createFontstring(AdditionalPower, font, cfg.fontsize - 4, "THINOUTLINE")
  PowerValue:SetPoint("RIGHT", AdditionalPower, -8, 0)
  PowerValue:SetJustifyH("RIGHT")
  self:Tag(PowerValue, "[lum:altpower]")

  -- Backdrop
  core:setBackdrop(AdditionalPower, 1, 1, 1, 1)

  AdditionalPower.bg = bg
  AdditionalPower.PostUpdate = onAdditionalPowerPostUpdate
  self.AdditionalPower = AdditionalPower
end

-- -----------------------------------
-- > Power Prediction
-- -----------------------------------

function lum:CreatePowerPrediction(self)
  local mainBar = CreateFrame("StatusBar", nil, self.Power)
  mainBar:SetStatusBarTexture(m.textures.status_texture)
  mainBar:SetStatusBarColor(0.4, 0.8, 1, 0.7)
  mainBar:SetReverseFill(true)
  mainBar:SetPoint("TOP")
  mainBar:SetPoint("BOTTOM")
  mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT")
  mainBar:SetWidth(self.cfg.width)

  local altBar = CreateFrame("StatusBar", nil, self.AdditionalPower)
  altBar:SetStatusBarTexture(m.textures.status_texture)
  altBar:SetStatusBarColor(1, 1, 1, 0.5)
  altBar:SetReverseFill(true)
  altBar:SetPoint("TOP")
  altBar:SetPoint("BOTTOM")
  altBar:SetPoint("RIGHT", self.AdditionalPower:GetStatusBarTexture(), "RIGHT")
  altBar:SetWidth(self.cfg.width)

  -- Register with oUF
  self.PowerPrediction = {
    mainBar = mainBar,
    altBar = altBar
  }
end

-- -----------------------------------
-- > Alternative Power
-- Quest or boss special power
-- -----------------------------------

-- AltPower PostUpdate
local function AltPowerPostUpdate(self, unit, cur, min, max)
  if self.unit ~= unit then
    return
  end

  local _, r, g, b = _G.UnitAlternatePowerTextureInfo(self.__owner.unit, 2)

  if (r == 1 and g == 1 and b == 1) or not b then
    r, g, b = 1, 0, 0
  end

  self:SetStatusBarColor(r, g, b)
  if cur < max then
    if self.isMouseOver then
      self.Text:SetFormattedText(
        "%s / %s - %d%%",
        core:shortNumber(cur),
        core:shortNumber(max),
        core:NumberToPerc(cur, max)
      )
    elseif cur > 0 then
      self.Text:SetFormattedText("%s", core:shortNumber(cur))
    else
      self.Text:SetText(nil)
    end
  else
    if self.isMouseOver then
      self.Text:SetFormattedText("%s", core:shortNumber(cur))
    else
      self.Text:SetText(nil)
    end
  end
end

local function AlternativePowerOnEnter(self)
  if not self:IsVisible() then
    return
  end

  self.isMouseOver = true
  self:ForceUpdate()
  _G.GameTooltip_SetDefaultAnchor(_G.GameTooltip, self)
  self:UpdateTooltip()
end

local function AlternativePowerOnLeave(self)
  self.isMouseOver = nil
  self:ForceUpdate()
  _G.GameTooltip:Hide()
end

function lum:CreateAlternativePower(self)
  if cfg.elements.altpowerbar.show then
    local AlternativePower = CreateFrame("StatusBar", nil, self)
    AlternativePower:SetStatusBarTexture(m.textures.status_texture)
    core:setBackdrop(AlternativePower, 2, 2, 2, 2)
    AlternativePower:SetHeight(16)
    AlternativePower:SetWidth(200)
    AlternativePower:SetPoint("CENTER", "UIParent", "CENTER", 0, 350)

    AlternativePower.Text = core:createFontstring(AlternativePower, font, 10, "THINOUTLINE")
    AlternativePower.Text:SetPoint("CENTER", 0, 0)

    local AlternativePowerBG = AlternativePower:CreateTexture(nil, "BORDER")
    AlternativePowerBG:SetAllPoints()
    AlternativePowerBG:SetAlpha(0.3)
    AlternativePowerBG:SetTexture(m.textures.bg_texture)
    AlternativePowerBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

    AlternativePower:EnableMouse(true)
    AlternativePower:SetScript("OnEnter", AlternativePowerOnEnter)
    AlternativePower:SetScript("OnLeave", AlternativePowerOnLeave)
    AlternativePower.PostUpdate = AltPowerPostUpdate

    self.AlternativePower = AlternativePower
  end
end

-- ------------------------------------------
-- > Icon Indicators (Combat, Resting, etc.)
-- ------------------------------------------

function lum:CreateIconIndicators(self)
  -- Combat indicator
  local Combat = core:createFontstring(self, m.fonts.symbols, 18, "THINOUTLINE")
  Combat:SetPoint("RIGHT", self, "LEFT", -10, 0)
  Combat:SetText("")
  Combat:SetTextColor(255 / 255, 26 / 255, 48 / 255, 0.9)
  self.CombatIndicator = Combat

  -- Resting
  if not core:isPlayerMaxLevel() then
    local Resting = core:createFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE")
    Resting:SetPoint("CENTER", self.Health, "TOP", 0, 1)
    Resting:SetText("zZz")
    Resting:SetTextColor(255 / 255, 255 / 255, 255 / 255, 0.80)
    self.RestingIndicator = Resting
  end
end
