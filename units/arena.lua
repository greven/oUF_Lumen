local A, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "arena"

-- ------------------------------------------------------------------------
-- > ARENA UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local self = health.__owner

  if cfg.units[frame].health.gradientColored then
    local color = CreateColor(oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, unpack(core:raidColor(unit))))
    health:SetStatusBarColor(color:GetRGB())
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

  self:SetSize(self.cfg.width, self.cfg.height)

  -- Texts
  core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, "[lumen:level]  [lumen:name]")
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, "[lumen:hpvalue]")
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 0, "CENTER")

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
-- if cfg.units[frame].show then
--   oUF:RegisterStyle(A..frame:gsub("^%l", string.upper), createStyle)
--   oUF:SetActiveStyle(A..frame:gsub("^%l", string.upper))
--
--   for index = 1, MAX_BOSS_FRAMES or 5 do
--     local arena = oUF:Spawn(A..frame .. index, 'oUF_LumenArena' .. index)
--
--   	if(index == 1) then
--   		arena:SetPoint(cfg.units.arena.pos.a1, cfg.units.arena.pos.af, cfg.units.arena.pos.a2, cfg.units.arena.pos.x, cfg.units.arena.pos.y)
--   	else
--   		arena:SetPoint('TOP', _G['oUF_LumenArena' .. index - 1], 'BOTTOM', 0, -8)
--   	end
--   end
-- end
