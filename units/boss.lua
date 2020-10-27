local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "boss"

-- -----------------------------------
-- > Boss Style
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "secondary")

  self:SetSize(self.cfg.width, self.cfg.height)

  -- Texts
  lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  if self.cfg.power.text.show then
    lum:CreatePowerValueString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 0, "CENTER")
  end

  -- Auras
  lum:SetBuffAuras(
    self,
    frame,
    4,
    1,
    self.cfg.height + 4,
    2,
    "TOPRIGHT",
    self,
    "LEFT",
    -6,
    self.cfg.height - 3,
    "BOTTOMRIGHT",
    "LEFT",
    "UP",
    true
  )

  local debuffs =
    lum:SetDebuffAuras(
    self,
    frame,
    4,
    1,
    self.cfg.height + 4,
    2,
    "TOPLEFT",
    self,
    "RIGHT",
    6,
    self.cfg.height - 3,
    "BOTTOMLEFT",
    "RIGHT",
    "UP",
    true,
    true
  )

  -- Castbar
  if self.cfg.castbar.enable then
    lum:CreateCastbar(self)
  end

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, "ARTWORK")
  RaidIcon:SetPoint("RIGHT", self, "LEFT", -8, 0)
  RaidIcon:SetSize(20, 20)
  self.RaidIcon = RaidIcon

  self.Range = cfg.frames.range
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:" .. frame:gsub("^%l", string.upper))

  for index = 1, MAX_BOSS_FRAMES or 5 do
    local boss = oUF:Spawn(frame .. index, "oUF_LumenBoss" .. index)
    -- local boss = oUF:Spawn("player", 'oUF_LumenBoss' .. index) -- Debug

    if index == 1 then
      boss:SetPoint(
        cfg.units.boss.pos.a1,
        cfg.units.boss.pos.af,
        cfg.units.boss.pos.a2,
        cfg.units.boss.pos.x,
        cfg.units.boss.pos.y
      )
    else
      boss:SetPoint("TOP", _G["oUF_LumenBoss" .. index - 1], "BOTTOM", 0, -16)
    end
  end
end
