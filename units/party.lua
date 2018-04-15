local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
local auras, filters = ns.auras, ns.filters

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "party"

-- ------------------------------------------------------------------------
-- > BOSS UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local self = health.__owner
  local dead, disconnnected, ghost = UnitIsDead(unit), not UnitIsConnected(unit), UnitIsGhost(unit)
	local perc = math.floor(min / max * 100 + 0.5)

  -- Inverted Colors
  if cfg.units[frame].health.invertedColors then
    health:SetStatusBarColor(unpack(cfg.colors.health))
    health.bg:SetVertexColor(unpack(core:raidColor(unit)))
    health.bg:SetAlpha(0.9)
  end

  if cfg.units[frame].health.gradientColored then
    local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, .5,.9,0)
    health:SetStatusBarColor(r, g, b)
  end

  -- Show health value as the missing value
  health.value:SetText('-' .. core:shortNumber(max - min))

  if disconnnected or dead or ghost then
    health.value:Hide()
    self.HPborder:Hide()
    health.bg:SetVertexColor(.4, .4, .4)
    if disconnnected then
      self.status:SetText('DC')
    elseif dead then
      self.status:SetText('DEAD')
    elseif ghost then
      self.status:SetText('GHOST')
    end
  else -- Player alive and kicking!
    health.value:Show()
    self.status:SetText('')

    if (min == max) then -- It has max health
      health.value:Hide()
      self.HPborder:Hide()
    else
      health.value:Show()
      if perc < 35 then -- Show warning health border
        self.HPborder:Show()
      else
        self.HPborder:Hide()
      end
    end
  end
end

-- PostUpdate Power
local PostUpdatePower = function(power, unit, min, max)
  local dead, disconnnected, ghost = UnitIsDead(unit), not UnitIsConnected(unit), UnitIsGhost(unit)

  if disconnnected or dead or ghost then
			power:SetValue(max)
			if(dead) then
        power:SetStatusBarColor(1, 0, 0, .7)
      elseif(disconnnected) then
        power:SetStatusBarColor(.85, 1, 0, .7)
			elseif(ghost) then
				power:SetStatusBarColor(1, 1 , 1, .7)
			end
		else
			power:SetValue(min)
			if(unit == 'vehicle') then
				power:SetStatusBarColor(143/255, 194/255, 32/255)
			end
		end
end

-- Post Update Aura Icon
local PostUpdateIcon = function(element, unit, button, index)
	local name, _, _, count, type, duration, expirationTime, owner = UnitAura(unit, index, button.filter)

	if duration and duration > 0 then
		button.timeLeft = expirationTime - GetTime()
	else
		button.timeLeft = math.huge
	end

  local color = DebuffTypeColor[type or 'none']
	button.overlay:SetVertexColor(color.r, color.g, color.b)


	button:SetScript('OnUpdate', function(self, elapsed)
		auras:AuraTimer_OnUpdate(self, elapsed)
	end)
end

-- Filter Debuffs
local PartyDebuffsFilter = function(icons, unit, icon, name)
  if(filters.list.PARTY[name]) then -- Ignore debuffs in the party list
    return false
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self, "secondary")

  -- Texts
  core:createPartyNameString(self, font, cfg.fontsize - 2)
  if self.cfg.health.classColoredText then
    self:Tag(self.Name, '[raidcolor][lumen:name]')
  else
    self:Tag(self.Name, '[lumen:name]')
  end
  core:createHPString(self, font, cfg.fontsize - 2, "THINOUTLINE", 4, 0, "LEFT")

  self.status = core:createFontstring(self.Health, font, cfg.fontsize -4, "THINOUTLINE")
  self.status:SetPoint("CENTER", self.Health, "TOP", 0, -2)
  self.status:SetTextColor(255/255, 255/255, 255/255, 0.70)

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth
  self.Power.PostUpdate = PostUpdatePower

  -- Defuffs
  local debuffs = auras:CreateAura(self, 6, 1, self.cfg.height + 4, 2)
  debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 11)
  debuffs.initialAnchor = "BOTTOMLEFT"
  debuffs["growth-x"] = "RIGHT"
  debuffs.CustomFilter = PartyDebuffsFilter
  debuffs.PostUpdateIcon = PostUpdateIcon
  self.Debuffs = debuffs

  -- Ready Check Icon
  local ReadyCheck = self:CreateTexture()
  ReadyCheck:SetPoint('LEFT', self, 'RIGHT', 8, 0)
  ReadyCheck:SetSize(16, 16)
  ReadyCheck.finishedTimer = 10
  ReadyCheck.fadeTimer = 2
  self.ReadyCheckIndicator = ReadyCheck

  -- Role Icon
  local RoleIcon = self:CreateTexture(nil, 'OVERLAY')
  RoleIcon:SetPoint('RIGHT', self, 'LEFT', -8, 1)
  RoleIcon:SetSize(16, 16)
  RoleIcon:SetAlpha(0)
  self.GroupRoleIndicator = RoleIcon

  self:HookScript('OnEnter', function() RoleIcon:SetAlpha(1) end)
  self:HookScript('OnLeave', function() RoleIcon:SetAlpha(0) end)

  -- Leader Icon
  local LeaderIcon = self:CreateTexture(nil, "OVERLAY")
  LeaderIcon:SetPoint('RIGHT', self, 'LEFT', -8, 1)
  LeaderIcon:SetSize(16, 16)
  self.LeaderIndicator = LeaderIcon

  self:HookScript('OnEnter', function() LeaderIcon:SetAlpha(0) end)
  self:HookScript('OnLeave', function() LeaderIcon:SetAlpha(1) end)

  -- Heal Prediction
  CreateHealPrediction(self)

  -- Health warning border
  core:CreateHPBorder(self)

  -- Threat warning border
  core:CreateThreatBorder(self)

  self.Range = cfg.frames.range

end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle('oUF_Lumen:'..frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle('oUF_Lumen:'..frame:gsub("^%l", string.upper))

  local party = oUF:SpawnHeader(
    -- 'oUF_LumenParty', nil, 'solo', 'showSolo', true,  -- debug
    'oUF_LumenParty', nil, 'party',
		'showParty', true,
		'showRaid', false,
		'showPlayer', true,
		'yOffset', -24,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(cfg.units[frame].height, cfg.units[frame].width)
	):SetPoint(cfg.units[frame].pos.a1, cfg.units[frame].pos.af, cfg.units[frame].pos.a2, cfg.units[frame].pos.x, cfg.units[frame].pos.y)
end
