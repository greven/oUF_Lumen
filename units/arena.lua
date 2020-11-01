local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local font = m.fonts.font

local frame = "arena"

-- -----------------------------------
-- > Arena Style
-- -----------------------------------

local function CreateArena(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "secondary")

  self:SetSize(self.cfg.width, self.cfg.height)

  -- Texts
  lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, "[lum:level]  [lum:name]")
  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, "[lum:hpvalue]")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 0, "CENTER")

  -- Castbar
  lum:CreateCastbar(self)

  -- Heal Prediction
  lum:CreateHealPrediction(self)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
-- if cfg.units[frame].show then
--   oUF:RegisterStyle(A..frame:gsub("^%l", string.upper), CreateArena)
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
