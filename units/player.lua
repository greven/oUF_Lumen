local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local _G = _G

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "player"

-- ------------------------------------------------------------------------
-- > PLAYER UNIT SPECIFIC FUNCTiONS
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

-- Post Update ClassIcon
local function PostUpdateClassIcon(element, cur, max, diff, powerType, event)
	if(diff or event == 'ClassPowerEnable') then
		element:UpdateTexture()

    local lastIconColor = {
      DRUID = {255/255, 26/255, 48/255},
      MAGE = {238/255, 48/255, 83/255},
      MONK = {0/255, 143/255, 247/255},
      PALADIN = {255/255, 26/255, 48/255},
      ROGUE = {255/255, 26/255, 48/255},
      WARLOCK = {255/255, 26/255, 48/255},
    }

		for index = 1, max do
			local ClassIcon = element[index]
      local maxWidth, gap = cfg.frames.main.width, 6

      if(max == 5 or max == 8) then
        ClassIcon:SetWidth(((maxWidth / 5) - ((4 * gap) / 5)))
      else
        ClassIcon:SetWidth(((maxWidth / max) - (((max-1) * gap) / max)))
      end

			if(max == 8) then -- Rogue anticipation
				if(index == 6) then
					ClassIcon:ClearAllPoints()
					ClassIcon:SetPoint('LEFT', element[index - 5])
				end

				if(index > 5) then
					ClassIcon.Texture:SetColorTexture(25/255, 255/255, 255/255)
        elseif(index == 5) then
          ClassIcon.Texture:SetColorTexture(255/255, 26/255, 48/255)
				end
			else
				if(index > 1) then
					ClassIcon:ClearAllPoints()
					ClassIcon:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
				end
        if(index == max) then
          ClassIcon.Texture:SetColorTexture(unpack(lastIconColor[core.playerClass]))
        end
			end
		end
	end
end

-- Post Update ClassIcon Texture
local function UpdateClassIconTexture(element)
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

	for index = 1, 8 do
		local ClassIcon = element[index]
		ClassIcon.Texture:SetColorTexture(r, g, b)
	end
end

-- Create Class Icons (Combo Points...)
local function CreateClassIcons(self)
  local ClassIcons = {}
  ClassIcons.UpdateTexture = UpdateClassIconTexture
  ClassIcons.PostUpdate = PostUpdateClassIcon

  for index = 1, 8 do
    local ClassIcon = CreateFrame('Frame', "oUF_LumenClassIcons", self)
    ClassIcon:SetHeight(cfg.frames.main.power.height)
    core:setBackdrop(ClassIcon, 2, 2, 2, 2)

    if(index > 1) then
      ClassIcon:SetPoint('LEFT', ClassIcons[index - 1], 'RIGHT', 6, 0)
    else
      ClassIcon:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    end

    local Texture = ClassIcon:CreateTexture(nil, m.textures.status_texture, nil, index > 5 and 1 or 0)
    Texture:SetAllPoints()
    ClassIcon.Texture = Texture

    ClassIcons[index] = ClassIcon
  end
  self.ClassIcons = ClassIcons
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
    Rune:SetStatusBarColor(unpack(oUF.colors.power["RUNES"]))
    core:setBackdrop(Rune, 2, 2, 2, 2) -- Backdrop

    if(index == 1) then
      Rune:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    else
      Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', gap, 0)
    end

    Runes[index] = Rune
  end
  self.Runes = Runes
end

-- Druid Mana post update callback
local DruidManaPostUpdate = function(self, unit, cur, max)
  local powerType = UnitPowerType(unit)

  -- Hide DruidMana if full
  if(cur == max or powerType == 0) then
    self:Hide()
  else
    self:Show()
  end
end

-- Create alternate power (oUF Druid Mana)
local CreateAlternatePower = function(self)
  local height = core.playerClass == "DRUID" and -16 or -10 -- Druid has combo points also

  local DruidMana = CreateFrame("StatusBar", nil, self)
  DruidMana:SetStatusBarTexture(m.textures.status_texture)
  DruidMana:GetStatusBarTexture():SetHorizTile(false)
  DruidMana:SetSize(self.cfg.width, self.cfg.altpower.height)
  DruidMana:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, height)
  DruidMana.colorPower = true

  -- Add a background
  local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
  Background:SetAllPoints(DruidMana)
  Background:SetAlpha(0.20)
  Background:SetTexture(m.textures.bg_texture)

  -- Value
  local PowerValue = core:createFontstring(DruidMana, font, cfg.fontsize -4, "THINOUTLINE")
  PowerValue:SetPoint("RIGHT", DruidMana, -8, 0)
  PowerValue:SetJustifyH("RIGHT")
  self:Tag(PowerValue, '[lumen:altpower]')

  -- Backdrop
  core:setBackdrop(DruidMana, 2, 2, 2, 2)

  -- Post Update
  DruidMana.PostUpdate = DruidManaPostUpdate

  -- Register it with oUF
  self.DruidMana = DruidMana
  self.DruidMana.bg = Background
end

-- Post Update Aura Icon
local PostUpdateIcon =  function(icons, unit, icon, index, offset, filter, isDebuff)
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

-- oUF_Experience Tooltip
local function UpdateExperienceTooltip(self)
	if(not (UnitLevel('player') == MAX_PLAYER_LEVEL and IsWatchingHonorAsXP())) then
		local cur = UnitXP('player')
		local max = UnitXPMax('player')
		local per = math.floor(cur / max * 100 + 0.5)
		local rested = math.floor((GetXPExhaustion() or 0) / max * 100 + 0.5)

		GameTooltip:SetOwner(self, 'ANCHOR_NONE')
    GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
		GameTooltip:SetText(string.format('%s / %s (%s%%)', BreakUpLargeNumbers(cur), BreakUpLargeNumbers(max), per))
		GameTooltip:AddLine(string.format('|cffffffff%.1f bars|r, |cff2581e9%s%% rested|r', cur / max * 20, rested))
		GameTooltip:Show()
	end
end

-- AltPower PostUpdate
local AltPowerPostUpdate = function(self, min, cur, max)
	if not self.Text then return end

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

local function AltPowerBarOnEnter(self)
	if not self:IsVisible() then return end

	self.isMouseOver = true
	self:ForceUpdate()
	_G.GameTooltip_SetDefaultAnchor(_G.GameTooltip, self)
	self:UpdateTooltip()
end

local function AltPowerBarOnLeave(self)
	self.isMouseOver = nil
	self:ForceUpdate()
	_G.GameTooltip:Hide()
end

-- AltPower (quest or boss special power)
local CreateAltPowerBar = function(self)
	local AltPowerBar = CreateFrame('StatusBar', nil, self)
	AltPowerBar:SetStatusBarTexture(m.textures.status_texture)
	core:setBackdrop(AltPowerBar, 2, 2, 2, 2)
	AltPowerBar:SetHeight(16)
	AltPowerBar:SetWidth(200)
	AltPowerBar:SetPoint('CENTER', 'UIParent', 'CENTER', 0, 350)

	AltPowerBar.Text = core:createFontstring(AltPowerBar, font, 10, "THINOUTLINE")
	AltPowerBar.Text:SetPoint("CENTER", 0, 0)

	local AltPowerBarBG = AltPowerBar:CreateTexture(nil, 'BORDER')
	AltPowerBarBG:SetAllPoints()
	AltPowerBarBG:SetAlpha(0.3)
	AltPowerBarBG:SetTexture(m.textures.bg_texture)
	AltPowerBarBG:SetColorTexture(1/3, 1/3, 1/3)

	AltPowerBar:EnableMouse(true)
	AltPowerBar:SetScript("OnEnter", AltPowerBarOnEnter)
	AltPowerBar:SetScript("OnLeave", AltPowerBarOnLeave)
	AltPowerBar.PostUpdate = AltPowerPostUpdate
	self.AltPowerBar = AltPowerBar
end

-- Post Update BarTimer Aura
local PostUpdateBarTimer = function(icons, unit, icon, index)
  local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

  if duration and duration > 0 then
    icon.timeLeft = expirationTime - GetTime()
    icon.bar:SetMinMaxValues(0, duration)
    icon.bar:SetValue(icon.timeLeft)
    icon.spell:SetText(name)

    if icon.isDebuff then
      icon.bar:SetStatusBarColor(1, 0.1, 0.2)
    else
      icon.bar:SetStatusBarColor(0, 0.4, 1)
    end
  else
    icon.timeLeft = math.huge
  end

  icon:SetScript('OnUpdate', function(self, elapsed)
    auras:BarTimer_OnUpdate(self, elapsed)
  end)
end

-- Filter Buffs
local PlayerCustomFilter = function(icons, unit, icon, name)
  if(filters.list[core.playerClass].buffs[name]) then
    return true
  end
end

-- -----------------------------------
-- > PLAYER STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self, "main")

  -- Text strings
  core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, '[lumen:level]  [lumen:name] [lumen:classification]')
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, '[lumen:hpvalue]')
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Castbar
  if self.cfg.castbar.enable then
    core:CreateCastbar(self)
  end

  -- Class Icons
  if core.playerClass == 'ROGUE' or core.playerClass == 'DRUID' or core.playerClass == 'MAGE'
    or core.playerClass == 'MONK' or core.playerClass == 'PALADIN' or core.playerClass == 'WARLOCK' then
      CreateClassIcons(self)
  end

  -- Death Knight Runes
  if core.playerClass == 'DEATHKNIGHT' then CreateRuneBar(self) end

  -- Alternate Power Bar
  if core.playerClass == 'PRIEST' or core.playerClass == 'MONK' or core.playerClass == 'SHAMAN' then
    CreateAlternatePower(self)
  end

	-- AltPower (quest or boss special power)
	if cfg.elements.altpowerbar.show then
		CreateAltPowerBar(self)
	end

  -- Combat indicator
  local Combat = core:createFontstring(self, m.fonts.symbols, 40, "THINOUTLINE")
  Combat:SetPoint("RIGHT", self, "LEFT", -4, 1)
  Combat:SetText("Q")
  Combat:SetTextColor(255/255, 26/255, 48/255)
  self.Combat = Combat

  -- Resting
  local Resting = core:createFontstring(self.Health, font, cfg.fontsize -4, "THINOUTLINE")
  Resting:SetPoint("CENTER", self.Health, "TOP", 0, 0)
  Resting:SetText("zZz")
  Resting:SetTextColor(255/255, 255/255, 255/255, 0.70)
  self.Resting = Resting

  -- oUF_Experience
  if cfg.elements.experiencebar.show then
    local Experience = CreateFrame('StatusBar', nil, self, 'AnimatedStatusBarTemplate')
    Experience:SetStatusBarTexture(m.textures.status_texture)
    Experience:SetPoint(cfg.elements.experiencebar.pos.a1, cfg.elements.experiencebar.pos.af,
			cfg.elements.experiencebar.pos.a2, cfg.elements.experiencebar.pos.x, cfg.elements.experiencebar.pos.y)
    Experience:SetHeight(cfg.elements.experiencebar.height)
    Experience:SetWidth(cfg.elements.experiencebar.width)
    Experience:SetScript('OnEnter', UpdateExperienceTooltip)
    Experience:SetScript('OnLeave', GameTooltip_Hide)
    self.Experience = Experience

    local Rested = CreateFrame('StatusBar', nil, Experience)
    Rested:SetStatusBarTexture(m.textures.status_texture)
    Rested:SetAllPoints(Experience)
    core:setBackdrop(Rested, 2, 2, 2, 2)
    self.Experience.Rested = Rested

    local ExperienceBG = Rested:CreateTexture(nil, 'BORDER')
    ExperienceBG:SetAllPoints()
    ExperienceBG:SetAlpha(0.3)
    ExperienceBG:SetTexture(m.textures.bg_texture)
    ExperienceBG:SetColorTexture(1/3, 1/3, 1/3)
  end

  -- Heal Prediction
  CreateHealPrediction(self)

  -- BarTimers Auras
  local barTimers = auras:CreateBarTimer(self, 12, 12, 24, 4)
  barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, cfg.frames.secondary.height + 16)
  barTimers.initialAnchor = "BOTTOMLEFT"
  barTimers["growth-y"] = "UP"
  barTimers.CustomFilter = PlayerCustomFilter
  barTimers.PostUpdateIcon = PostUpdateBarTimer
  self.Buffs = barTimers

end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle("oUF_Lumen:"..frame:gsub("^%l", string.upper))
  oUF:Spawn(frame, "oUF_Lumen"..frame:gsub("^%l", string.upper))
end
