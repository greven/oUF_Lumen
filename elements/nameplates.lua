local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

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
  api:CreateBorder(self, self.TargetBorder, 1, 3)

  -- Targeted Arrow
  if self.cfg.showTargetArrow then
    self.arrow = api:CreateFontstring(self, m.fonts.symbols_light, 32, "THINOUTLINE")
    self.arrow:SetPoint("CENTER", self, "CENTER", 0, 62)
    self.arrow:SetText("")
    self.arrow:SetTextColor(unpack(selectedColor))
  end

  -- Targeted Glow
  if self.cfg.showGlow then
    self.glow = self:CreateTexture(nil, "BACKGROUND", nil, -5)
    self.glow:SetSize(150, 60)
    self.glow:SetTexture("Interface\\GLUES\\Models\\UI_Draenei\\GenericGlow64")
    self.glow:SetVertexColor(0, 0.5, 1)
    self.glow:SetBlendMode("ADD")
    self.glow:SetPoint("CENTER", self, "CENTER", 0, 2)
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

local function CreateCastbar(self)
  local Castbar = CreateFrame("StatusBar", nil, self)
  Castbar:SetStatusBarTexture(m.textures.status_texture)
  Castbar:GetStatusBarTexture():SetHorizTile(false)

  api:SetBackdrop(Castbar, 1, 1, 1, 1)
  Castbar:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
  Castbar:SetWidth(cfg.units.nameplate.width)
  Castbar:SetHeight(cfg.units.nameplate.castbar.height)
  Castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)

  local Background = Castbar:CreateTexture(nil, "BORDER")
  Background:SetAllPoints(Castbar)
  Background:SetTexture(m.textures.bg_texture)
  Background:SetColorTexture(.1, .1, .1)
  Background:SetAlpha(0.3)

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
  Icon:SetHeight(16)
  Icon:SetWidth(16)
  Icon:SetPoint("TOPLEFT", self, "TOPRIGHT", 6, 0)
  Icon.border = CreateFrame("Frame", nil, Castbar, "BackdropTemplate")
  api:CreateBorder(Icon, Icon.border, 2)
  Icon.border:Show()

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
    self:SetStatusBarColor(182 / 255, 34 / 255, 32 / 255)

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
    OnTargetChanged(self)
  end

  if not self.isPlayer then
    lum:CreateNameString(self, font, cfg.fontsize - 5, "THINOUTLINE", 0, 4, "CENTER", self.cfg.width - 4)
    self:Tag(self.Name, "[lum:levelplus][lum:classificationshort] [lum:name]")
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
  api:CreateDropShadow(self, 6, 6)

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
  health.bg:SetAlpha(0.2)
  health.bg:SetTexture(m.textures.bg_texture)

  api:SetBackdrop(health, 2, 2, 2, 2, {0, 0, 0, 0.8})

  self.Health = health

  -- Health Percentage
  health.percent = api:CreateFontstring(self.Health, font, cfg.fontsize - 4, "THINOUTLINE", "BACKGROUND")
  health.percent:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
  health.percent:SetJustifyH("LEFT")
  health.percent:SetWidth(self.cfg.width)
  health.percent:SetTextColor(0.8, 0.8, 0.8, 1)
  self:Tag(health.percent, "[lum:hpperc]")

  -- Class Power (Combo Points, Insanity, etc...)
  if cfg.units.nameplate.classpower then
    classPower = api:CreateFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE", "BACKGROUND")
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
    local debuffs = lum:CreateAura(self, 6, 1, 18, 1)
    debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 8)
    debuffs.initialAnchor = "BOTTOMLEFT"
    debuffs["growth-x"] = "RIGHT"
    debuffs["growth-y"] = "UP"
    debuffs.onlyShowPlayer = true
    -- debuffs.PostUpdateIcon = PostUpdateIcon
    debuffs.PostCreateIcon = PostCreateIcon
    self.Debuffs = debuffs
  end

  AddTargetIndicators(self)

  -- Castbar
  if self.cfg.castbar.enable then
    CreateCastbar(self)
  end
end

-- Temporary fix: Hide default mana bars spawning
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
