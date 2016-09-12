local _, ns = ...

local core, cfg, m, oUF = ns.core, ns.cfg, ns.m, ns.oUF

-- ------------------------------------------------------------------------
-- > UTILITY FUNCTIONS
-- ------------------------------------------------------------------------

-- Convert color to HEX
function core:toHex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

-- Set the Backdrop
function core:setBackdrop(self, inset_l, inset_r, inset_t, inset_b)
  self:SetBackdrop {
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    tile = false,
    tileSize = 0,
    insets = {
      left = -inset_l,
      right = -inset_r,
      top = -inset_t,
      bottom = -inset_b
    }
  }
  self:SetBackdropColor(cfg.colors.backdrop.r, cfg.colors.backdrop.g, cfg.colors.backdrop.b, cfg.colors.backdrop.a)
end

-- Fontstring Function
function core:createFontstring(frame, font, size, outline, layer)
  local fs = frame:CreateFontString(nil, layer or "OVERLAY")
  fs:SetFont(font, size, outline)
  fs:SetShadowColor(0, 0, 0, 1)
	fs:SetShadowOffset(1, -1)
  return fs
end

-- Create a Frame Shadow
function core:createDropShadow(frame, point, edge, color)
  local shadow = CreateFrame("Frame", nil, frame)
  shadow:SetFrameLevel(0)
  shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -point, point)
  shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", point, -point)
  shadow:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = m.textures.glow_texture,
    tile = false,
    tileSize = 32,
    edgeSize = edge,
    insets = {
      left = -edge,
      right = -edge,
      top = -edge,
      bottom = -edge
    }
  })
  shadow:SetBackdropColor(0, 0, 0, 0)
  shadow:SetBackdropBorderColor(unpack(color))
end

-- Create Border
function core:createBorder(self, frame, e_size, f_level, texture)
  local glowBorder = {edgeFile = texture, edgeSize = e_size}
  frame:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
  frame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
  frame:SetBackdrop(glowBorder)
  frame:SetFrameLevel(f_level)
  frame:Hide()
end

-- Raid Frames Target Highlight Border
local function ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:SetBackdropBorderColor(.8, .8, .8, 1)
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

-- Create Target Border
function core:CreateTargetBorder(self)
	self.TargetBorder = CreateFrame("Frame", nil, self)
	core:createBorder(self, self.TargetBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")
	self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
end

-- Create Party / Raid health warning status border
function core:CreateHPBorder(self)
	self.HPborder = CreateFrame("Frame", nil, self)
	core:createBorder(self, self.HPborder, 1, 5, "Interface\\ChatFrame\\ChatFrameBackground")
	self.HPborder:SetBackdropBorderColor(180/255, 255/255, 0/255, 1)
end

-- Party / Raid Frames Threat Highlight
local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then return end

	local status = UnitThreatSituation(unit)
	unit = unit or self.unit

	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.ThreatBorder:Show()
		self.ThreatBorder:SetBackdropBorderColor(r, g, b, 1)
	else
		self.ThreatBorder:SetBackdropBorderColor(r, g, b, 0)
		self.ThreatBorder:Hide()
	end
end

-- Create Party / Raid Threat Status Border
function core:CreateThreatBorder(self)
	self.ThreatBorder = CreateFrame("Frame", nil, self)
	core:createBorder(self, self.ThreatBorder, 1, 4, "Interface\\ChatFrame\\ChatFrameBackground")
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end
