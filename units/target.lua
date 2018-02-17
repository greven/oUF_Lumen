local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "target"

-- ------------------------------------------------------------------------
-- > TARGET UNIT SPECIFIC FUNCTiONS
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

-- Post Update Aura Icon
local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

	if duration and duration > 0 then
		icon.timeLeft = expirationTime - GetTime()

	else
		icon.timeLeft = math.huge
	end

	icon:SetScript('OnUpdate', function(self, elapsed)
		auras:AuraTimer_OnUpdate(self, elapsed)
	end)
end

-- Post Update BarTimer Aura
local PostUpdateBarTimer = function(element, unit, button, index)
  local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, button.filter)

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

  button:SetScript('OnUpdate', function(self, elapsed)
    auras:BarTimer_OnUpdate(self, elapsed)
  end)
end

-- Filter Buffs
local TargetCustomFilter = function(icons, unit, icon, name)
  if(filters.list[core.playerClass].debuffs[name] and icon.isPlayer) then
    return true
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self, "main")

  -- Texts
  core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, '[lumen:level]  [lumen:name]')
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, '[lumen:hpvalue]')
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")
  local clf = core:createFontstring(self, font, 11, "THINOUTLINE") -- classification
  clf:SetPoint("LEFT", self, "TOPLEFT", 0, 12)
  clf:SetTextColor(1, 1, 1, 1)
  self:Tag(clf, '[lumen:classification]')

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Buffs
  local buffs = auras:CreateAura(self, 8, 1, cfg.frames.secondary.height + 4, 2)
  buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 2)
  buffs.initialAnchor = "BOTTOMLEFT"
  buffs["growth-x"] = "RIGHT"
  buffs.showStealableBuffs = true
  buffs.PostUpdateIcon = PostUpdateIcon
  self.Buffs = buffs

  -- Castbar
    if self.cfg.castbar.enable then
      core:CreateCastbar(self)
    end

  -- Quest Icon
  local QuestIcon = core:createFontstring(self, font, 26, "THINOUTLINE")
  QuestIcon:SetPoint("LEFT", self.Health, "RIGHT", 5, -2)
  QuestIcon:SetText("!")
  QuestIcon:SetTextColor(238/255, 217/255, 43/255)
  self.QuestIndicator = QuestIcon

  -- Raid Icons
  local RaidIcon = self:CreateTexture(nil, 'OVERLAY')
  RaidIcon:SetPoint('LEFT', self, 'RIGHT', 8, 0)
  RaidIcon:SetSize(20, 20)
  self.RaidTargetIndicator = RaidIcon

  -- Heal Prediction
  CreateHealPrediction(self)

  -- BarTimers Auras
  local barTimers = auras:CreateBarTimer(self, 12, 12, 24, 4)
  barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
  barTimers.initialAnchor = "BOTTOMLEFT"
  barTimers["growth-y"] = "UP"
  barTimers.CustomFilter = TargetCustomFilter
  barTimers.PostUpdateIcon = PostUpdateBarTimer
  self.Debuffs = barTimers
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper))
  oUF:Spawn(frame, "oUF_Lumen"..frame:gsub("^%l", string.upper))
end
