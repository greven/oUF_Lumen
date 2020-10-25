local A, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local font = m.fonts.font

local frame = "target"

-- ------------------------------------------------------------------------
-- > TARGET UNIT SPECIFIC FUNCTiONS
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

-- Post Update Aura Icon
local PostUpdateIcon = function(self, unit, icon, index)
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

-- Post Update BarTimer Aura
local PostUpdateBarTimer = function(element, unit, button, index)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, button.filter)

  if duration and duration > 0 then
    button.timeLeft = expirationTime - GetTime()
    button.bar:SetMinMaxValues(0, duration)
    button.bar:SetValue(button.timeLeft)

    if button.isDebuff then -- bar color
      button.bar:SetStatusBarColor(1, 0.1, 0.2)
    else
      button.bar:SetStatusBarColor(0, 0.4, 1)
    end
  else
    button.timeLeft = math.huge
    button.bar:SetStatusBarColor(0.6, 0, 0.8) -- permenant buff / debuff
  end

  button.spell:SetText(name) -- set spell name

  button:SetScript(
    "OnUpdate",
    function(self, elapsed)
      auras:BarTimer_OnUpdate(self, elapsed)
    end
  )
end

-- Filter Buffs
local TargetCustomFilter = function(icons, unit, icon, name)
  if (filters.list[core.playerClass].debuffs[name] and icon.isPlayer) then
    return true
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:sharedStyle(self, "main")

  -- Texts
  if self.cfg.name.show then
    lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 56)
  end

  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 3, "THINOUTLINE", 0, 0, "CENTER")
  lum:CreateClassificationString(self, font, cfg.fontsize - 1)

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  lum:CreateCastbar(self)
  lum:CreateHealPrediction(self)
  lum:CreateTargetIconIndicators(self)

  -- Buffs
  if self.cfg.auras.buffs.show then
    local buffs = auras:CreateAura(self, 8, 1, cfg.frames.secondary.height + 4, 2)
    buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 2)
    buffs.initialAnchor = "BOTTOMLEFT"
    buffs["growth-x"] = "RIGHT"
    buffs.showStealableBuffs = true
    buffs.PostUpdateIcon = PostUpdateIcon
    self.Buffs = buffs
  end

  -- BarTimers Auras
  if self.cfg.auras.barTimers.show then
    local barTimers = auras:CreateBarTimer(self, 12, 12, 24, 2)
    barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
    barTimers.initialAnchor = "BOTTOMLEFT"
    barTimers["growth-y"] = "UP"
    barTimers.CustomFilter = TargetCustomFilter
    barTimers.PostUpdateIcon = PostUpdateBarTimer
    self.Debuffs = barTimers
  end
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
    core:CreateFrameFader(f, cfg.units[frame].fader)
  end
end
