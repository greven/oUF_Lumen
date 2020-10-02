-- ------------------------------------------------------------------------
-- > oUF Lumen (Kreoss @ Quel'Thalas / Jaednar EU) <
-- ------------------------------------------------------------------------
-- Version: 7.0
-- ------------------------------------------------------------------------

local _, ns = ...

local lum = CreateFrame("Frame", "oUF_lumen")
local core, cfg, m, oUF = ns.core, ns.cfg, ns.m, ns.oUF or oUF
ns.lum, ns.oUF = lum, oUF

local font = m.fonts.font

-- -----------------------------------
-- > HEAL PREDICTION
-- -----------------------------------

function CreateHealPrediction(self)
	local myBar = CreateFrame("StatusBar", nil, self.Health)
	myBar:SetPoint("TOP")
	myBar:SetPoint("BOTTOM")
	myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
	myBar:SetWidth(self.cfg.width)
	myBar:SetStatusBarTexture(m.textures.status_texture)
	myBar:SetStatusBarColor(125 / 255, 255 / 255, 50 / 255, .4)

	local otherBar = CreateFrame("StatusBar", nil, self.Health)
	otherBar:SetPoint("TOP")
	otherBar:SetPoint("BOTTOM")
	otherBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
	otherBar:SetWidth(self.cfg.width)
	otherBar:SetStatusBarTexture(m.textures.status_texture)
	otherBar:SetStatusBarColor(100 / 255, 235 / 255, 200 / 255, .4)

	local absorbBar = CreateFrame("StatusBar", nil, self.Health)
	absorbBar:SetPoint("TOP")
	absorbBar:SetPoint("BOTTOM")
	absorbBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
	absorbBar:SetWidth(self.cfg.width)
	absorbBar:SetStatusBarTexture(m.textures.status_texture)
	absorbBar:SetStatusBarColor(180 / 255, 255 / 255, 205 / 255, .35)

	local healAbsorbBar = CreateFrame("StatusBar", nil, self.Health)
	healAbsorbBar:SetPoint("TOP")
	healAbsorbBar:SetPoint("BOTTOM")
	healAbsorbBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
	healAbsorbBar:SetWidth(self.cfg.width)
	healAbsorbBar:SetStatusBarTexture(m.textures.status_texture)
	healAbsorbBar:SetStatusBarColor(183 / 255, 244 / 255, 255 / 255, .35)

	-- Register with oUF
	self.HealthPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		healAbsorbBar = healAbsorbBar,
		maxOverflow = 1.00,
		frequentUpdates = true
	}
end

-- -----------------------------------
-- > BarTimers
-- -----------------------------------

function CreateBarTimers(self, num, width, height, spacing)
	local bars = CreateFrame("Frame", nil, self)
	bars.num = num
	bars.width = width
	bars.height = height
	bars.spacing = spacing or 9
	bars:SetSize(width + 4, num * (height + spacing + 4))
	-- bars.PostCreateBar = PostCreateBar
	return bars
end

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

-- The Shared Style Function
function lum:globalStyle(self, type)
	if (self.mystyle ~= "party" and self.mystyle ~= "raid" and self.mystyle ~= "boss" and self.mystyle ~= "arena") then
		self:SetSize(self.cfg.width, self.cfg.height)
		self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)
	end

	core:setBackdrop(self, 2, 2, 2, 2)

	self:RegisterForClicks("AnyDown")
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)

	-- HP Bar
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetHeight(self.cfg.height - cfg.frames[type].health.margin - self.cfg.power.height)
	self.Health:SetWidth(self.cfg.width)
	self.Health:SetPoint("TOP")
	self.Health:SetStatusBarTexture(m.textures.status_texture)
	self.Health:SetStatusBarColor(unpack(cfg.colors.health))
	self.Health:GetStatusBarTexture():SetHorizTile(false)
	self.Health.frequentUpdates = self.cfg.health.frequentUpdates

	self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetAlpha(0.125)
	self.Health.bg:SetTexture(m.textures.bg_texture)

	-- Power Bar
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetHeight(cfg.frames[type].power.height)
	self.Power:SetWidth(self.cfg.width)
	self.Power:SetStatusBarTexture(m.textures.status_texture)
	self.Power:GetStatusBarTexture():SetHorizTile(false)
	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.frames.main.health.margin)
	-- self.Power.frequentUpdates = self.cfg.power.frequentUpdates
	self.Power.frequentUpdates = false

	self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(m.textures.bg_texture)
	self.Power.bg:SetAlpha(0.20)

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
	self.Power.colorDisconnected = true
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

	-- Mirror bars
	core:MirrorBars()

	-- Drop Shadow
	if cfg.frames.shadow.show then
		core:createDropShadow(self, 5, 5, {0, 0, 0, cfg.frames.shadow.opacity})
	end
end
