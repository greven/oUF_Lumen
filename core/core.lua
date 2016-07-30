local _, ns = ...

local core, cfg, oUF = CreateFrame("Frame"), ns.cfg, ns.oUF
ns.core = core

-- ------------------------------------------------------------------------
-- > MEDIA
-- ------------------------------------------------------------------------

core.media = {
  font = "Interface\\AddOns\\oUF_lumen\\media\\font.ttf",
  font_big = "Interface\\AddOns\\oUF_lumen\\media\\font2.ttf",
  status_texture = "Interface\\AddOns\\oUF_lumen\\media\\statusbar",
  fill_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture",
  bg_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture_bg",
  raid_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture",
  border = "Interface\\AddOns\\oUF_lumen\\media\\border",
  spark_texture = "Interface\\AddOns\\oUF_lumen\\media\\spark",
  white_square = "Interface\\AddOns\\oUF_lumen\\media\\white",
  glow_texture = "Interface\\AddOns\\oUF_lumen\\media\\glow"
}

-- ------------------------------------------------------------------------
-- > CORE FUNCTIONS
-- ------------------------------------------------------------------------

  -- -----------------------------------
  -- > PLAYER SPECIFIC
  -- -----------------------------------

  core.playerClass = select(2, UnitClass("player"))
  core.playerColor = RAID_CLASS_COLORS[core.playerClass]
  core.playerName  = UnitName("player")

  -- -----------------------------------
  -- > API
  -- -----------------------------------

  -- Get Unit Experience
  function core:getXp(unit)
    if(unit == 'pet') then
      return GetPetExperience()
    else
      return UnitXP(unit), UnitXPMax(unit)
    end
  end

  -- Unit has a Debuff
  function core:hasUnitDebuff(unit, name, myspell)
    local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
    if myspell then
      if (count and caster == 'player') then return count end
    else
      if count then return count end
    end
  end

  -- Class colors
  function core:raidColor(unit)
    return oUF.colors.class[core.playerClass]
  end

  -- -----------------------------------
  -- > PLUGINS
  -- -----------------------------------

  -- -----------------------------------
  -- > EXTRA FUNCTIONS
  -- -----------------------------------

  -- Generates the Name String
  function core:createNameString(self, font, size, outline, x, y, point, width)
    self.Name = core:createFontstring(self.Health, font, size, outline)
    self.Name:SetPoint(point, self.Health, x, y)
    self.Name:SetJustifyH(point)
    self.Name:SetWidth(width)
    self.Name:SetHeight(size)
    self:Tag(self.Name, '[lumen:name]')
  end

  function core:createHPString(self, font, size, outline, x, y, point)
		self.Health.value = core:createFontstring(self.Health, font, size, outline)
		self.Health.value:SetPoint(point, self.Health, x, y)
		self.Health.value:SetJustifyH(point)
		self.Health.value:SetTextColor(1,1,1)
    self:Tag(self.Health.value, '[lumen:hpvalue]')
	end

  function core:createHPPercentString(self, font, size, outline, x, y, point, layer)
    self.Health.percent = core:createFontstring(self.Health, font, size, outline, layer)
    self.Health.percent:SetPoint(point, self.Health.value, x, y)
    self.Health.percent:SetJustifyH("RIGHT")
    self.Health.percent:SetTextColor(0.5, 0.5, 0.5, 0.5)
    self.Health.percent:SetShadowColor(0, 0, 0, 0)
    self:Tag(self.Health.percent, '[lumen:hpperc]')
  end

  -- Generates the Power Percent String
  function core:createPowerString(self, font, size, outline, x, y, point)
    self.Power.value = core:createFontstring(self.Power, font, size, outline)
    self.Power.value:SetPoint(point, self.Power, x, y)
    self.Power.value:SetJustifyH(point)
    self:Tag(self.Power.value, '[lumen:powervalue]')
  end

  local OnEnter = function(self)
    self.Highlight:Show()  -- Mouseover highlight Show
    UnitFrame_OnEnter(self)
  end

  local OnLeave = function(self)
    self.Highlight:Hide()  -- Mouseover highlight Hide
    UnitFrame_OnLeave(self)
  end

  -- -----------------------------------
  -- > FRAMES STYLE
  -- -----------------------------------

  -- The Shared Style Function
  function core:globalStyle(self)
    self:SetScale(cfg.scale)
    core:setBackdrop(self, 2, 2, 2, 2)

    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", OnEnter)
    self:SetScript("OnLeave", OnLeave)

    -- HP Bar
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Health:SetStatusBarTexture(core.media.status_texture)
    self.Health:SetStatusBarColor(unpack(cfg.colors.health))
    self.Health:GetStatusBarTexture():SetHorizTile(false)
    self.Health:SetPoint("TOP")
    self.Health.frequentUpdates = true
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetAlpha(0.20)
    self.Health.bg:SetTexture(core.media.bg_texture)

    -- Power Bar
    self.Power = CreateFrame("StatusBar", nil, self)
    self.Power:SetStatusBarTexture(core.media.fill_texture)
    self.Power:GetStatusBarTexture():SetHorizTile(false)
    self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.frames.main.health.margin)
    self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
    self.Power.bg:SetAllPoints(self.Power)
    self.Power.bg:SetTexture(core.media.bg_texture)
    self.Power.bg:SetAlpha(0.20)

    -- Colors
    if self.cfg.health.classColored then self.Health.colorClass = true end
    if self.cfg.health.reactionColored then self.Health.colorReaction = true end
    self.Health.colorDisconnected = true
    self.Health.colorTapping = true

    if self.cfg.power.classColored then
      self.Power.colorClass = true
    else
      self.Power.colorPower = true
    end
    self.Power.colorTapping = true
    self.Power.colorDisconnected = true
    self.Power.colorHappiness = false

    -- Mouseover Highlight
    self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
    self.Highlight:SetAllPoints(self)
    self.Highlight:SetTexture(core.media.white_square)
    self.Highlight:SetVertexColor(1,1,1,.05)
    self.Highlight:SetBlendMode("ADD")
    self.Highlight:Hide()

    -- Smooth Update
    self.Health.Smooth = self.cfg.health.smooth
    self.Power.Smooth = self.cfg.power.smooth

    -- Drop Shadow
    if cfg.frames.shadow.show then
      core:createDropShadow(self, 5, 5, {0, 0, 0, cfg.frames.shadow.opacity})
    end
  end
