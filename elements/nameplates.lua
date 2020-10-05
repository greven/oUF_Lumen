local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local _G = _G

local font = m.fonts.font

local frame = "nameplate"

-- ------------------------------------------------------------------------
-- > NAMEPLATES SPECIFIC
-- ------------------------------------------------------------------------

local cvars = {
  nameplateGlobalScale = 1,
  NamePlateHorizontalScale = 1,
  NamePlateVerticalScale = 1,
  nameplateLargerScale = 1,
  nameplateMaxScale = 1,
  nameplateMinScale = 0.8,
  nameplateSelectedScale = 1,
  nameplateSelfScale = 1,
  -- nameplateShowAll = 0,
  nameplateMinAlpha = 0.5,
  nameplateMinAlphaDistance = 10,
  nameplateMaxAlpha = 1,
  nameplateMaxAlphaDistance = 10,
  nameplateMaxDistance = 60
}

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local color = CreateColor(oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, 1, 1, 1))
  health.percent:SetTextColor(color:GetRGB())
end

-- Post Update Aura Icon
local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

  if duration and duration > 0 then
    icon.timeLeft = expirationTime - GetTime()
  else
    icon.timeLeft = math.huge
  end

  icon:SetScript(
    "OnUpdate",
    function(self, elapsed)
      auras:AuraTimer_OnUpdate(self, elapsed)
    end
  )
end

local PostCreateIcon = function(Auras, button)
  local count = button.count
  count:ClearAllPoints()
  count:SetFont(m.fonts.font, 8, "OUTLINE")
  count:SetPoint("TOPRIGHT", button, 3, 3)

  button.icon:SetTexCoord(.07, .93, .07, .93)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self)
    self:SetVertexColor(0.3, 0.3, 0.3)
  end

  button.time = button:CreateFontString(nil, "OVERLAY")
  button.time:SetFont(m.fonts.font, 8, "THINOUTLINE")
  button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
  button.time:SetTextColor(1, 1, 0.65)
  button.time:SetShadowOffset(1, -1)
  button.time:SetShadowColor(0, 0, 0, 1)
  button.time:SetJustifyH("CENTER")
end

-- Castbar Check for Spell Interrupt
local CheckForSpellInterrupt = function(self, unit)
  local color = cfg.units.nameplate.castbar.color

  if unit == "vehicle" then
    unit = "player"
  end
  if (self.notInterruptible and UnitCanAttack("player", unit)) then
    -- self.Icon:SetDesaturated(true)
    self:SetStatusBarColor(0.3, 0.3, 0.3)
  else
    -- self.Icon:SetDesaturated(false)
    self:SetStatusBarColor(unpack(color))
  end
end

-- Castbar PostCastStart
local myPostCastStart = function(self, unit, name, castID, spellID)
  CheckForSpellInterrupt(self, unit)
  self.iconborder:Show()
end

-- Castbar PostCastStop
local myPostCastStop = function(self, unit, name, castID, spellID)
  self.iconborder:Hide()
end

-- Castbar PostCastFailed
local myPostCastFailed = function(self, unit, spellname, castID, spellID)
  self.iconborder:Hide()
end

-- Castbar PostCastChannel Update
local myPostChannelStart = function(self, unit, name, castID, spellID)
  CheckForSpellInterrupt(self, unit)
  self.iconborder:Show()
end

-- Castbar PostCastChannelStop
local myPostChannelStop = function(self, unit, name, castID, spellID)
  self.iconborder:Hide()
end

-- Target selected
local OnTargetChanged = function(self, event, unit)
  if (not self) then
    return
  end

  self.Castbar.iconborder:Hide()

  -- New target
  if UnitIsUnit(self.unit, "target") then
    -- Target Border
    self.targetBorder:SetBackdropBorderColor(.8, .8, .8, 1)
    self.targetBorder:Show()

    -- Target Arrow
    if cfg.units.nameplate.showTargetArrow then
      self.arrow:Show()
    end

    -- Glow
    if cfg.units.nameplate.showGlow then
      self.glow:Show()
    end

    -- Show Class Icons
    if self.classPower then
      self.classPower:Show()
    end
  else
    self.targetBorder:Hide()
    if cfg.units.nameplate.showTargetArrow then
      self.arrow:Hide()
    end

    if cfg.units.nameplate.showGlow then
      self.glow:Hide()
    end

    -- Hide Class Icons
    if self.classPower then
      self.classPower:Hide()
    end
  end
end

local AddTargetIndicators = function(self)
  local selectedColor = self.cfg.selectedColor
  local glowColor = self.cfg.glowColor

  -- Target Border
  self.targetBorder = CreateFrame("Frame", nil, self)
  core:createBorder(self, self.targetBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")

  -- Targeted Arrow
  if self.cfg.showTargetArrow then
    self.arrow = core:createFontstring(self, m.fonts.symbols_light, 32, "THINOUTLINE")
    self.arrow:SetPoint("CENTER", self, "CENTER", 0, 62)
    self.arrow:SetText("")
    self.arrow:SetTextColor(unpack(selectedColor))
  end

  -- Targeted Glow
  if self.cfg.showGlow then
    self.glow = CreateFrame("Frame", nil, self)
    self.glow:SetFrameLevel(0)
    self.glow:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
    self.glow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
    self.glow:SetBackdrop(
      {
        bgFile = m.textures.white_square,
        edgeFile = m.textures.glow_texture,
        tile = false,
        tileSize = 16,
        edgeSize = 4,
        insets = {left = -4, right = -4, top = -4, bottom = -4}
      }
    )
    self.glow:SetBackdropBorderColor(unpack(glowColor))
    self.glow:SetBackdropColor(0, 0, 0, 0)
  end

  self:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetChanged, true)
end

-- -----------------------------------
-- > NAMEPLATES STYLE
-- -----------------------------------

local createStyle = function(self, unit)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  if not unit:match("nameplate") then
    return
  end

  -- Health bar
  local health = CreateFrame("StatusBar", nil, self)
  health:SetAllPoints()
  health:SetStatusBarTexture(m.textures.status_texture)
  health:GetStatusBarTexture():SetHorizTile(false)
  health.colorHealth = true
  health.colorClass = true
  health.colorReaction = true
  health.colorTapping = true
  health.colorDisconnected = true
  health.frequentUpdates = true
  health.PostUpdate = PostUpdateHealth

  health.bg = health:CreateTexture(nil, "BACKGROUND")
  health.bg:SetAllPoints(health)
  health.bg:SetAlpha(0.20)
  health.bg:SetTexture(m.textures.bg_texture)
  self.Health = health

  -- Name strings
  core:createNameString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 6, "CENTER", self.cfg.width - 4)
  self:Tag(self.Name, "[lumen:name]")

  -- Health Percentage
  health.percent = core:createFontstring(self.Health, font, cfg.fontsize - 3, "THINOUTLINE", "BACKGROUND")
  health.percent:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
  health.percent:SetJustifyH("LEFT")
  health.percent:SetWidth(self.cfg.width)
  health.percent:SetTextColor(0.8, 0.8, 0.8, 1)
  self:Tag(health.percent, "[lumen:hpperc]")

  -- Classification
  local classification = core:createFontstring(self.Health, font, cfg.fontsize - 5, "THINOUTLINE", "OVERLAY")
  classification:SetPoint("CENTER", self.Health, "BOTTOM", 0, -1)
  self:Tag(classification, "[lumen:classification]")
  self.classification = classification

  -- Class Power (Combo Points, Insanity, etc...)
  if cfg.units.nameplate.classpower then
    classPower = core:createFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE", "BACKGROUND")
    classPower:SetPoint("RIGHT", self.Health, "LEFT", -4, 0)
    classPower:SetJustifyH("RIGHT")
    classPower:SetWidth(self.cfg.width)
    self:Tag(classPower, "[lumen:classpower]", "player")
    classPower:Hide()
    self.classPower = classPower
  end

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, "OVERLAY")
  RaidIcon:SetPoint("CENTER", self, "CENTER", 0, 50)
  RaidIcon:SetSize(24, 24)
  self.RaidTargetIndicator = RaidIcon

  AddTargetIndicators(self)

  -- Castbar
  if self.cfg.castbar.enable then
    local castbar = CreateFrame("StatusBar", nil, self)
    castbar:SetStatusBarTexture(m.textures.status_texture)
    castbar:GetStatusBarTexture():SetHorizTile(false)

    castbar.bg = castbar:CreateTexture(nil, "BORDER")
    castbar.bg:SetAllPoints()
    castbar.bg:SetAlpha(0.3)
    castbar.bg:SetTexture(m.textures.bg_texture)
    castbar.bg:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

    core:setBackdrop(castbar, 1, 1, 1, 1)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
    castbar:SetWidth(cfg.units.nameplate.width)
    castbar:SetHeight(cfg.units.nameplate.castbar.height)
    castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)

    -- Spell name
    castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
    castbar.Text:SetTextColor(4 / 5, 4 / 5, 4 / 5)
    castbar.Text:SetShadowOffset(1, -1)
    castbar.Text:SetJustifyH("CENTER")
    castbar.Text:SetHeight(12)
    castbar.Text:SetFont(font, cfg.fontsize - 4, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.nameplate.width - 4)
    castbar.Text:SetPoint("CENTER", castbar, 0, -10)

    -- Spell Icon
    castbar.Icon = castbar:CreateTexture(nil, "ARTWORK")
    castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    castbar.Icon:SetHeight(self.cfg.height + cfg.units.nameplate.castbar.height + 4)
    castbar.Icon:SetWidth(self.cfg.height + cfg.units.nameplate.castbar.height + 4)
    castbar.Icon:SetPoint("TOPLEFT", self, "TOPRIGHT", 6, 0)
    castbar.iconborder = CreateFrame("Frame", nil, self)
    core:createBorder(castbar.Icon, castbar.iconborder, 2, 3, "Interface\\ChatFrame\\ChatFrameBackground")
    castbar.iconborder:SetBackdropColor(0, 0, 0, 1)
    castbar.iconborder:SetBackdropBorderColor(0, 0, 0, 1)

    castbar.PostCastStart = myPostCastStart
    castbar.PostCastStop = myPostCastStop
    castbar.PostCastFailed = myPostCastFailed
    castbar.PostChannelStart = myPostChannelStart
    castbar.PostChannelStop = myPostChannelStop

    self.Castbar = castbar
  end

  -- Debuffs
  if cfg.units.nameplate.debuffs then
    local debuffs = auras:CreateAura(self, 6, 1, 18, 1)
    debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 8)
    debuffs.initialAnchor = "BOTTOMLEFT"
    debuffs["growth-x"] = "RIGHT"
    debuffs["growth-y"] = "UP"
    debuffs.onlyShowPlayer = true
    debuffs.PostUpdateIcon = PostUpdateIcon
    debuffs.PostCreateIcon = PostCreateIcon
    self.Debuffs = debuffs
  end

  -- Size and position
  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint("CENTER", 0, -10)
  self:SetScale(cfg.scale) -- self:SetScale(UIParent:GetEffectiveScale() * 1)
  core:setBackdrop(self, 2, 2, 2, 2)
  core:createDropShadow(self, 4, 4, {0, 0, 0, cfg.frames.shadow.opacity})
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper))
  oUF:SpawnNamePlates("oUF_Lumen" .. frame:gsub("^%l", string.upper), OnTargetChanged, cvars)
end
