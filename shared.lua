-- ------------------------------------------------------------------------
-- > oUF Lumen (Kreoss @ Quel'Thalas EU) <
-- ------------------------------------------------------------------------
-- Version: 9.01
-- ------------------------------------------------------------------------

local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local font = m.fonts.font

-- -----------------------------------
-- > Shared Style Function
-- -----------------------------------

function lum:SharedStyle(self, frameType)
	local style = self.mystyle

	self:RegisterForClicks("AnyDown")

	if style ~= "party" and style ~= "raid" and style ~= "boss" and style ~= "arena" then
		self:SetSize(self.cfg.width, self.cfg.height)
		self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)
	end

	self:SetScale(cfg.scale)
	api:SetBackdrop(self, 2, 2, 2, 2)
	api:CreateDropShadow(self, 6, 6)

	lum:CreateHealthBar(self, frameType)
	lum:CreatePowerBar(self, frameType)

	lum:CreateMouseoverHighlight(self)
end
