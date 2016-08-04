local _, ns = ...

local auras = CreateFrame("Frame")
ns.auras = auras

local core, math, cfg, m, oUF = ns.core, ns.math, ns.cfg, ns.m, ns.oUF

local max = max

-- ------------------------------------------------------------------------
-- > AURAS RELATED FUNCTIONS
-- ------------------------------------------------------------------------

function auras:AuraTimer_OnUpdate(icon, elapsed)
	if icon.timeLeft then
		icon.timeLeft = max(icon.timeLeft - elapsed, 0)
		if icon.timeLeft > 0 and icon.timeLeft < 60 then
			icon.time:SetFormattedText(math:formatTime(icon.timeLeft))
			if (icon.timeLeft < 6) then
				icon.time:SetTextColor(0.9, 0.05, 0.05)
			else
				icon.time:SetTextColor(1, 1, 0.60)
			end
		else
			icon.time:SetText()
		end
	end
end

local PostCreateIcon = function(Auras, button)
	local count = button.count
	count:ClearAllPoints()
	count:SetFont(m.fonts.font, 12, 'OUTLINE')
	count:SetPoint('TOPRIGHT', button, 3, 3)

  button.icon:SetTexCoord(.07, .93, .07, .93)

  button.overlay:SetTexture(m.textures.border)
  button.overlay:SetTexCoord(0, 1, 0, 1)
  button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

	button.time = button:CreateFontString(nil, 'OVERLAY')
	button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
	button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
	button.time:SetTextColor(1, 1, 0.65)
	button.time:SetShadowOffset(1, -1)
	button.time:SetShadowColor(0, 0, 0, 1)
	button.time:SetJustifyH('CENTER')
end

function auras:CreateAura(self, num, rows, size, spacing)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetSize( (num * (size + 9)) / rows, (size + 9) * rows)
	auras.num = num
	auras.size = size
	auras.spacing = spacing or 9
	auras.disableCooldown = true
	auras.PostCreateIcon = PostCreateIcon
	return auras
end
