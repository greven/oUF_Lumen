local A, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters, debuffs = ns.auras, ns.filters, ns.debuffs

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

-- oUF_Experience Tooltip
local function UpdateExperienceTooltip(self)
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local isHonor = IsWatchingHonorAsXP()
  local cur = (isHonor and UnitHonor or UnitXP)("player")
  local max = (isHonor and UnitHonorMax or UnitXPMax)("player")
  local per = math.floor(cur / max * 100 + 0.5)
  local bars = cur / max * (isHonor and 5 or 20)

  local rested = (isHonor and GetHonorExhaustion or GetXPExhaustion)() or 0
  rested = math.floor(rested / max * 100 + 0.5)

  if isHonor then
    GameTooltip:SetText(string.format("Honor Rank %s", UnitHonorLevel("player")))
    GameTooltip:AddLine(string.format("|cffff4444%s / %s Points|r", BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max)))
    GameTooltip:AddLine(string.format("|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r", bars, rested))
    GameTooltip:Show()
  else
    GameTooltip:SetText(string.format("%s / %s (%s%%)", BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max), per))
    GameTooltip:AddLine(string.format("|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r", bars, rested))
    GameTooltip:Show()
  end
end

-- Color the Experience Bar
local function ExperiencePostUpdate(self)
  -- Showing Honor
  if IsWatchingHonorAsXP() then
    self:SetStatusBarColor(255 / 255, 75 / 255, 75 / 255)
    self.Rested:SetStatusBarColor(255 / 255, 205 / 255, 90 / 255)
  else -- Experience
    self:SetStatusBarColor(150 / 255, 40 / 255, 200 / 255)
    self.Rested:SetStatusBarColor(40 / 255, 100 / 255, 200 / 255)
  end
end

-- oUF_Reputation Tooltip
local function UpdateReputationTooltip(self)
  GameTooltip:SetOwner(self, "ANCHOR_NONE")
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
  local isParagon = C_Reputation.IsFactionParagon(factionID)
  local color = FACTION_BAR_COLORS[standing]

  if name and isParagon then
    local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)

    if currentValue and threshold then
      min, max = 0, threshold
      value = currentValue % threshold
      if hasRewardPending then
        value = value + threshold
      end
    end

    GameTooltip:AddLine(format("|cff%02x%02x%02x%s|r", 0, 100, 255, name))
    GameTooltip:AddLine(
      format("|cffcecece%s:|r |cffb7b7b7%d / %d|r", _G["FACTION_STANDING_LABEL" .. standing], value, max - min)
    )
    GameTooltip:Show()
  else
    if name and color then
      GameTooltip:AddLine(format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name))
      GameTooltip:AddLine(
        format("|cffcecece%s:|r |cffb7b7b7%d / %d|r", _G["FACTION_STANDING_LABEL" .. standing], value - min, max - min)
      )
      GameTooltip:Show()
    end
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
local PlayerCustomFilter = function(icons, unit, icon, name)
  local f = filters.list
  if f["DEFAULT"].buffs[name] or f[core.playerClass].buffs[name] then
    return true
  end
end

-- Debuffs Filter (Blacklist)
local DebuffsCustomFilter = function(icons, unit, icon, name, _, _, _, duration)
  if name then
    if debuffs.list[frame][name] or duration == 0 then
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

  lum:globalStyle(self, "main")

  -- Text strings
  if self.cfg.name.show then
    core:createNameString(self, font, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 56)
    self:Tag(self.Name, "[lum:level]  [lum:name]")
  end

  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, "[lum:hpvalue]")
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize - 4, "THINOUTLINE", 0, 0, "CENTER")

  -- Health Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Power
  self.Power.frequentUpdates = self.cfg.power.frequentUpdates

  -- Castbar
  if self.cfg.castbar.enable then
    core:CreateCastbar(self)
  end

  lum:CreateClassPower(self)
  lum:CreateAdditionalPower(self)
  lum:CreatePowerPrediction(self)
  lum:CreateAlternativePower(self)
  lum:CreateHealPrediction(self)
  lum:CreateIconIndicators(self)

  -- oUF_Experience
  if cfg.elements.experiencebar.show then
    local Experience = CreateFrame("StatusBar", nil, self)
    Experience:SetStatusBarTexture(m.textures.status_texture)
    Experience:SetPoint(
      cfg.elements.experiencebar.pos.a1,
      cfg.elements.experiencebar.pos.af,
      cfg.elements.experiencebar.pos.a2,
      cfg.elements.experiencebar.pos.x,
      cfg.elements.experiencebar.pos.y
    )
    Experience:SetHeight(cfg.elements.experiencebar.height)
    Experience:SetWidth(cfg.elements.experiencebar.width)

    local Rested = CreateFrame("StatusBar", nil, Experience)
    Rested:SetStatusBarTexture(m.textures.status_texture)
    Rested:SetAllPoints(Experience)
    core:setBackdrop(Rested, 2, 2, 2, 2)

    local ExperienceBG = Rested:CreateTexture(nil, "BORDER")
    ExperienceBG:SetAllPoints()
    ExperienceBG:SetAlpha(0.3)
    ExperienceBG:SetTexture(m.textures.bg_texture)
    ExperienceBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

    Experience:EnableMouse(true)
    Experience.UpdateTooltip = UpdateExperienceTooltip
    Experience.PostUpdate = ExperiencePostUpdate

    self.Experience = Experience
    self.Experience.Rested = Rested
  end

  -- oUF_Reputation
  if cfg.elements.experiencebar.show then
    local Reputation = CreateFrame("StatusBar", nil, self)
    Reputation:SetStatusBarTexture(m.textures.status_texture)
    Reputation:SetPoint(
      cfg.elements.experiencebar.pos.a1,
      cfg.elements.experiencebar.pos.af,
      cfg.elements.experiencebar.pos.a2,
      cfg.elements.experiencebar.pos.x,
      cfg.elements.experiencebar.pos.y
    )
    Reputation:SetHeight(cfg.elements.experiencebar.height)
    Reputation:SetWidth(cfg.elements.experiencebar.width)
    core:setBackdrop(Reputation, 2, 2, 2, 2)
    Reputation.colorStanding = true

    local ReputationBG = Reputation:CreateTexture(nil, "BORDER")
    ReputationBG:SetAllPoints()
    ReputationBG:SetAlpha(0.3)
    ReputationBG:SetTexture(m.textures.bg_texture)
    ReputationBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

    Reputation:EnableMouse(true)
    Reputation.UpdateTooltip = UpdateReputationTooltip

    self.Reputation = Reputation
  end

  -- oUF_ArtifactPower
  if cfg.elements.artifactpowerbar.show then
    local ArtifactPower = CreateFrame("StatusBar", nil, self)
    ArtifactPower:SetStatusBarTexture(m.textures.status_texture)
    ArtifactPower:SetStatusBarColor(217 / 255, 205 / 255, 145 / 255)
    ArtifactPower:SetPoint(
      cfg.elements.artifactpowerbar.pos.a1,
      cfg.elements.artifactpowerbar.pos.af,
      cfg.elements.artifactpowerbar.pos.a2,
      cfg.elements.artifactpowerbar.pos.x,
      cfg.elements.artifactpowerbar.pos.y
    )
    ArtifactPower:SetHeight(cfg.elements.artifactpowerbar.height)
    ArtifactPower:SetWidth(cfg.elements.artifactpowerbar.width)
    core:setBackdrop(ArtifactPower, 2, 2, 2, 2)
    ArtifactPower:EnableMouse(true)
    self.ArtifactPower = ArtifactPower

    local ArtifactPowerBG = ArtifactPower:CreateTexture(nil, "BORDER")
    ArtifactPowerBG:SetAllPoints()
    ArtifactPowerBG:SetAlpha(0.3)
    ArtifactPowerBG:SetTexture(m.textures.bg_texture)
    ArtifactPowerBG:SetColorTexture(1 / 3, 1 / 3, 1 / 3)
  end

  -- Debuffs
  if self.cfg.auras.debuffs.show then
    local debuffs = auras:CreateAura(self, 12, 12, cfg.frames.main.height + 4, 4)
    debuffs:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -56, -2)
    debuffs.initialAnchor = "BOTTOMRIGHT"
    debuffs["growth-y"] = "UP"
    debuffs.showDebuffType = true
    debuffs.CustomFilter = DebuffsCustomFilter
    debuffs.PostCreateIcon = PostCreateIcon
    debuffs.PostUpdateIcon = PostUpdateIcon
    self.Debuffs = debuffs
  end

  -- BarTimers Auras
  if self.cfg.auras.barTimers.show then
    local barTimers = auras:CreateBarTimer(self, 12, 12, 24, 2)
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
