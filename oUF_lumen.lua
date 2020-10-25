-- ------------------------------------------------------------------------
-- > oUF Lumen (Kreoss @ Quel'Thalas EU) <
-- ------------------------------------------------------------------------
-- Version: 9.01
-- ------------------------------------------------------------------------

local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF
ns.lum, ns.oUF = lum, oUF

local font = m.fonts.font

-- -----------------------------------
-- > FRAMES STYLE
-- -----------------------------------

local OnEnter = function(self)
	self:SetAlpha(1) -- Player frame fading
	self.Highlight:Show() -- Mouseover highlight Show
	UnitFrame_OnEnter(self)
end

local OnLeave = function(self)
	if cfg.units.player.fader.enable then -- Player frame fading
		self:SetAlpha(cfg.units.player.fader.alpha)
	end

	self.Highlight:Hide() -- Mouseover highlight Hide
	UnitFrame_OnLeave(self)
end

function lum:SharedStyle(self, type)
	if (self.mystyle ~= "party" and self.mystyle ~= "raid" and self.mystyle ~= "boss" and self.mystyle ~= "arena") then
		self:SetSize(self.cfg.width, self.cfg.height)
		self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)
	end

	core:setBackdrop(self, 2, 2, 2, 2)

	self:RegisterForClicks("AnyDown")
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)

	self:SetScale(cfg.scale)

	-- HP Bar
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetHeight(self.cfg.height - cfg.frames[type].health.margin - self.cfg.power.height)
	self.Health:SetWidth(self.cfg.width)
	self.Health:SetPoint("TOP")
	self.Health:SetStatusBarTexture(m.textures.status_texture)
	self.Health:SetStatusBarColor(unpack(cfg.colors.health))
	self.Health:GetStatusBarTexture():SetHorizTile(false)

	self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetAlpha(0.1)
	self.Health.bg:SetTexture(m.textures.bg_texture)

	-- Power Bar
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetHeight(self.cfg.power.height)
	self.Power:SetWidth(self.cfg.width)
	self.Power:SetStatusBarTexture(m.textures.status_texture)
	self.Power:GetStatusBarTexture():SetHorizTile(false)
	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.frames[type].health.margin)

	self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(m.textures.bg_texture)
	self.Power.bg:SetAlpha(0.15)

	-- Colors
	if self.cfg.health.classColored then
		self.Health.colorClass = true
	end
	if self.cfg.health.reactionColored then
		self.Health.colorReaction = true
	end
	self.Health.colorDisconnected = true
	self.Health.colorTapping = true

	if self.cfg.power.classColored then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = false
	self.Power.colorHappiness = false

	-- Mouseover Highlight
	self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.Highlight:SetAllPoints(self)
	self.Highlight:SetTexture(m.textures.white_square)
	self.Highlight:SetVertexColor(1, 1, 1, .05)
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
