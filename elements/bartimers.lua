local _, ns = ...

local auras = ns.auras
local core, math, cfg, m, oUF = ns.core, ns.math, ns.cfg, ns.m, ns.oUF

local max = max

-- ------------------------------------------------------------------------
-- > BARTIME AURAS RELATED FUNCTIONS
-- ------------------------------------------------------------------------

function auras:BarTimer_OnUpdate(icon, elapsed)
	if icon.timeLeft then
		icon.timeLeft = max(icon.timeLeft - elapsed, 0)
		icon.bar:SetValue(icon.timeLeft) -- update the statusbar
		if icon.timeLeft > 0 and icon.timeLeft < 60 then
			icon.time:SetFormattedText(math:formatTime(icon.timeLeft))
			if (icon.timeLeft < 6) then
				icon.time:SetTextColor(0.9, 0.05, 0.05)
			else
				icon.time:SetTextColor(1, 1, 1)
			end
		else
			icon.time:SetText()
		end
	end
end

local PostCreateBar = function(Auras, button)
  button.icon:SetTexCoord(0, 1, 0, 1)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

	button.bar = CreateFrame('StatusBar', nil, button)
	button.bar:SetStatusBarTexture(m.textures.status_texture)
	button.bar:SetPoint("TOPLEFT", button, 'TOPRIGHT', 4, -2)
	button.bar:SetHeight(Auras.size - 4)
	button.bar:SetWidth(cfg.frames.main.width - Auras.size - 2)
	core:setBackdrop(button.bar, 2, 2, 2, 2)

	button.bar.bg = button.bar:CreateTexture(nil, 'BORDER')
	button.bar.bg:SetAllPoints()
	button.bar.bg:SetAlpha(0.3)
	button.bar.bg:SetTexture(m.textures.bg_texture)
	button.bar.bg:SetColorTexture(1/3, 1/3, 1/3)

	button.spell = button.bar:CreateFontString(nil, 'OVERLAY')
	button.spell:SetPoint("LEFT", button.bar, "LEFT", 4, 0)
	button.spell:SetFont(m.fonts.font_big, 16, "THINOUTLINE")
	button.spell:SetWidth(button.bar:GetWidth() - 25)
	button.spell:SetTextColor(1, 1, 1)
	button.spell:SetShadowOffset(1, -1)
	button.spell:SetShadowColor(0, 0, 0, 1)
	button.spell:SetJustifyH("LEFT")
	button.spell:SetWordWrap(false)

	button.time = button.bar:CreateFontString(nil, 'OVERLAY')
	button.time:SetPoint("RIGHT", button.bar, "RIGHT", -4, 0)
	button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
	button.time:SetTextColor(1, 1, 1)
	button.time:SetShadowOffset(1, -1)
	button.time:SetShadowColor(0, 0, 0, 1)
	button.time:SetJustifyH('RIGHT')

	button.count:ClearAllPoints()
	button.count:SetFont(m.fonts.font, 12, 'OUTLINE')
	button.count:SetPoint('TOPRIGHT', button, 3, 3)
end

function auras:CreateBarTimer(self, num, rows, size, spacing)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetSize( (num * (size + 9)) / rows, (size + 9) * rows)
	auras.num = num
	auras.size = size
	auras.spacing = spacing or 4
	auras.disableCooldown = true
	auras.PostCreateIcon = PostCreateBar
	return auras
end
