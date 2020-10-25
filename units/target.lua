local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "target"

-- ------------------------------------------------------------------------
-- > TARGET UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local self = health.__owner

  if cfg.units[frame].health.gradientColored then
    local color = CreateColor(oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, unpack(api:RaidColor(unit))))
    health:SetStatusBarColor(color:GetRGB())
  end

  -- Class colored text
  if cfg.units[frame].health.classColoredText then
    self.Name:SetTextColor(unpack(api:RaidColor(unit)))
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "main")

  -- Texts
  if self.cfg.name.show then
    lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 56)
  end

  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 3, "THINOUTLINE", 0, 0, "CENTER")
  lum:CreateClassificationString(self, font, cfg.fontsize - 1)

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  lum:CreateCastbar(self)
  lum:CreateHealPrediction(self)
  lum:CreateTargetIconIndicators(self)

  -- Auras
  lum:SetBuffAuras(
    self,
    frame,
    8,
    1,
    cfg.frames.secondary.height + 4,
    2,
    "TOPLEFT",
    self,
    "BOTTOMLEFT",
    0,
    2,
    "BOTTOMLEFT",
    nil,
    "RIGHT",
    true
  )

  lum:SetBarTimerAuras(
    self,
    frame,
    12,
    12,
    24,
    2,
    "BOTTOMLEFT",
    self,
    "TOPLEFT",
    -2,
    cfg.frames.secondary.height + 16,
    "BOTTOMLEFT",
    "UP"
  )
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle(A .. frame:gsub("^%l", string.upper))
  local f = oUF:Spawn(frame, A .. frame:gsub("^%l", string.upper))
  -- Frame Visibility
  if cfg.units[frame].visibility then
    f:Disable()
    RegisterStateDriver(f, "visibility", cfg.units[frame].visibility)
  end
  -- Fader
  if cfg.units[frame].fader then
    api:CreateFrameFader(f, cfg.units[frame].fader)
  end
end
