local A, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters, debuffs = ns.auras, ns.filters, ns.debuffs

local _G = _G

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "player"

-- -----------------------------------
-- > PLAYER UNIT SPECIFIC FUNCTIONS
-- -----------------------------------

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

-- Post Update ClassPower
local function PostUpdateClassPower(element, cur, max, diff, powerType)
  if(diff) then
    local maxWidth, gap = cfg.frames.main.width, 6

		for index = 1, max do
      local Bar = element[index]

			if(max == 3) then
        Bar:SetWidth(((maxWidth / max) - (((max-1) * gap) / max)))
			elseif(max == 4) then
        Bar:SetWidth(((maxWidth / max) - (((max-1) * gap) / max)))
			elseif(max == 5 or max == 10) then
        Bar:SetWidth(((maxWidth / 5) - ((4 * gap) / 5)))
			elseif(max == 6) then
        Bar:SetWidth(((maxWidth / max) - (((max-1) * gap) / max)))
			end

			if(max == 10) then -- Rogue anticipation talent
        -- draw bars on top of the first 5
        if(index == 6) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 5])
        end
        -- Color rogue anticipation points >5
        if(index > 5) then
					Bar.bg:SetColorTexture(25/255, 255/255, 255/255)
        elseif(index == 5) then
          Bar.bg:SetColorTexture(255/255, 26/255, 48/255)
				end
			else
				if(index > 1) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
        end
			end
		end
  end

  -- Colorize the last bar
  local lastBarColor = {
    DRUID = {255/255, 26/255, 48/255},
    MAGE = {238/255, 48/255, 83/255},
    MONK = {0/255, 143/255, 247/255},
    PALADIN = {255/255, 26/255, 48/255},
    ROGUE = {255/255, 26/255, 48/255},
    WARLOCK = {255/255, 26/255, 48/255}
  }

  if max then
    local lastBar = element[max]
    lastBar:SetStatusBarColor(unpack(lastBarColor[core.playerClass]))
  end
end

-- Post Update ClassPower Texture
local function UpdateClassPowerColor(element)
  local r, g, b = 255/255, 255/255, 102/255

	if(not UnitHasVehicleUI('player')) then
		if(core.playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(core.playerClass == 'WARLOCK') then
      r, g, b = 161/255, 92/255, 255/255
		elseif(core.playerClass == 'PALADIN') then
			r, g, b = 255/255, 255/255, 125/255
		elseif(core.playerClass == 'MAGE') then
			r, g, b = 169/255, 80/255, 202/255
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		if(core.playerClass == 'ROGUE' and UnitPowerMax('player', SPELL_POWER_COMBO_POINTS) == 10 and index > 5) then
			r, g, b = 1, 0, 0
    end

		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetColorTexture(r * 1/3, g * 1/3, b * 1/3)
	end
end

-- Create Class Power Bars (Combo Points...)
local function CreateClassPower(self)
  local ClassPower = {}
  ClassPower.UpdateColor = UpdateClassPowerColor
  ClassPower.PostUpdate = PostUpdateClassPower

  for index = 1, 11 do
    local Bar = CreateFrame('StatusBar', 'oUF_LumenClassPower', self)
    Bar:SetHeight(cfg.frames.main.power.height)
    Bar:SetStatusBarTexture(m.textures.status_texture)
    core:setBackdrop(Bar, 2, 2, 2, 2)

    if(index > 1) then
      Bar:SetPoint('LEFT', ClassPower[index - 1], 'RIGHT', 6, 0)
    else
      Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    end

    if(index > 5) then
      Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
    end

    local Background = Bar:CreateTexture(nil, 'BORDER')
    Background:SetAllPoints()
    Bar.bg = Background

    ClassPower[index] = Bar
  end
  self.ClassPower = ClassPower
end

-- Death Knight Runebar
local CreateRuneBar = function(self)
  local Runes = {}
  for index = 1, 6 do
    local Rune = CreateFrame('StatusBar', nil, self)
    local numRunes, maxWidth, gap = 6, cfg.frames.main.width, 6
    local width = ((maxWidth / numRunes) - (((numRunes-1) * gap) / numRunes))

    Rune:SetSize(width, 3)
    Rune:SetStatusBarTexture(m.textures.status_texture)
    -- Rune:SetStatusBarColor(unpack(oUF.colors.power["RUNES"]))
    core:setBackdrop(Rune, 2, 2, 2, 2) -- Backdrop

    if(index == 1) then
      Rune:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    else
      Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', gap, 0)
    end

    Runes[index] = Rune
  end
  Runes.colorSpec = true -- color runes by spec
  self.Runes = Runes
end

-- AdditionalPower post update callback
local AdditionalPowerPostUpdate = function(self, unit, cur, max)
  local powertype = UnitPowerType(unit)
  if unit ~= 'player' or powertype == 0 then return end
  -- Hide bar if full
  if cur == max or powertype == 0 then
    self:Hide()
  else
    self:Show()
  end
end

-- Create additional power (oUF Druid Mana)
local CreateAdditionalPower = function(self)
  local height = -10

  -- Classes which also have Class Power
  if core.playerClass == "DRUID" or core.playerClass == "MONK" then
    height = -16
  end

  local AdditionalPower = CreateFrame("StatusBar", nil, self)
  AdditionalPower:SetStatusBarTexture(m.textures.status_texture)
  AdditionalPower:GetStatusBarTexture():SetHorizTile(false)
  AdditionalPower:SetSize(self.cfg.width, self.cfg.altpower.height)
  AdditionalPower:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, height)
  AdditionalPower.colorPower = true

  -- Add a background
  local Background = AdditionalPower:CreateTexture(nil, 'BACKGROUND')
  Background:SetAllPoints(AdditionalPower)
  Background:SetAlpha(0.20)
  Background:SetTexture(m.textures.bg_texture)

  -- Value
  local PowerValue = core:createFontstring(AdditionalPower, font, cfg.fontsize -4, "THINOUTLINE")
  PowerValue:SetPoint("RIGHT", AdditionalPower, -8, 0)
  PowerValue:SetJustifyH("RIGHT")
  self:Tag(PowerValue, '[lumen:altpower]')

  -- Backdrop
  core:setBackdrop(AdditionalPower, 2, 2, 2, 2)

  -- Register it with oUF
  self.AdditionalPower = AdditionalPower
  self.AdditionalPower.bg = Background
  self.AdditionalPower.PostUpdate = AdditionalPowerPostUpdate
end

-- oUF_Experience Tooltip
local function UpdateExperienceTooltip(self)
  GameTooltip:SetOwner(self, 'ANCHOR_NONE')
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local isHonor = IsWatchingHonorAsXP()
	local cur = (isHonor and UnitHonor or UnitXP)('player')
	local max = (isHonor and UnitHonorMax or UnitXPMax)('player')
	local per = math.floor(cur / max * 100 + 0.5)
	local bars = cur / max * (isHonor and 5 or 20)

	local rested = (isHonor and GetHonorExhaustion or GetXPExhaustion)() or 0
  rested = math.floor(rested / max * 100 + 0.5)

  if isHonor then
    GameTooltip:SetText(string.format('Honor Rank %s', UnitHonorLevel('player')))
    GameTooltip:AddLine(string.format('|cffff4444%s / %s Points|r', BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max)))
    GameTooltip:AddLine(string.format('|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r', bars, rested))
    GameTooltip:Show()
  else
    GameTooltip:SetText(string.format('%s / %s (%s%%)', BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max), per))
		GameTooltip:AddLine(string.format('|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r', bars, rested))
		GameTooltip:Show()
  end
end

-- Color the Experience Bar
local function ExperiencePostUpdate(self)
  -- Experience
  if not IsWatchingHonorAsXP() then
    self:SetStatusBarColor(150/255, 40/255, 200/255)
    self.Rested:SetStatusBarColor(40/255, 100/255, 200/255)
  else -- Showing Honor
    self:SetStatusBarColor(255/255, 75/255, 75/255)
    self.Rested:SetStatusBarColor(255/255, 205/255, 90/255)
  end
end

-- oUF_Reputation Tooltip
local function UpdateReputationTooltip(self)
  GameTooltip:SetOwner(self, 'ANCHOR_NONE')
  GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)

  local name, standing, min, max, value = GetWatchedFactionInfo()
  local color = FACTION_BAR_COLORS[standing]

  if name and color then
    GameTooltip:AddLine(format('|cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, name))
    GameTooltip:AddLine(format('|cffcecece%s:|r |cffb7b7b7%d / %d|r', _G["FACTION_STANDING_LABEL"..standing], value - min, max - min))
    GameTooltip:Show()
  end
end

-- AltPower PostUpdate
local AltPowerPostUpdate = function(self, unit, cur, min, max)
	if self.unit ~= unit then return end

	local _, r, g, b = _G.UnitAlternatePowerTextureInfo(self.__owner.unit, 2)

	if (r == 1 and g == 1 and b == 1) or not b then
		r, g, b = 1, 0, 0
	end

	self:SetStatusBarColor(r, g, b)
	if cur < max then
		if self.isMouseOver then
			self.Text:SetFormattedText("%s / %s - %d%%", core:shortNumber(cur), core:shortNumber(max), core:NumberToPerc(cur, max))
		elseif cur > 0 then
			self.Text:SetFormattedText("%s", core:shortNumber(cur))
		else
			self.Text:SetText(nil)
		end
	else
		if self.isMouseOver then
			self.Text:SetFormattedText("%s", core:shortNumber(cur))
		else
			self.Text:SetText(nil)
		end
	end
end

local function AlternativePowerOnEnter(self)
	if not self:IsVisible() then return end

	self.isMouseOver = true
	self:ForceUpdate()
	_G.GameTooltip_SetDefaultAnchor(_G.GameTooltip, self)
	self:UpdateTooltip()
end

local function AlternativePowerOnLeave(self)
	self.isMouseOver = nil
	self:ForceUpdate()
	_G.GameTooltip:Hide()
end

-- AltPower (quest or boss special power)
local CreateAlternativePower = function(self)
	local AlternativePower = CreateFrame('StatusBar', nil, self)
	AlternativePower:SetStatusBarTexture(m.textures.status_texture)
	core:setBackdrop(AlternativePower, 2, 2, 2, 2)
	AlternativePower:SetHeight(16)
	AlternativePower:SetWidth(200)
	AlternativePower:SetPoint('CENTER', 'UIParent', 'CENTER', 0, 350)

	AlternativePower.Text = core:createFontstring(AlternativePower, font, 10, "THINOUTLINE")
	AlternativePower.Text:SetPoint("CENTER", 0, 0)

	local AlternativePowerBG = AlternativePower:CreateTexture(nil, 'BORDER')
	AlternativePowerBG:SetAllPoints()
	AlternativePowerBG:SetAlpha(0.3)
	AlternativePowerBG:SetTexture(m.textures.bg_texture)
	AlternativePowerBG:SetColorTexture(1/3, 1/3, 1/3)

	AlternativePower:EnableMouse(true)
	AlternativePower:SetScript("OnEnter", AlternativePowerOnEnter)
	AlternativePower:SetScript("OnLeave", AlternativePowerOnLeave)
  AlternativePower.PostUpdate = AltPowerPostUpdate

	self.AlternativePower = AlternativePower
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetFont(m.fonts.font, 12, 'OUTLINE')
	count:SetPoint('TOPRIGHT', button, 3, 3)

  button.icon:SetTexCoord(.07, .93, .07, .93)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

  button.spell = button:CreateFontString(nil, 'OVERLAY')
	button.spell:SetPoint("RIGHT", button, "LEFT", -4, 0)
	button.spell:SetFont(m.fonts.font_big, 16, "THINOUTLINE")
	button.spell:SetTextColor(1, 1, 1)
	button.spell:SetShadowOffset(1, -1)
	button.spell:SetShadowColor(0, 0, 0, 1)
	button.spell:SetJustifyH("RIGHT")
	button.spell:SetWordWrap(false)

	button.time = button:CreateFontString(nil, 'OVERLAY')
	button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
	button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
	button.time:SetTextColor(1, 1, 0.65)
	button.time:SetShadowOffset(1, -1)
	button.time:SetShadowColor(0, 0, 0, 1)
	button.time:SetJustifyH('CENTER')
end

-- Post Update Aura Icon
local PostUpdateIcon =  function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

	if duration and duration > 0 then
		icon.timeLeft = expirationTime - GetTime()
	else
		icon.timeLeft = math.huge
  end

  icon.spell:SetText(name) -- set spell name

	icon:SetScript('OnUpdate', function(self, elapsed)
		auras:AuraTimer_OnUpdate(self, elapsed)
	end)
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

  button:SetScript('OnUpdate', function(self, elapsed)
    auras:BarTimer_OnUpdate(self, elapsed)
  end)
end

-- Filter Buffs
local PlayerCustomFilter = function(icons, unit, icon, name)
  if(filters.list[core.playerClass].buffs[name]) then
    return true
  end
end

-- Debuffs Filter (Blacklist)
local DebuffsCustomFilter = function(icons, unit, icon, name)
  if name then
    if debuffs.list[frame][name] then
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
    core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 60)
    self:Tag(self.Name, '[lumen:level]  [lumen:name]')
  end
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, '[lumen:hpvalue]')
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth


  -- Out of Combat Frame Fading
  if self.cfg.fader.enable then
    self:SetAlpha(self.cfg.fader.alpha)
    self:RegisterEvent("PLAYER_REGEN_DISABLED", function(self) self:SetAlpha(1) end)
    self:RegisterEvent("PLAYER_REGEN_ENABLED", function(self) self:SetAlpha(self.cfg.fader.alpha) end)
  end

  -- Castbar
  if self.cfg.castbar.enable then
    core:CreateCastbar(self)
  end

  -- Class Power (Combo Points, etc...)
  if core.playerClass == 'ROGUE' or core.playerClass == 'DRUID' or core.playerClass == 'MAGE'
    or core.playerClass == 'MONK' or core.playerClass == 'PALADIN' or core.playerClass == 'WARLOCK' then
      CreateClassPower(self)
  end

  -- Death Knight Runes
  if core.playerClass == 'DEATHKNIGHT' then CreateRuneBar(self) end

  -- Alternate Power Bar
  if core.playerClass == 'PRIEST' or core.playerClass == 'MONK' or core.playerClass == 'SHAMAN' then
    CreateAdditionalPower(self)
  end

	-- AltPower (quest or boss special power)
	if cfg.elements.altpowerbar.show then
		CreateAlternativePower(self)
	end

  -- Combat indicator
  local Combat = core:createFontstring(self, m.fonts.symbols, 20, "THINOUTLINE")
  Combat:SetPoint("RIGHT", self, "LEFT", -8, 2)
  Combat:SetText("")
  Combat:SetTextColor(255/255, 26/255, 48/255)
  self.CombatIndicator = Combat

  -- Resting
  if not core:isPlayerMaxLevel() then
    local Resting = core:createFontstring(self.Health, font, cfg.fontsize -4, "THINOUTLINE")
    Resting:SetPoint("CENTER", self.Health, "TOP", 0, 0)
    Resting:SetText("zZz")
    Resting:SetTextColor(255/255, 255/255, 255/255, 0.70)
    self.RestingIndicator = Resting
  end

  -- oUF_Experience
  if cfg.elements.experiencebar.show then
    local Experience = CreateFrame('StatusBar', nil, self)
    Experience:SetStatusBarTexture(m.textures.status_texture)
    Experience:SetPoint(cfg.elements.experiencebar.pos.a1, cfg.elements.experiencebar.pos.af,
			cfg.elements.experiencebar.pos.a2, cfg.elements.experiencebar.pos.x, cfg.elements.experiencebar.pos.y)
    Experience:SetHeight(cfg.elements.experiencebar.height)
    Experience:SetWidth(cfg.elements.experiencebar.width)

    local Rested = CreateFrame('StatusBar', nil, Experience)
    Rested:SetStatusBarTexture(m.textures.status_texture)
    Rested:SetAllPoints(Experience)
    core:setBackdrop(Rested, 2, 2, 2, 2)

    local ExperienceBG = Rested:CreateTexture(nil, 'BORDER')
    ExperienceBG:SetAllPoints()
    ExperienceBG:SetAlpha(0.3)
    ExperienceBG:SetTexture(m.textures.bg_texture)
    ExperienceBG:SetColorTexture(1/3, 1/3, 1/3)

    Experience:EnableMouse(true)
    Experience.UpdateTooltip = UpdateExperienceTooltip
    Experience.PostUpdate = ExperiencePostUpdate

    self.Experience = Experience
    self.Experience.Rested = Rested
  end

  -- oUF_Reputation
  if cfg.elements.experiencebar.show then
    local Reputation = CreateFrame('StatusBar', nil, self)
  	Reputation:SetStatusBarTexture(m.textures.status_texture)
  	Reputation:SetPoint(cfg.elements.experiencebar.pos.a1, cfg.elements.experiencebar.pos.af,
      cfg.elements.experiencebar.pos.a2, cfg.elements.experiencebar.pos.x, cfg.elements.experiencebar.pos.y)
  	Reputation:SetHeight(cfg.elements.experiencebar.height)
  	Reputation:SetWidth(cfg.elements.experiencebar.width)
    core:setBackdrop(Reputation, 2, 2, 2, 2)
    Reputation.colorStanding = true

    local ReputationBG = Reputation:CreateTexture(nil, 'BORDER')
    ReputationBG:SetAllPoints()
    ReputationBG:SetAlpha(0.3)
    ReputationBG:SetTexture(m.textures.bg_texture)
    ReputationBG:SetColorTexture(1/3, 1/3, 1/3)

    Reputation:EnableMouse(true)
    Reputation.UpdateTooltip = UpdateReputationTooltip

    self.Reputation = Reputation
  end

  -- oUF_ArtifactPower
  if cfg.elements.artifactpowerbar.show then
    local ArtifactPower = CreateFrame('StatusBar', nil, self)
    ArtifactPower:SetStatusBarTexture(m.textures.status_texture)
    ArtifactPower:SetStatusBarColor(217/255, 205/255, 145/255)
    ArtifactPower:SetPoint(cfg.elements.artifactpowerbar.pos.a1, cfg.elements.artifactpowerbar.pos.af,
			cfg.elements.artifactpowerbar.pos.a2, cfg.elements.artifactpowerbar.pos.x, cfg.elements.artifactpowerbar.pos.y)
    ArtifactPower:SetHeight(cfg.elements.artifactpowerbar.height)
    ArtifactPower:SetWidth(cfg.elements.artifactpowerbar.width)
    core:setBackdrop(ArtifactPower, 2, 2, 2, 2)
    ArtifactPower:EnableMouse(true)
    self.ArtifactPower = ArtifactPower

    local ArtifactPowerBG = ArtifactPower:CreateTexture(nil, 'BORDER')
    ArtifactPowerBG:SetAllPoints()
    ArtifactPowerBG:SetAlpha(0.3)
    ArtifactPowerBG:SetTexture(m.textures.bg_texture)
    ArtifactPowerBG:SetColorTexture(1/3, 1/3, 1/3)
  end

  -- Heal Prediction
  CreateHealPrediction(self)

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
  oUF:RegisterStyle(A..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle(A..frame:gsub("^%l", string.upper))
  local f = oUF:Spawn(frame, A..frame:gsub("^%l", string.upper))
  -- Frame Visibility
  if cfg.units[frame].visibility then
    f:Disable()
    RegisterStateDriver(f, "visibility", cfg.units[frame].visibility)
  end
end
