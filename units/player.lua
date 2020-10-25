local A, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local filters, debuffs = ns.filters, ns.debuffs

local _G = _G

local font = m.fonts.font

local frame = "player"

-- -----------------------------------
-- > PLAYER UNIT SPECIFIC FUNCTIONS
-- -----------------------------------

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

local PostCreateIcon = function(Auras, button)
  local count = button.count
  count:ClearAllPoints()
  count:SetFont(m.fonts.font, 12, "OUTLINE")
  count:SetPoint("TOPRIGHT", button, 3, 3)

  button.icon:SetTexCoord(.08, .92, .08, .92)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self)
    self:SetVertexColor(0.3, 0.3, 0.3)
  end

  button.spell = button:CreateFontString(nil, "OVERLAY")
  button.spell:SetPoint("RIGHT", button, "LEFT", -4, 0)
  button.spell:SetFont(m.fonts.font, 16, "THINOUTLINE")
  button.spell:SetTextColor(1, 1, 1)
  button.spell:SetShadowOffset(1, -1)
  button.spell:SetShadowColor(0, 0, 0, 1)
  button.spell:SetJustifyH("RIGHT")
  button.spell:SetWordWrap(false)

  button.time = button:CreateFontString(nil, "OVERLAY")
  button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
  button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
  button.time:SetTextColor(1, 1, 0.65)
  button.time:SetShadowOffset(1, -1)
  button.time:SetShadowColor(0, 0, 0, 1)
  button.time:SetJustifyH("CENTER")
end

-- Post Update Aura Icon
local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

  if duration and duration > 0 then
    icon.timeLeft = expirationTime - GetTime()
  else
    icon.timeLeft = math.huge
  end

  icon.spell:SetText(name) -- set spell name

  icon:SetScript(
    "OnUpdate",
    function(self, elapsed)
      lum:AuraTimer_OnUpdate(self, elapsed)
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
      lum:BarTimer_OnUpdate(self, elapsed)
    end
  )
end

-- Filter Buffs
local PlayerCustomFilter = function(...)
  local spellID = select(13, ...)
  if spellID then
    if filters["ALL"].buffs[spellID] or filters[core.playerClass].buffs[spellID] then
      return true
    end
  end
end

-- Debuffs Filter (Blacklist)
local DebuffsCustomFilter = function(element, unit, button, name, _, _, _, duration, _, _, _, _, spellID)
  if spellID then
    if debuffs.list[frame][spellID] or duration == 0 then
      return false
    end
  end
  return true
end

-- -----------------------------------
-- > PLAYER STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "main")

  -- Text strings
  if self.cfg.name.show then
    lum:CreateNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 56)
  end

  lum:CreateHealthValueString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  lum:CreateHealthPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  lum:CreatePowerValueString(self, font, cfg.fontsize - 3, "THINOUTLINE", 0, 0, "CENTER")

  -- Health Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Power
  self.Power.frequentUpdates = self.cfg.power.frequentUpdates

  lum:CreateCastbar(self)
  lum:CreateClassPower(self)
  lum:CreateAdditionalPower(self)
  lum:CreatePowerPrediction(self)
  lum:CreateAlternativePower(self)
  lum:CreateHealPrediction(self)
  lum:CreatePlayerIconIndicators(self)
  lum:MirrorBars()

  -- Addons
  lum:CreateExperienceBar(self)
  lum:CreateReputationBar(self)
  lum:CreateArtifactPowerBar(self)

  -- Debuffs
  -- if self.cfg.auras.debuffs.show then
  --   local debuffs = auras:CreateAura(self, 12, 12, cfg.frames.main.height + 4, 4)
  --   debuffs:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -56, -2)
  --   debuffs.initialAnchor = "BOTTOMRIGHT"
  --   debuffs["growth-y"] = "UP"
  --   debuffs.showDebuffType = true
  --   debuffs.CustomFilter = DebuffsCustomFilter
  --   debuffs.PostCreateIcon = PostCreateIcon
  --   debuffs.PostUpdateIcon = PostUpdateIcon
  --   self.Debuffs = debuffs
  -- end

  -- BarTimers Auras
  if self.cfg.auras.barTimers.show then
    local barTimers = lum:CreateBarTimer(self, 12, 12, 24, 2)
    barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
    barTimers.initialAnchor = "BOTTOMLEFT"
    barTimers["growth-y"] = "UP"
    barTimers.CustomFilter = PlayerCustomFilter
    barTimers.PostUpdateIcon = PostUpdateBarTimer
    self.Buffs = barTimers
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
