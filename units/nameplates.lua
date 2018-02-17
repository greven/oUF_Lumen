local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local _G = _G

local font = m.fonts.font
local font_big = m.fonts.font_big

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
  nameplateMinScale = 1,
  nameplateSelectedScale = 1,
  nameplateSelfScale = 1,
}

-- -----------------------------------
-- > NAMEPLATES STYLE
-- -----------------------------------

local createStyle = function(self, unit)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  if not unit:match("nameplate") then
    return
  end

  self:SetScale(cfg.scale)
  core:setBackdrop(self, 2, 2, 2, 2)
  core:createDropShadow(self, 4, 4, {0, 0, 0, cfg.frames.shadow.opacity})

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

  health.bg = health:CreateTexture(nil, "BACKGROUND")
  health.bg:SetAllPoints(health)
  health.bg:SetAlpha(0.20)
  health.bg:SetTexture(m.textures.bg_texture)
  self.Health = health

  -- Name strings
  core:createNameString(self, font_big, cfg.fontsize - 2, "THINOUTLINE", 0, 4, "CENTER", self.cfg.width - 8)
  self:Tag(self.Name, '[lumen:name]')

  -- Level
  self.Level = core:createFontstring(self.Health, font_big, cfg.fontsize - 2, "THINOUTLINE")
  self.Level:SetPoint("TOPRIGHT", self.Health, -18, 0)
  self.Level:SetJustifyH("LEFT")
  self.Level:SetWidth(self.cfg.width)
  self.Level:SetHeight(self.cfg.height)
  self:Tag(self.Level, '[lumen:levelplus]')

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, 'OVERLAY')
  RaidIcon:SetPoint('LEFT', self, 'RIGHT', 8, 0)
  RaidIcon:SetSize(16, 16)
  self.RaidTargetIndicator = RaidIcon

  -- Castbar
  if self.cfg.castbar.enable then
    local castbar = CreateFrame("StatusBar", nil, self)
    castbar:SetStatusBarTexture(m.textures.status_texture)
    castbar:GetStatusBarTexture():SetHorizTile(false)

    castbar.bg = castbar:CreateTexture(nil, 'BORDER')
    castbar.bg:SetAllPoints()
    castbar.bg:SetAlpha(0.3)
    castbar.bg:SetTexture(m.textures.bg_texture)
    castbar.bg:SetColorTexture(1/3, 1/3, 1/3)

    core:setBackdrop(castbar, 2, 2, 2, 2)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
    castbar:SetWidth(cfg.units.nameplate.width)
    castbar:SetHeight(cfg.units.nameplate.castbar.height)
    castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)

    castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
    castbar.Text:SetTextColor(2/3, 2/3, 2/3)
    castbar.Text:SetShadowOffset(1, -1)
    castbar.Text:SetJustifyH("CENTER")
    castbar.Text:SetHeight(12)
    castbar.Text:SetFont(font_big, cfg.fontsize - 5, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.nameplate.width - 4)
    castbar.Text:SetPoint("CENTER", castbar, 0, -10)

    self.Castbar = castbar
  end

  -- Size and position
  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint("CENTER", 0, 0)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper))
  oUF:SpawnNamePlates("oUF_Lumen"..frame:gsub("^%l", string.upper), nil, cvars)
end