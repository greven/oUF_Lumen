local _, ns = ...

local core, cfg, oUF = ns.core, ns.cfg, ns.oUF

local font = core.media.font
local font_big = core.media.font_big

-- ------------------------------------------------------------------------
-- > TARGET UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)

end

-- Post Power Update
local PostUpdatePower = function(power, unit, min, max)

end

-- frame bootstrap
local setupUnitFrame = function(self)
  self:SetFrameStrata("BACKGROUND")

  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)

  self.Health:SetHeight(self.cfg.height - cfg.frames.main.health.margin - self.cfg.power.height)
  self.Health:SetWidth(self.cfg.width)
  self.Health.frequentUpdates = self.cfg.health.frequentUpdates

  self.Power:SetHeight(cfg.frames.main.power.height)
  self.Power:SetWidth(self.cfg.width)
  self.Power.frequentUpdates = self.cfg.power.frequentUpdates

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth
  self.Power.PostUpdate = PostUpdatePower
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = "target"
  self.cfg = cfg.units.target

  core:globalStyle(self)
  setupUnitFrame(self)

  -- Texts
  core:createNameString(self, font_big, cfg.fontsize, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 52)
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units.target.show then
  oUF:RegisterStyle("lumen:target", createStyle)
  oUF:SetActiveStyle("lumen:target")
  oUF:Spawn("target", "oUF_LumenTarget")
end
