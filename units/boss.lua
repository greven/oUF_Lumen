local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local font = m.fonts.font

local frame = "boss"

-- ------------------------------------------------------------------------
-- > BOSS UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  if cfg.units[frame].health.gradientColored then
    local color = CreateColor(oUF:ColorGradient(min, max, 1, 0, 0, 1, 1, 0, .5, 1, .25))
    health:SetStatusBarColor(color:GetRGB())
  end
end

-- Post Update Aura Icon
local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

  if duration and duration > 0 then
    icon.timeLeft = expirationTime - GetTime()
  else
    icon.timeLeft = math.huge
  end

  icon:SetScript(
    "OnUpdate",
    function(self, elapsed)
      auras:AuraTimer_OnUpdate(self, elapsed)
    end
  )
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:sharedStyle(self, "secondary")

  self:SetSize(self.cfg.width, self.cfg.height)

  -- Texts
  core:createNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, "[lum:level]  [lum:name]")
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, "[lum:hpvalue]")
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  if self.cfg.power.text.show then
    core:createPowerString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 0, "CENTER")
  end

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Buffs
  local buffs = auras:CreateAura(self, 4, 1, self.cfg.height + 4, 2)
  buffs:SetPoint("TOPRIGHT", self, "LEFT", -6, self.cfg.height - 3)
  buffs.initialAnchor = "BOTTOMRIGHT"
  buffs["growth-x"] = "LEFT"
  buffs.showStealableBuffs = true
  buffs.PostUpdateIcon = PostUpdateIcon
  self.Buffs = buffs

  -- Debuffs
  local debuffs = auras:CreateAura(self, 4, 1, self.cfg.height + 4, 2)
  debuffs:SetPoint("TOPLEFT", self, "RIGHT", 6, self.cfg.height - 3)
  debuffs.initialAnchor = "BOTTOMLEFT"
  debuffs["growth-x"] = "RIGHT"
  debuffs.onlyShowPlayer = true
  debuffs.PostUpdateIcon = PostUpdateIcon
  self.Debuffs = debuffs

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
