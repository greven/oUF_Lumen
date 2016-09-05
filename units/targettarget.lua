local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "targettarget"

-- ------------------------------------------------------------------------
-- > TARGET OF TARGET UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local self = health.__owner
  
  if cfg.units[frame].health.gradientColored then
    local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, unpack(core:raidColor(unit)))
    health:SetStatusBarColor(r, g, b)
  end

  -- Class colored text
  if cfg.units[frame].health.classColoredText then
    self.Name:SetTextColor(unpack(core:raidColor(unit)))
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self, "secondary")

  -- Texts
  core:createNameString(self, font_big, cfg.fontsize, "THINOUTLINE", 2, 0, "LEFT", self.cfg.width - 4)
  self:Tag(self.Name, '[lumen:name]')
  -- core:createHPString(self, font, cfg.fontsize - 4, "THINOUTLINE", -4, 0, "RIGHT")
  -- self:Tag(self.Health.value, '[lumen:hpperc]')

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Heal Prediction
  CreateHealPrediction(self)

end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper))
  oUF:Spawn(frame, "oUF_Lumen"..frame:gsub("^%l", string.upper))
end
