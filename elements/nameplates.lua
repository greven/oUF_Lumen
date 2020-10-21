local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local _G = _G
local UnitIsPlayer, UnitIsUnit = UnitIsPlayer, UnitIsUnit

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
  nameplateMinAlpha = 0.5,
  nameplateMinAlphaDistance = 10,
  nameplateMaxAlpha = 1,
  nameplateMaxAlphaDistance = 10,
  nameplateMaxDistance = 60,
  nameplateResourceOnTarget = 0,
  nameplateShowSelf = 0
}

local OnTargetChanged = function(self)
  if not self then
    return
  end

  local unit = self.unit

  -- New target
  if UnitIsUnit(unit, "target") then
    -- Target Border
    self.TargetBorder:SetBackdropBorderColor(.8, .8, .8, 1)
    self.TargetBorder:Show()

    -- Target Arrow
    if cfg.units.nameplate.showTargetArrow then
      self.arrow:Show()
    end

    -- Highlight
    if cfg.units.nameplate.showHighlight then
      self.Highlight:Show()
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
    self.TargetBorder:Hide()
    if cfg.units.nameplate.showTargetArrow then
      self.arrow:Hide()
    end

    if cfg.units.nameplate.showHighlight then
      self.Highlight:Hide()
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

local function AddTargetIndicators(self)
  local selectedColor = self.cfg.selectedColor
  local glowColor = self.cfg.glowColor

  -- Target Border
  self.TargetBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  core:createBorder(self, self.TargetBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")

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

  -- Highlight
  if self.cfg.showHighlight then
    self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
    self.Highlight:SetAllPoints(self)
    self.Highlight:SetTexture(m.textures.white_square)
    self.Highlight:SetVertexColor(1, 1, 1, 0.1)
    self.Highlight:SetBlendMode("ADD")
    self.Highlight:Hide()
  end

  self:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetChanged, true)
end

-- Castbar Check for Spell Interrupt
local CheckForSpellInterrupt = function(self, unit)
  local initialColor = cfg.units.nameplate.castbar.color

  if unit == "vehicle" then
    unit = "player"
  end
  if (self.notInterruptible and UnitCanAttack("player", unit)) then
    self:SetStatusBarColor(0.2, 0.2, 0.2)
  else
    self:SetStatusBarColor(unpack(initialColor))
  end
end

-- Castbar PostCastStart
local myPostCastStart = function(self, unit, name, castID, spellID)
  CheckForSpellInterrupt(self, unit)
  self.Castbar.Icon.border:Show()
end

-- Castbar PostCastStop
local myPostCastStop = function(self, unit, name, castID, spellID)
  self.Castbar.Icon.border:Hide()
end

-- Castbar PostCastFailed
local myPostCastFailed = function(self, unit, spellname, castID, spellID)
  self.Castbar.Icon.border:Hide()
end

-- Castbar PostCastChannel Update
local myPostChannelStart = function(self, unit, name, castID, spellID)
  CheckForSpellInterrupt(self, unit)
  self.Castbar.Icon.border:Show()
end

-- Castbar PostCastChannelStop
local myPostChannelStop = function(self, unit, name, castID, spellID)
  self.Castbar.Icon.border:Hide()
end

local function CreateCastbar(self)
  local Castbar = CreateFrame("StatusBar", nil, self)
  Castbar:SetStatusBarTexture(m.textures.status_texture)
  Castbar:GetStatusBarTexture():SetHorizTile(false)

  core:setBackdrop(Castbar, 1, 1, 1, 1)
  Castbar:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
  Castbar:SetWidth(cfg.units.nameplate.width)
  Castbar:SetHeight(cfg.units.nameplate.castbar.height)
  Castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)

  local Background = Castbar:CreateTexture(nil, "BORDER")
  Background:SetAllPoints(Castbar)
  Background:SetTexture(m.textures.bg_texture)
  -- Background:SetColorTexture(0.2, 0.2, 0.2)
  -- Background:SetColorTexture(1, 0, 0)
  Background:SetAlpha(1)

  local Text = Castbar:CreateFontString(nil, "OVERLAY")
  Text:SetTextColor(4 / 5, 4 / 5, 4 / 5)
  Text:SetShadowOffset(1, -1)
  Text:SetJustifyH("CENTER")
  Text:SetHeight(12)
  Text:SetFont(font, cfg.fontsize - 5, "THINOUTLINE")
  Text:SetWidth(cfg.units.nameplate.width - 4)
  Text:SetPoint("CENTER", Castbar, 0, -10)

  local Icon = Castbar:CreateTexture(nil, "ARTWORK")
  Icon:SetTexCoord(.08, .92, .08, .92)
  Icon:SetHeight(self.cfg.height + cfg.units.nameplate.castbar.height + 4)
  Icon:SetWidth(self.cfg.height + cfg.units.nameplate.castbar.height + 4)
  Icon:SetPoint("TOPLEFT", self, "TOPRIGHT", 6, 0)

  local iconborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  core:createBorder(Icon, iconborder, 2, 3, "Interface\\ChatFrame\\ChatFrameBackground")
  iconborder:SetBackdropColor(0, 0, 0, 1)
  iconborder:SetBackdropBorderColor(0, 0, 0, 1)
  Icon.border = iconborder

  local CheckForSpellInterrupt = function(self, unit)
    local initialColor = cfg.units.nameplate.castbar.color

    if unit == "vehicle" then
      unit = "player"
    end

    if (self.notInterruptible and UnitCanAttack("player", unit)) then
      self:SetStatusBarColor(0.3, 0.3, 0.3)
    else
      self:SetStatusBarColor(unpack(initialColor))
    end
  end

  local onPostCastStart = function(self, unit)
    -- Set the castbar unit's initial color
    self:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
    CheckForSpellInterrupt(self, unit)
  end

  local OnPostCastFail = function(self, unit)
    -- Color castbar red when cast fails
    self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255)

    if self.Max then
      self.Max:Hide()
    end
  end

  local OnPostCastInterruptible = function(self, unit)
    CheckForSpellInterrupt(self, unit)
  end

  Castbar.PostCastStart = onPostCastStart
  Castbar.PostCastFail = OnPostCastFail
  Castbar.PostCastInterruptible = OnPostCastInterruptible

  Castbar.timeToHold = cfg.elements.castbar.timeToHold

  Castbar.bg = Background
  Castbar.Text = Text
  Castbar.Time = Time
  Castbar.Icon = Icon
  self.Castbar = Castbar
end

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

  button.icon:SetTexCoord(.08, .92, .08, .92)

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

local PostUpdatePlates = function(self, event, unit)
  if not self then
    return
  end

  if event == "NAME_PLATE_UNIT_ADDED" then
    self.isPlayer = UnitIsPlayer(unit)
  end

  if event == "NAME_PLATE_UNIT_ADDED" or event == "PLAYER_TARGET_CHANGED" then
    self.isPlayer = UnitIsPlayer(unit)

    self.Castbar.Icon.border:Hide()
    OnTargetChanged(self)
  end

  if not self.isPlayer then
    core:createNameString(self, font, cfg.fontsize - 5, "THINOUTLINE", 0, 5, "CENTER", self.cfg.width - 4)
    self:Tag(self.Name, "[lum:levelplus] [lum:name]")
  end
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

  -- Size and position
  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint("CENTER", 0, -10)
  core:createDropShadow(self, 4, 4, {0, 0, 0, cfg.frames.shadow.opacity})

  -- Health bar
  local health = CreateFrame("StatusBar", nil, self)
  health:SetAllPoints()
  health:SetStatusBarTexture(m.textures.status_texture)
  health:GetStatusBarTexture():SetHorizTile(false)
  health.colorHealth = true
  health.colorReaction = true
  health.colorClass = false
  health.colorTapping = true
  health.colorDisconnected = true
  health.frequentUpdates = true
  health.PostUpdate = PostUpdateHealth

  health.bg = health:CreateTexture(nil, "BACKGROUND")
  health.bg:SetAllPoints(health)
  health.bg:SetAlpha(0.20)
  health.bg:SetTexture(m.textures.bg_texture)

  core:setBackdrop(health, 2, 2, 2, 2)

  self.Health = health

  -- Health Percentage
  health.percent = core:createFontstring(self.Health, font, cfg.fontsize - 3, "THINOUTLINE", "BACKGROUND")
  health.percent:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
  health.percent:SetJustifyH("LEFT")
  health.percent:SetWidth(self.cfg.width)
  health.percent:SetTextColor(0.8, 0.8, 0.8, 1)
  self:Tag(health.percent, "[lum:hpperc]")

  -- -- Power Bar
  -- local power = CreateFrame("StatusBar", nil, self)
  -- power:SetHeight(self.cfg.power.height)
  -- power:SetWidth(self.cfg.width)
  -- power:SetStatusBarTexture(m.textures.status_texture)
  -- power:GetStatusBarTexture():SetHorizTile(false)
  -- power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.frames.main.health.margin)
  -- power.colorPower = true

  -- power.bg = self:CreateTexture(nil, "BACKGROUND")
  -- power.bg:SetAllPoints(power)
  -- power.bg:SetTexture(m.textures.bg_texture)
  -- power.bg:SetAlpha(0.2)

  -- core:setBackdrop(power, 2, 2, 2, 2)

  -- self.Power = power

  -- Class Power (Combo Points, Insanity, etc...)
  if cfg.units.nameplate.classpower then
    classPower = core:createFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE", "BACKGROUND")
    classPower:SetPoint("RIGHT", self.Health, "LEFT", -4, 0)
    classPower:SetJustifyH("RIGHT")
    classPower:SetWidth(self.cfg.width)
    self:Tag(classPower, "[lum:classpower]", "player")
    classPower:Hide()
    self.classPower = classPower
  end

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, "OVERLAY")
  RaidIcon:SetPoint("CENTER", self, "CENTER", 0, 50)
  RaidIcon:SetSize(24, 24)
  self.RaidTargetIndicator = RaidIcon

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

  AddTargetIndicators(self)

  -- Castbar
  if self.cfg.castbar.enable then
    CreateCastbar(self)
  end
end

-- Hide default mana bars spawning
hooksecurefunc(
  _G.ClassNameplateManaBarFrame,
  "Show",
  function(self)
    self:Hide()
  end
)
hooksecurefunc(
  _G.DeathKnightResourceOverlayFrame,
  "Show",
  function(self)
    self:Hide()
  end
)

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper))
  oUF:SpawnNamePlates("oUF_Lumen" .. frame:gsub("^%l", string.upper), PostUpdatePlates, cvars)
end
