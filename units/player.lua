local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "player"

-- -----------------------------------
-- > Player Style
-- -----------------------------------

local function CreatePlayer(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "main")

  -- Text strings
  lum:CreateNameString(self, font, cfg.fontsize, "THINOUTLINE", 4, -0.5, "LEFT", self.cfg.width - 56)
  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, -0.5, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, -0.5, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 3, "THINOUTLINE", 0, 0, "CENTER")

  -- lum:CreatePowerBar(self, "main")
  lum:CreateCastbar(self)
  lum:CreateAdditionalPower(self)
  lum:CreatePowerPrediction(self)
  lum:CreateAlternativePower(self)
  lum:CreateHealPrediction(self)
  lum:CreatePlayerIconIndicators(self)
  lum:MirrorBars()

  -- Addons
  lum:CreateExperienceBar(self)
  lum:CreateReputationBar(self)
  lum:CreateArtifactPowerBar(self)

  -- Auras
  lum:SetDebuffAuras(self, frame, 12, 12, cfg.frames.main.height + 4, 4, "BOTTOMRIGHT", self, "BOTTOMLEFT", -56, -2, "BOTTOMRIGHT", nil, "UP", true)

  lum:SetBarTimerAuras(self, frame, 12, 12, 24, 2, "BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16, "BOTTOMLEFT", "UP")
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), CreatePlayer)
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
