local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "player"

-- -----------------------------------

local function PostCreateIcon(self, button)
  local unit = self.__owner.unit

  if unit == "vehicle" then
    unit = "player"
  end

  local count = button.count
  count:ClearAllPoints()
  count:SetFont(m.fonts.font, 12, "OUTLINE")
  count:SetPoint("TOPRIGHT", button, 3, 3)

  button.icon:SetTexCoord(.08, .92, .08, .92)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self)
    self:SetVertexColor(0.1, 0.1, 0.1)
  end

  button.time = button:CreateFontString(nil, "OVERLAY")
  button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
  button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
  button.time:SetTextColor(1, 1, 0.65)
  button.time:SetShadowOffset(1, -1)
  button.time:SetShadowColor(0, 0, 0, 1)
  button.time:SetJustifyH("CENTER")

  -- For player debuffs show the spell name
  if cfg.units[unit].auras.debuffs.spellName then
    button.spell = button:CreateFontString(nil, "OVERLAY")
    button.spell:SetPoint("RIGHT", button, "LEFT", -4, 0)
    button.spell:SetFont(m.fonts.font, 16, "THINOUTLINE")
    button.spell:SetTextColor(1, 1, 1)
    button.spell:SetShadowOffset(1, -1)
    button.spell:SetShadowColor(0, 0, 0, 1)
    button.spell:SetJustifyH("RIGHT")
    button.spell:SetWordWrap(false)
  end
end

-- -----------------------------------
-- > PLAYER STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "main")

  -- Text strings
  if self.cfg.name.show then
    lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 56)
  end

  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 2, "THINOUTLINE", 0, 0, "CENTER")

  -- Power
  self.Power.frequentUpdates = self.cfg.power.frequentUpdates

  lum:CreateCastbar(self)
  lum:CreateClassPower(self)
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
  local debuffs = lum:SetDebuffAuras(self, frame, 12, 12, cfg.frames.main.height + 4, 4, "BOTTOMRIGHT", self, "BOTTOMLEFT", -56, -2, "BOTTOMRIGHT", nil, "UP", true)
  debuffs.PostCreateIcon = PostCreateIcon

  lum:SetBarTimerAuras(self, frame, 12, 12, 24, 2, "BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16, "BOTTOMLEFT", "UP")
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
