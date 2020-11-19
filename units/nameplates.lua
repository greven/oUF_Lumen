local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local _G = _G

local UnitIsPlayer, UnitIsUnit = UnitIsPlayer, UnitIsUnit

local font = m.fonts.font

local frame = "nameplate"

-- -----------------------------------
-- > Nameplates Specific
-- -----------------------------------

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

local function OnTargetChanged(self)
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
      self.highlight:Show()
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
      self.highlight:Hide()
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
    self.highlight = self.Health:CreateTexture(nil, "OVERLAY")
    self.highlight:SetAllPoints(self)
    self.highlight:SetTexture(m.textures.white_square)
    self.highlight:SetVertexColor(1, 1, 1, 0.1)
    self.highlight:SetBlendMode("ADD")
    self.highlight:Hide()
  end

  self:RegisterEvent("PLAYER_TARGET_CHANGED", OnTargetChanged, true)
end

-- Post Health Update
local function PostUpdateHealth(health, unit, min, max)
  local color = CreateColor(oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, 1, 1, 1))
  health.percent:SetTextColor(color:GetRGB())
end

local function PostCreateIcon(Auras, button)
  local count = button.count
  count:ClearAllPoints()
  count:SetFont(m.fonts.font, 8, "OUTLINE")
  count:SetPoint("TOPRIGHT", button, 3, 3)

  button.icon:SetTexCoord(.08, .92, .08, .92)

  button.overlay:SetTexture(m.textures.aura_border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self)
    self:SetVertexColor(0.3, 0.3, 0.3)
  end

  button.time = button:CreateFontString(nil, "OVERLAY")
  button.time:SetFont(m.fonts.font, 9, "THINOUTLINE")
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
    self:Tag(self.Name, "[lum:levelplus] [lum:name]")
  end
end

local function CreateNameplateClassPower(self)
  if cfg.units.nameplate.classpower.show then
    classPower = api:CreateFontstring(self.Health, font, cfg.fontsize - 2, "THINOUTLINE", "BACKGROUND")
    classPower:SetPoint("RIGHT", self.Health, "LEFT", -4, 0)
    classPower:SetJustifyH("RIGHT")
    classPower:SetWidth(self.cfg.width)
    self:Tag(classPower, "[lum:classpower]", "player")
    classPower:Hide()
    self.classPower = classPower
  end
end

local function CreateRaidIcons(self)
  local RaidIcon = self:CreateTexture(nil, "OVERLAY")
  RaidIcon:SetPoint("CENTER", self, "CENTER", 0, 50)
  RaidIcon:SetSize(24, 24)
  self.RaidTargetIndicator = RaidIcon
end

-- -----------------------------------
-- > NAMEPLATES STYLE
-- -----------------------------------

local function CreateNameplate(self, unit)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  if not unit:match("nameplate") then
    return
  end

  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint(self.cfg.pos.a1, self.cfg.pos.x, self.cfg.pos.y)
  self:SetScale(cfg.scale)

  local health = lum:CreateHealthBar(self, "nameplate")
  health:SetAllPoints()
  health.percent = api:CreateFontstring(self.Health, font, cfg.fontsize - 4, "THINOUTLINE", "BACKGROUND")
  health.percent:SetPoint("LEFT", self.Health, "RIGHT", 4, 0)
  health.percent:SetJustifyH("LEFT")
  health.percent:SetWidth(self.cfg.width)
  health.percent:SetTextColor(0.8, 0.8, 0.8, 1)
  self:Tag(health.percent, "[lum:hpperc]")

  health.PostUpdate = PostUpdateHealth

  api:SetBackdrop(health, 1, 1, 1, 1, {0, 0, 0, 0.8})
  api:CreateDropShadow(health, 4, 4)

  lum:CreateCastbar(self)
  CreateNameplateClassPower(self)
  CreateRaidIcons(self)
  AddTargetIndicators(self)

  -- Auras
  local debuffs = lum:SetDebuffAuras(self, frame, 6, 1, 16, 4, "BOTTOMLEFT", self, "TOPLEFT", 0, 8, "BOTTOMLEFT", "RIGHT", "UP", true, true)
  debuffs.PostCreateIcon = PostCreateIcon
end

-- -----------------------------------
-- > SPAWN UNITs
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), CreateNameplate)
  oUF:SetActiveStyle(A .. frame:gsub("^%l", string.upper))
  oUF:SpawnNamePlates("oUF_LumenNPs", PostUpdatePlates, cvars)
end
