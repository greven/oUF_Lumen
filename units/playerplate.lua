local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local font = m.fonts.font

local frame = "playerplate"
local frameName = A .. "PlayerPlate"

-- -----------------------------------

-- -----------------------------------
-- > PlayerPlate Style
-- -----------------------------------

local function CreatePlayerPlate(self, unit)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  self:EnableMouse(false)

  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)
  self:SetScale(cfg.scale)

  api:SetBackdrop(self, 1.5, 1.5, 1.5, 1.5)
  api:CreateDropShadow(self, 4, 4)

  local power = lum:CreatePowerBar(self, "nameplate")
  power:SetAllPoints(self)
  lum:CreatePowerValueString(self, font, cfg.fontsize - 2, "THINOUTLINE", 0, 0, "CENTER")

  lum:CreateClassPower(self)
  lum:CreatePowerPrediction(self)
  lum:CreateMaxPowerWarningGlow(self)
  lum:CreateSpellWatchers(self)

  -- Auras
  lum:SetBuffAuras(self, frame, 7, 1, cfg.frames.secondary.height + 4, 2, "TOPLEFT", self, "BOTTOMLEFT", 0, -8, "BOTTOMLEFT", "RIGHT", "DOWN", true)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(frameName, CreatePlayerPlate)
  oUF:SetActiveStyle(frameName)
  local f = oUF:Spawn("player", frameName)

  -- Frame Visibility
  if cfg.units[frame].visibility then
    f:Disable()
    RegisterAttributeDriver(f, "state-visibility", cfg.units[frame].visibility)
  end

  -- Fader
  if cfg.units[frame].fader then
    api:CreateFrameFader(f, cfg.units[frame].fader)
  end
end
