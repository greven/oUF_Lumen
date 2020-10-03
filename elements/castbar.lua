local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font

-- ------------------------------------------------------------------------
-- > CASTBARS
-- ------------------------------------------------------------------------

-- Castbar Custom Cast TimeText
local CustomCastTimeText = function(self, duration)
  self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
  if(self.__owner.mystyle == "player") then
    self.Max:SetText(("%.1f "):format(self.max))
  end
end

-- Castbar Check for Spell Interrupt
local CheckForSpellInterrupt = function (self, unit)
  local color = cfg.units[unit].castbar.color

  if unit == "vehicle" then unit = "player" end
  if(self.notInterruptible and UnitCanAttack("player", unit)) then
    self.Glowborder:SetBackdropBorderColor(255/255, 25/255, 25/255, 1)
    self.Glowborder:Show()
    self:SetStatusBarColor(0.3, 0.3, 0.3)
    -- self.Icon:SetDesaturated(true)
  else
    self.Glowborder:Hide()
    self:SetStatusBarColor(unpack(color))
    -- self.Icon:SetDesaturated(false)
  end
end

-- Castbar PostCast Update
local onPostCastStart = function(self, unit, name)
  if(unit == 'player') then
    self:SetStatusBarColor(unpack(cfg.units.player.castbar.color))
  end

  if(unit == 'target' or unit == 'focus') then
    CheckForSpellInterrupt(self, unit)
  end
end

-- Castbar PostCastChannel Update
local onPostChannelStart = function(self, unit, name)
  if(unit == 'target' or unit == 'focus') then
    CheckForSpellInterrupt(self, unit)
  end
end

local setInterruptIcon = function(self)
  core:setglowBorder(self)
  self.Glowborder:SetPoint("TOPLEFT", self, "TOPLEFT", - (self:GetHeight() + 2) - 6, 6) -- Resize to include icon
end

local OnPostCastInterrupted = function(self, unit)
  if(unit == 'player') then
    self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255)
  end
end

local OnUpdate = function(self, elapsed)
  if(self.casting) then
    self:SetAlpha(1)
		local duration = self.duration + elapsed
		if(duration >= self.max) then
			self.casting = nil
			self:Hide()

			if(self.PostCastStop) then self:PostCastStop(self.__owner.unit) end
			return
		end

		if(self.Time) then
			if(self.delay ~= 0) then
				if(self.CustomDelayText) then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText('%.1f|cffff0000-%.1f|r', duration, self.delay)
				end
			else
				if(self.CustomTimeText) then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText('%.1f', duration)
				end
			end
		end

		self.duration = duration
		self:SetValue(duration)

		if(self.Spark) then
			local horiz = self.horizontal
			local size = self[horiz and 'GetWidth' or 'GetHeight'](self)

			local offset = (duration / self.max) * size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
  elseif(self.channeling) then
    self:SetAlpha(1)
		local duration = self.duration - elapsed

		if(duration <= 0) then
			self.channeling = nil
			self:Hide()

			if(self.PostChannelStop) then self:PostChannelStop(self.__owner.unit) end
			return
		end

		if(self.Time) then
			if(self.delay ~= 0) then
				if(self.CustomDelayText) then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText('%.1f|cffff0000-%.1f|r', duration, self.delay)
				end
			else
				if(self.CustomTimeText) then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText('%.1f', duration)
				end
			end
		end

		self.duration = duration
		self:SetValue(duration)
		if(self.Spark) then
			local horiz = self.horizontal
			local size = self[horiz and 'GetWidth' or 'GetHeight'](self)

			local offset = (duration / self.max) * size
			if(self:GetReverseFill()) then
				offset = size - offset
			end

			self.Spark:SetPoint('CENTER', self, horiz and 'LEFT' or 'BOTTOM', horiz and offset or 0, horiz and 0 or offset)
		end
	elseif(self.holdTime > 0) then
    self.holdTime = self.holdTime - elapsed
    local alpha = self:GetAlpha() - 0.025
    if alpha > 0 then
      self:SetAlpha(alpha)
    end
	else
		self.casting = nil
		self.castID = nil
		self.channeling = nil

		self:Hide()
	end
end

-- Castbar generator
function core:CreateCastbar(self)
  local castbar = CreateFrame("StatusBar", "oUF_LumenCastBar", self)
  castbar:SetStatusBarTexture(m.textures.status_texture)
  castbar:GetStatusBarTexture():SetHorizTile(false)
  castbar:SetFrameStrata("HIGH")
  castbar:SetToplevel(true)

  castbar.bg = castbar:CreateTexture(nil, 'BORDER')
  castbar.bg:SetAllPoints()
  castbar.bg:SetAlpha(0.2)
  castbar.bg:SetTexture(m.textures.bg_texture)
  castbar.bg:SetColorTexture(0.2, 0.2, 0.2)

  castbar.Text = castbar:CreateFontString(nil, "OVERLAY")
  castbar.Text:SetTextColor(1, 1, 1)
  castbar.Text:SetShadowOffset(1, -1)
  castbar.Text:SetJustifyH("LEFT")
  castbar.Text:SetHeight(12)

  castbar.Time = castbar:CreateFontString(nil, "OVERLAY")
  castbar.Time:SetTextColor(1, 1, 1)
  castbar.Time:SetJustifyH("RIGHT")

  castbar.Icon = castbar:CreateTexture(nil, 'ARTWORK')
  castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  castbar.timeToHold = cfg.elements.castbar.timeToHold

  castbar.PostCastStart = onPostCastStart
  castbar.PostChannelStart = onPostChannelStart
  castbar.PostCastInterrupted = OnPostCastInterrupted
  castbar.OnUpdate = OnUpdate

  if(self.mystyle == "player") then
    core:setBackdrop(castbar, cfg.units.player.castbar.height + 4, 2, 2, 2)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.player.castbar.color))
    castbar:SetWidth(cfg.units.player.castbar.width - cfg.units.player.castbar.height + 6)
    castbar:SetHeight(cfg.units.player.castbar.height)
    castbar:SetPoint(cfg.units.player.castbar.pos.a1, cfg.units.player.castbar.pos.af,
      cfg.units.player.castbar.pos.a2, cfg.units.player.castbar.pos.x, cfg.units.player.castbar.pos.y)

    castbar.Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.player.castbar.width - 60)
    castbar.Text:SetPoint("LEFT", castbar, 4, 0)

    castbar.Time:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    castbar.Time:SetPoint("RIGHT", castbar, -6, 0)

    castbar.Max = castbar:CreateFontString(nil, "OVERLAY")
    castbar.Max:SetTextColor(150/255, 150/255, 150/255)
    castbar.Max:SetJustifyH("RIGHT")
    castbar.Max:SetFont(font, cfg.fontsize-1, "THINOUTLINE")
    castbar.Max:SetPoint("RIGHT", castbar.Time, "LEFT", 0, 0)
    castbar.CustomTimeText = CustomCastTimeText

    castbar.Icon:SetHeight(cfg.units.player.castbar.height)
    castbar.Icon:SetWidth(cfg.units.player.castbar.height)
    castbar.Icon:SetPoint("LEFT", castbar, -(cfg.units.player.castbar.height + 2), 0)

    -- Add safezone
    if(cfg.units.player.castbar.latency.show) then
      castbar.SafeZone = castbar:CreateTexture(nil, "OVERLAY")
      castbar.SafeZone:SetTexture(m.textures.status_texture)
      castbar.SafeZone:SetVertexColor(unpack(cfg.units.player.castbar.latency.color))
    end

  elseif(self.mystyle == "target") then
    core:setBackdrop(castbar, cfg.units.target.castbar.height + 4, 2, 2, 2)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.target.castbar.color))
    castbar:SetWidth(cfg.units.target.castbar.width - cfg.units.target.castbar.height + 6)
    castbar:SetHeight(cfg.units.target.castbar.height)
    castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 350)

    castbar.Text:SetFont(font, cfg.fontsize + 2, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.target.castbar.width - 60)
    castbar.Text:SetPoint("LEFT", castbar, 6, 0)

    castbar.Time:SetFont(font, cfg.fontsize + 2, "THINOUTLINE")
    castbar.Time:SetPoint("RIGHT", castbar, -6, 0)
    castbar.CustomTimeText = CustomCastTimeText

    castbar.Icon:SetHeight(cfg.units.target.castbar.height)
    castbar.Icon:SetWidth(cfg.units.target.castbar.height)
    castbar.Icon:SetPoint("LEFT", castbar, -(cfg.units.target.castbar.height + 2), 0)

    -- Interrupt
    setInterruptIcon(castbar)

  elseif(self.mystyle == "focus") then
    core:setBackdrop(castbar, cfg.units.focus.castbar.height + 4, 2, 2, 2)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.focus.castbar.color))
    castbar:SetWidth(cfg.units.focus.castbar.width - cfg.units.focus.castbar.height + 6)
    castbar:SetHeight(cfg.units.focus.castbar.height)
    castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 300)

    castbar.Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.focus.castbar.width - 60)
    castbar.Text:SetPoint("LEFT", castbar, 4, 0)

    castbar.Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
    castbar.Time:SetPoint("RIGHT", castbar, -6, 0)
    castbar.CustomTimeText = CustomCastTimeText

    castbar.Icon:SetHeight(cfg.units.focus.castbar.height)
    castbar.Icon:SetWidth(cfg.units.focus.castbar.height)
    castbar.Icon:SetPoint("LEFT", castbar, - (cfg.units.focus.castbar.height + 2), 0)

    -- Interrupt
    setInterruptIcon(castbar)

  elseif(self.mystyle == "boss") then
    core:setBackdrop(castbar, 2, 2, 2, 2)
    castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    castbar:SetStatusBarColor(unpack(cfg.units.boss.castbar.color))
    castbar:SetHeight(cfg.units.boss.height)
    castbar:SetPoint("LEFT", self, cfg.units.boss.height + 2, 0)
    castbar:SetPoint("TOPRIGHT", self, 0, 0)

    castbar.Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    castbar.Text:SetWidth(cfg.units.boss.width - 50)
    castbar.Text:SetPoint("LEFT", castbar, 4, 0)

    castbar.Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
    castbar.Time:SetPoint("RIGHT", castbar, -6, 0)
    castbar.CustomTimeText = CustomCastTimeText

    castbar.Icon:SetHeight(cfg.units.boss.height)
    castbar.Icon:SetWidth(cfg.units.boss.height)
    castbar.Icon:SetPoint("LEFT", self, 0, 0)
  end

  self.Castbar = castbar -- register with oUF
end

-- -----------------------------------
-- > MIRROR BARS
-- -----------------------------------

function core:MirrorBars()
for _, bar in pairs({'MirrorTimer1', 'MirrorTimer2', 'MirrorTimer3'}) do
    local bg = select(1, _G[bar]:GetRegions())
    bg:Hide()

    _G[bar]:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = false, tileSize = 0,
      insets = {top = -2, left = -2, bottom = -2, right = -2}})

    _G[bar]:SetBackdropColor(0, 0, 0, 1)

    _G[bar..'Border']:Hide()

    _G[bar]:SetParent(UIParent)
    _G[bar]:SetHeight(20)
    _G[bar]:SetWidth(152)

    _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
    _G[bar..'Background']:SetTexture('Interface\\Buttons\\WHITE8x8')
    _G[bar..'Background']:SetAllPoints(_G[bar])
    _G[bar..'Background']:SetVertexColor(0, 0, 0, 0.5)

    _G[bar..'Text']:SetFont(font, cfg.fontsize-1, "THINOUTLINE")
    _G[bar..'Text']:ClearAllPoints()
    _G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 0)

    _G[bar..'StatusBar']:SetStatusBarTexture('\Interface\\AddOns\\oUF_lumen\\media\\statusbar')

    _G[bar..'StatusBar']:SetAllPoints(_G[bar])
  end
end
