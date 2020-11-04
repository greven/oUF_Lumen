local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local font = m.fonts.font

local frame = "targettarget"

-- ------------------------------------------------------------------------
-- > TARGET OF TARGET UNIT SPECIFIC FUNCTiONS
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

local function CreateTargetTarget(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "secondary")

  -- Texts
  lum:CreateNameString(self, font, cfg.fontsize - 2, "THINOUTLINE", 3, 0, "LEFT", self.cfg.width - 4)
  self:Tag(self.Name, "[lum:name]")

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  lum:CreateHealPrediction(self)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), CreateTargetTarget)
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
