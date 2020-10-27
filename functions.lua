local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters, debuffs = ns.filters, ns.debuffs

local UnitAura, UnitPowerType = UnitAura, UnitPowerType

local font = m.fonts.font

-- -----------------------------------
-- > Auras
-- -----------------------------------

function lum:SetBuffAuras(
  self,
  frame,
  numAuras,
  numRows,
  height,
  width,
  anchor,
  parent,
  parentAnchor,
  posX,
  posY,
  initialAnchor,
  growthX,
  growthY,
  showStealableBuffs)
  if not cfg.units[frame].auras.buffs.show then
    return
  end

  local buffs = lum:CreateAura(self, numAuras, numRows, height, width)
  buffs:SetPoint(anchor, parent, parentAnchor, posX, posY)
  buffs.initialAnchor = initialAnchor
  buffs["growth-y"] = growthY or "DOWN"
  buffs["growth-x"] = growthX or "RIGHT"
  buffs.showStealableBuffs = showStealableBuffs
  self.Buffs = buffs
  return buffs
end

function lum:SetDebuffAuras(
  self,
  frame,
  numAuras,
  numRows,
  height,
  width,
  anchor,
  parent,
  parentAnchor,
  posX,
  posY,
  initialAnchor,
  growthX,
  growthY,
  showDebuffType,
  onlyShowPlayer)
  if not cfg.units[frame].auras.debuffs.show then
    return
  end

  -- Debuffs filter (Blacklist)
  local CustomFilter = function(element, unit, button, name, _, _, _, duration, _, _, _, _, spellID)
    if spellID then
      if debuffs.list[frame][spellID] or duration == 0 then
        return false
      end
    end
    return true
  end

  local debuffs = lum:CreateAura(self, numAuras, numRows, height, width)
  debuffs:SetPoint(anchor, parent, parentAnchor, posX, posY)
  debuffs.initialAnchor = initialAnchor
  debuffs["growth-y"] = growthY or "DOWN"
  debuffs["growth-x"] = growthX or "RIGHT"
  debuffs.showDebuffType = showDebuffType
  debuffs.onlyShowPlayer = onlyShowPlayer
  debuffs.CustomFilter = CustomFilter
  self.Debuffs = debuffs
  return debuffs
end

function lum:SetBarTimerAuras(
  self,
  frame,
  numAuras,
  numRows,
  size,
  spacing,
  anchor,
  parent,
  parentAnchor,
  posX,
  posY,
  initialAnchor,
  growthY)
  if not cfg.units[frame].auras.barTimers.show then
    return
  end

  local PlayerCustomFilter = function(...)
    local spellID = select(13, ...)
    if spellID then
      if filters["ALL"].buffs[spellID] or filters[G.playerClass].buffs[spellID] then
        return true
      end
    end
  end

  local TargetCustomFilter = function(element, unit, button, name, _, _, _, duration, _, _, _, _, spellID)
    if spellID then
      if (filters[G.playerClass].debuffs[spellID] and button.isPlayer) then
        return true
      end
    end
  end

  local barTimers = lum:CreateBarTimer(self, numAuras, numRows, size, spacing)
  barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
  barTimers.initialAnchor = "BOTTOMLEFT"
  barTimers["growth-y"] = "UP"

  if frame == "player" then
    barTimers.CustomFilter = PlayerCustomFilter
    self.Buffs = barTimers
  end

  if frame == "target" then
    barTimers.CustomFilter = TargetCustomFilter
    self.Debuffs = barTimers
  end

  return barTimers
end

-- -----------------------------------
-- > Borders
-- -----------------------------------

-- Create Target Border
-- function lum:CreateTargetBorder(self)
--   self.TargetBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
--   api:CreateBorder(self, self.TargetBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")
--   self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)
--   self:RegisterEvent("RAID_ROSTER_UPDATE", ChangedTarget)
-- end

-- Create Party / Raid health warning status border
function lum:CreateHealthBorder(self)
  self.HPborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  api:CreateBorder(self, self.HPborder, 1, 4)
  self.HPborder:SetBackdropBorderColor(180 / 255, 255 / 255, 0 / 255, 1)
end

local function UpdateThreat(self, event, unit)
  if (self.unit ~= unit) then
    return
  end

  local status = UnitThreatSituation(unit)
  unit = unit or self.unit

  if status and status > 1 then
    local r, g, b = GetThreatStatusColor(status)
    self.ThreatBorder:Show()
    self.ThreatBorder:SetBackdropBorderColor(r, g, b, 1)
  else
    self.ThreatBorder:SetBackdropBorderColor(r, g, b, 0)
    self.ThreatBorder:Hide()
  end
end

-- Create Party / Raid Threat Status Border
function lum:CreateThreatBorder(self)
  self.ThreatBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  api:CreateBorder(self, self.ThreatBorder, 1, 3)
  self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

-- Create Glow Border
function lum:SetGlowBorder(self)
  local glow = CreateFrame("Frame", nil, self, "BackdropTemplate")
  glow:SetFrameLevel(0)
  glow:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
  glow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
  glow:SetBackdrop(
    {
      bgFile = m.textures.white_square,
      edgeFile = m.textures.glow_texture,
      tile = false,
      tileSize = 16,
      edgeSize = 4,
      insets = {left = -4, right = -4, top = -4, bottom = -4}
    }
  )
  glow:SetBackdropColor(0, 0, 0, 0)
  glow:SetBackdropBorderColor(0, 0, 0, 1)

  self.Glowborder = glow
end

-- -----------------------------------
-- > Class Power
-- -----------------------------------

-- Colorize the last power color element
local function SetMaxClassPowerColor(element, max, powerType)
  if not element or not max then
    return
  end

  local LastBar = element[max]
  local color = element.__owner.colors.power.max[powerType]

  if LastBar and color then
    local r, g, b = color[1], color[2], color[3]
    LastBar:SetStatusBarColor(r, g, b)

    local bg = LastBar.bg
    if (bg) then
      local mu = bg.multiplier or 1
      bg:SetColorTexture(r * mu, g * mu, b * mu)
    end
  end
end

-- Post Update ClassPower
local function PostUpdateClassPower(element, cur, max, diff, powerType)
  if (diff) then
    local maxWidth, gap = cfg.frames.main.width, 6

    for i = 1, max do
      local Bar = element[i]
      Bar:SetWidth(((maxWidth / max) - (((max - 1) * gap) / max)))

      if (i > 1) then
        Bar:ClearAllPoints()
        Bar:SetPoint("LEFT", element[i - 1], "RIGHT", gap, 0)
      end
    end
  end

  SetMaxClassPowerColor(element, max, powerType)
end

-- Create Class Power Bars (Combo Points...)
local function CreateClassPower(self)
  local ClassPower = {}

  for i = 1, 10 do
    local Bar = CreateFrame("StatusBar", "oUF_LumenClassPower", self, "BackdropTemplate")
    Bar:SetHeight(cfg.frames.main.classPower.height)
    Bar:SetStatusBarTexture(m.textures.status_texture)
    api:SetBackdrop(Bar, 1.5, 1.5, 1.5, 1.5)

    if (i > 1) then
      Bar:SetPoint("LEFT", ClassPower[i - 1], "RIGHT", 6, 0)
    else
      Bar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
    end

    if (i > 5) then
      Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
    end

    local Background = Bar:CreateTexture(nil, "BORDER")
    Background:SetAllPoints()
    Background:SetTexture(m.textures.bg_texture)
    Background.multiplier = 0.2
    Bar.bg = Background

    ClassPower[i] = Bar
  end

  ClassPower.PostUpdate = PostUpdateClassPower
  self.ClassPower = ClassPower
end

-- Death Knight Runebar
local function CreateRuneBar(self)
  local Runes = {}
  Runes.sortOrder = "asc"
  Runes.colorSpec = true

  for i = 1, 6 do
    local Rune = CreateFrame("StatusBar", nil, self)
    local numRunes, maxWidth, gap = 6, cfg.frames.main.width, 6
    local width = ((maxWidth / numRunes) - (((numRunes - 1) * gap) / numRunes))

    Rune:SetSize(width, 2)
    Rune:SetStatusBarTexture(m.textures.status_texture)
    api:SetBackdrop(Rune, 2, 2, 2, 2)

    if (i == 1) then
      Rune:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
    else
      Rune:SetPoint("LEFT", Runes[i - 1], "RIGHT", gap, 0)
    end

    local Background = Rune:CreateTexture(nil, "BORDER")
    Background:SetAllPoints()
    Background:SetTexture(m.textures.bg_texture)
    Background.multiplier = 0.2
    Rune.bg = Background

    Runes[i] = Rune
  end

  self.Runes = Runes
end

-- Class Power (Combo Points, Runes, etc...)
function lum:CreateClassPower(self)
  if G.playerClass == "DEATHKNIGHT" then
    CreateRuneBar(self)
  else
    CreateClassPower(self)
  end
end

-- -----------------------------------
-- > Heal Prediction
-- -----------------------------------

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
  bg:SetVertexColor(r * 0.25, g * 0.25, b * 0.25)

  -- Value
  local PowerValue = api:CreateFontstring(AdditionalPower, font, cfg.fontsize - 4, "THINOUTLINE")
  PowerValue:SetPoint("RIGHT", AdditionalPower, -8, 0)
  PowerValue:SetJustifyH("RIGHT")
  self:Tag(PowerValue, "[lum:altpower]")

  -- Backdrop
  api:SetBackdrop(AdditionalPower, 1, 1, 1, 1)

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
        core:ShortNumber(cur),
        core:ShortNumber(max),
        core:NumberToPerc(cur, max)
      )
    elseif cur > 0 then
      self.Text:SetFormattedText("%s", core:ShortNumber(cur))
    else
      self.Text:SetText(nil)
    end
  else
    if self.isMouseOver then
      self.Text:SetFormattedText("%s", core:ShortNumber(cur))
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
    api:SetBackdrop(AlternativePower, 2, 2, 2, 2)
    AlternativePower:SetHeight(16)
    AlternativePower:SetWidth(200)
    AlternativePower:SetPoint("CENTER", "UIParent", "CENTER", 0, 350)

    AlternativePower.Text = api:CreateFontstring(AlternativePower, font, 10, "THINOUTLINE")
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

function lum:CreatePlayerIconIndicators(self)
  -- Combat indicator
  local Combat = api:CreateFontstring(self, m.fonts.symbols, 18, "THINOUTLINE")
  Combat:SetPoint("RIGHT", self, "LEFT", -10, 0)
  Combat:SetText("")
  Combat:SetTextColor(255 / 255, 26 / 255, 48 / 255, 0.9)
  self.CombatIndicator = Combat

  -- Resting
  if not api:IsPlayerMaxLevel() then
    local Resting = api:CreateFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE")
    Resting:SetPoint("CENTER", self.Health, "TOP", 0, 1)
    Resting:SetText("zZz")
    Resting:SetTextColor(255 / 255, 255 / 255, 255 / 255, 0.80)
    self.RestingIndicator = Resting
  end
end

function lum:CreateTargetIconIndicators(self)
  -- Quest Icon
  local QuestIcon = api:CreateFontstring(self.Health, m.fonts.symbols, 18, "THINOUTLINE")
  QuestIcon:SetPoint("LEFT", self.Health, "RIGHT", 8, 0)
  QuestIcon:SetText("")
  QuestIcon:SetTextColor(238 / 255, 217 / 255, 43 / 255)
  self.QuestIndicator = QuestIcon

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, "OVERLAY")
  RaidIcon:SetPoint("LEFT", self, "RIGHT", 8, 0)
  RaidIcon:SetSize(20, 20)
  self.RaidTargetIndicator = RaidIcon
end

-- ------------------------------------------
-- > Party / Raid
-- ------------------------------------------

-- Group Role Indicator
local function UpdateRoleIcon(self, event)
  local lfdrole = self.GroupRoleIndicator

  local role = UnitGroupRolesAssigned(self.unit)
  -- Show roles when testing
  if role == "NONE" and cfg.units.party.forceRole then
    local rnd = random(1, 3)
    role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
  end

  if UnitIsConnected(self.unit) and role ~= "NONE" then
    lfdrole:SetTexture(cfg.roleIconTextures[role])
    lfdrole:SetVertexColor(unpack(cfg.roleIconColor[role]))
  else
    lfdrole:Hide()
  end
end

function lum:CreateGroupRoleIndicator(self)
  local roleIcon = self.Health:CreateTexture(nil, "OVERLAY")
  roleIcon:SetPoint("LEFT", self, 8, 0)
  roleIcon:SetSize(16, 16)
  roleIcon.Override = UpdateRoleIcon
  self:RegisterEvent("UNIT_CONNECTION", UpdateRoleIcon)
  return roleIcon
end

-- ------------------------------------------
-- > Strings
-- ------------------------------------------

-- Name
function lum:CreateNameString(self, font, size, outline, x, y, point, width)
  self.Name = api:CreateFontstring(self.Health, font, size, outline)
  self.Name:SetPoint(point, self.Health, x, y)
  self.Name:SetJustifyH(point)
  self.Name:SetWidth(width)
  self.Name:SetHeight(size)
  self:Tag(self.Name, "[lum:level] [lum:name]")
end

-- Party Name
function lum:CreatePartyNameString(self, font, size)
  self.Name = api:CreateFontstring(self.Health, font, size, "THINOUTLINE")
  self.Name:SetPoint("TOPRIGHT", self, "TOPRIGHT", -4, -5)
  self.Name:SetJustifyH("RIGHT")
  self:Tag(self.Name, "[lum:playerstatus] [lum:leader] [lum:name]")
end

-- Health Value
function lum:CreateHealthValueString(self, font, size, outline, x, y, point)
  self.Health.value = api:CreateFontstring(self.Health, font, size, outline)
  self.Health.value:SetPoint(point, self.Health, x, y)
  self.Health.value:SetJustifyH(point)
  self.Health.value:SetTextColor(1, 1, 1)
  self:Tag(self.Health.value, "[lum:hpvalue]")
end

-- Health Percent
function lum:CreateHealthPercentString(self, font, size, outline, x, y, point, layer)
  self.Health.percent = api:CreateFontstring(self.Health, font, size, outline, layer)
  self.Health.percent:SetPoint(point, self.Health.value, x, y)
  self.Health.percent:SetJustifyH("RIGHT")
  self.Health.percent:SetTextColor(0.5, 0.5, 0.5, 0.5)
  self.Health.percent:SetShadowColor(0, 0, 0, 0)
  self:Tag(self.Health.percent, "[lum:hpperc]")
end

-- Power Value
function lum:CreatePowerValueString(self, font, size, outline, x, y, point)
  self.Power.value = api:CreateFontstring(self.Power, font, size, outline)
  self.Power.value:SetPoint(point, self.Power, x, y)
  self.Power.value:SetJustifyH(point)
  self:Tag(self.Power.value, "[lum:powervalue]")
end

-- Classification
function lum:CreateClassificationString(self, font, size)
  local clf = api:CreateFontstring(self, font, size, "THINOUTLINE")
  clf:SetPoint("LEFT", self, "TOPLEFT", 0, 12)
  clf:SetTextColor(1, 1, 1, 1)
  self:Tag(clf, "[lum:classification]")
end

-- ------------------------------------------
-- > Addons (Experience, Reputation, etc.)
-- ------------------------------------------

-- oUF_Experience Tooltip
local function UpdateExperienceTooltip(self)
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local isHonor = IsWatchingHonorAsXP()
  local cur = (isHonor and UnitHonor or UnitXP)("player")
  local max = (isHonor and UnitHonorMax or UnitXPMax)("player")
  local per = math.floor(cur / max * 100 + 0.5)
  local bars = cur / max * (isHonor and 5 or 20)

  local rested = (isHonor and GetHonorExhaustion or GetXPExhaustion)() or 0
  rested = math.floor(rested / max * 100 + 0.5)

  if isHonor then
    GameTooltip:SetText(string.format("Honor Rank %s", UnitHonorLevel("player")))
    GameTooltip:AddLine(string.format("|cffff4444%s / %s Points|r", BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max)))
    GameTooltip:AddLine(string.format("|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r", bars, rested))
    GameTooltip:Show()
  else
    GameTooltip:SetText(string.format("%s / %s (%s%%)", BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max), per))
    GameTooltip:AddLine(string.format("|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r", bars, rested))
    GameTooltip:Show()
  end
end

-- Color the Experience Bar
local function ExperiencePostUpdate(self)
  -- Showing Honor
  if IsWatchingHonorAsXP() then
    self:SetStatusBarColor(255 / 255, 75 / 255, 75 / 255)
    self.Rested:SetStatusBarColor(255 / 255, 205 / 255, 90 / 255)
  else -- Experience
    self:SetStatusBarColor(0 / 255, 100 / 225, 255 / 255)
    self.Rested:SetStatusBarColor(0 / 255, 100 / 225, 255 / 255, 0.35)
  end
end

-- oUF_Reputation Tooltip
local function UpdateReputationTooltip(self)
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
  local isParagon = C_Reputation.IsFactionParagon(factionID)
  local color = FACTION_BAR_COLORS[standing]

  if name and isParagon then
    local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)

    if currentValue and threshold then
      min, max = 0, threshold
      value = currentValue % threshold
      if hasRewardPending then
        value = value + threshold
      end
    end

    GameTooltip:AddLine(format("|cff%02x%02x%02x%s|r", 0, 100, 255, name))
    GameTooltip:AddLine(
      format("|cffcecece%s:|r |cffb7b7b7%d / %d|r", _G["FACTION_STANDING_LABEL" .. standing], value, max - min)
    )
    GameTooltip:Show()
  else
    if name and color then
      GameTooltip:AddLine(format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name))
      GameTooltip:AddLine(
        format("|cffcecece%s:|r |cffb7b7b7%d / %d|r", _G["FACTION_STANDING_LABEL" .. standing], value - min, max - min)
      )
      GameTooltip:Show()
    end
  end
end

-- oUF_Experience
function lum:CreateExperienceBar(self)
  if cfg.elements.experiencebar.show then
    local Experience = CreateFrame("StatusBar", nil, self)
    Experience:SetStatusBarTexture(m.textures.status_texture)
    Experience:SetPoint(
      cfg.elements.experiencebar.pos.a1,
      cfg.elements.experiencebar.pos.af,
      cfg.elements.experiencebar.pos.a2,
      cfg.elements.experiencebar.pos.x,
      cfg.elements.experiencebar.pos.y
    )
    Experience:SetHeight(cfg.elements.experiencebar.height)
    Experience:SetWidth(cfg.elements.experiencebar.width)

    local Rested = CreateFrame("StatusBar", nil, Experience)
    Rested:SetStatusBarTexture(m.textures.status_texture)
    Rested:SetAllPoints(Experience)
    api:SetBackdrop(Rested, 2, 2, 2, 2)

    local ExperienceBG = Rested:CreateTexture(nil, "BORDER")
    ExperienceBG:SetAllPoints()
    ExperienceBG:SetAlpha(0.3)
    ExperienceBG:SetTexture(m.textures.bg_texture)
    ExperienceBG:SetColorTexture(0.2, 0.2, 0.2)

    Experience:EnableMouse(true)
    Experience.UpdateTooltip = UpdateExperienceTooltip
    Experience.PostUpdate = ExperiencePostUpdate

    self.Experience = Experience
    self.Experience.Rested = Rested
  end
end

-- oUF_Reputation
function lum:CreateReputationBar(self)
  if cfg.elements.experiencebar.show then
    local Reputation = CreateFrame("StatusBar", nil, self)
    Reputation:SetStatusBarTexture(m.textures.status_texture)
    Reputation:SetPoint(
      cfg.elements.experiencebar.pos.a1,
      cfg.elements.experiencebar.pos.af,
      cfg.elements.experiencebar.pos.a2,
      cfg.elements.experiencebar.pos.x,
      cfg.elements.experiencebar.pos.y
    )
    Reputation:SetHeight(cfg.elements.experiencebar.height)
    Reputation:SetWidth(cfg.elements.experiencebar.width)
    api:SetBackdrop(Reputation, 2, 2, 2, 2)
    Reputation.colorStanding = true

    local ReputationBG = Reputation:CreateTexture(nil, "BORDER")
    ReputationBG:SetAllPoints()
    ReputationBG:SetAlpha(0.3)
    ReputationBG:SetTexture(m.textures.bg_texture)
    ReputationBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

    Reputation:EnableMouse(true)
    Reputation.UpdateTooltip = UpdateReputationTooltip

    self.Reputation = Reputation
  end
end

-- oUF_ArtifactPower
function lum:CreateArtifactPowerBar(self)
  if cfg.elements.artifactpowerbar.show then
    local ArtifactPower = CreateFrame("StatusBar", nil, self)
    ArtifactPower:SetStatusBarTexture(m.textures.status_texture)
    ArtifactPower:SetStatusBarColor(217 / 255, 205 / 255, 145 / 255)
    ArtifactPower:SetPoint(
      cfg.elements.artifactpowerbar.pos.a1,
      cfg.elements.artifactpowerbar.pos.af,
      cfg.elements.artifactpowerbar.pos.a2,
      cfg.elements.artifactpowerbar.pos.x,
      cfg.elements.artifactpowerbar.pos.y
    )
    ArtifactPower:SetHeight(cfg.elements.artifactpowerbar.height)
    ArtifactPower:SetWidth(cfg.elements.artifactpowerbar.width)
    api:SetBackdrop(ArtifactPower, 2, 2, 2, 2)
    ArtifactPower:EnableMouse(true)
    self.ArtifactPower = ArtifactPower

    local ArtifactPowerBG = ArtifactPower:CreateTexture(nil, "BORDER")
    ArtifactPowerBG:SetAllPoints()
    ArtifactPowerBG:SetAlpha(0.3)
    ArtifactPowerBG:SetTexture(m.textures.bg_texture)
    ArtifactPowerBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)
  end
end
