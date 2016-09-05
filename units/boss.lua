local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "boss"

-- ------------------------------------------------------------------------
-- > BOSS UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  if cfg.units[frame].health.gradientColored then
    local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, unpack(core:raidColor(unit)))
    health:SetStatusBarColor(r, g, b)
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
  core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, '[lumen:level]  [lumen:name]')
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, '[lumen:hpvalue]')
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Castbar
  core:CreateCastbar(self)

  -- Heal Prediction
  CreateHealPrediction(self)

end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle('oUF_Lumen:'..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle('oUF_Lumen:'..frame:gsub("^%l", string.upper))

  for index = 1, MAX_BOSS_FRAMES or 5 do
    local boss = oUF:Spawn('boss' .. index)

  	if(index == 1) then
  		boss:SetPoint(cfg.units.boss.pos.a1, cfg.units.boss.pos.af, cfg.units.boss.pos.a2, cfg.units.boss.pos.x, cfg.units.boss.pos.y)
  	else
  		boss:SetPoint('TOP', _G['oUF_LumenBoss' .. index - 1], 'BOTTOM', 0, -8)
  	end
  end
end
