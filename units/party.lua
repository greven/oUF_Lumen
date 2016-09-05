local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

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

  -- Inverted Colors
  if cfg.units[frame].health.invertedColors then
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
    health.bg:SetVertexColor(.4, .4, .4)
    if disconnnected then
      self.status:SetText('DC')
    elseif dead then
      self.status:SetText('DEAD')
    elseif ghost then
      self.status:SetText('GHOST')
    end
  else
    health.value:Show()
    self.status:SetText('')
    if (min == max) then -- It has max health
      health.value:Hide()
    else
      health.value:Show()
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

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self, "secondary")

  -- Texts
  core:createPartyNameString(self, font_big, cfg.fontsize + 2)
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

  -- Ready Check Icon
  local ReadyCheck = self:CreateTexture()
  ReadyCheck:SetPoint('RIGHT', self, 'LEFT', 4, 0)
  ReadyCheck:SetSize(14, 14)
  ReadyCheck.finishedTimer = 10
  ReadyCheck.fadeTimer = 2
  self.ReadyCheck = ReadyCheck

  -- Role Icon
  local RoleIcon = self:CreateTexture(nil, 'OVERLAY')
  RoleIcon:SetPoint('RIGHT', self, 'LEFT', -8, 0)
  RoleIcon:SetSize(14, 14)
  RoleIcon:SetAlpha(0)
  self.LFDRole = RoleIcon

  -- Leader Icon
  local LeaderIcon = self:CreateTexture(nil, "OVERLAY")
  LeaderIcon:SetPoint("CENTER", self, "TOP", 0, 0)
  LeaderIcon:SetSize(14, 14)
  self.Leader = LeaderIcon

  self:HookScript('OnEnter', function() RoleIcon:SetAlpha(1) end)
  self:HookScript('OnLeave', function() RoleIcon:SetAlpha(0) end)

  -- Heal Prediction
  CreateHealPrediction(self)

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
		'yOffset', -6,
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', [[
			self:SetHeight(16)
			self:SetWidth(126)
		]]
	):SetPoint(cfg.units.party.pos.a1, cfg.units.party.pos.af, cfg.units.party.pos.a2, cfg.units.party.pos.x, cfg.units.party.pos.y)

end
