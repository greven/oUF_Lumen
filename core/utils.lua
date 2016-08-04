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

-- Create Border
function core:createBorder(self, frame, e_size, f_level, texture)
  local glowBorder = {edgeFile = texture, edgeSize = e_size}
  frame:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
  frame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
  frame:SetBackdrop(glowBorder)
  frame:SetFrameLevel(f_level)
  frame:Hide()
end

-- Create a Frame Shadow
function core:createDropShadow(f, point, edge, color)
  local s = CreateFrame("Frame", nil, f)
  s:SetFrameLevel(0)
  s:SetPoint("TOPLEFT", f, "TOPLEFT", -point, point)
  s:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", point, -point)
  s:SetBackdrop({
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
  s:SetBackdropColor(0, 0, 0, 0)
  s:SetBackdropBorderColor(unpack(color))
end
