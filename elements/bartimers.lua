local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

local max = max

-- ------------------------------------------------------------------------
-- > BarTimer Auras
-- ------------------------------------------------------------------------

local function OnUpdate(self, elapsed)
	if self.timeLeft then
		self.timeLeft = max(self.timeLeft - elapsed, 0)
		self.bar:SetValue(self.timeLeft) -- update the statusbar

		-- Colors
		if self.timeLeft > 0 and self.timeLeft < 60 then
			self.time:SetFormattedText(core:FormatTime(self.timeLeft))
			if self.timeLeft < 6 then
				self.bar:SetStatusBarColor(1, 0.2, 0.2)
				self.time:SetTextColor(1, 0.2, 0.2)
			elseif self.timeLeft < 11 then
				self.bar:SetStatusBarColor(1, 0.8, 0.2)
				self.time:SetTextColor(1, 0.8, 0.2)
			else
				self.time:SetTextColor(1, 1, 1)
			end
		elseif self.timeLeft > 60 and self.timeLeft < 60 * 5 then
			self.time:SetTextColor(0, 0.6, 1)
			self.time:SetFormattedText(core:FormatTime(self.timeLeft))
		else
			self.time:SetText()
		end

		if cfg.elements.barTimers.colorGradient then
			local color = CreateColor(oUF:ColorGradient(self.timeLeft, self.duration, 1, 0.2, 0.2, 1, 0.75, 0.25, 0.2, 0.2, 0.2))
			self.bar:SetStatusBarColor(color:GetRGB())
		end
	end
end

local PostUpdateBar = function(element, unit, button, index)
	local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, button.filter)

	if duration and duration > 0 then
		button.timeLeft = expirationTime - GetTime()
		button.duration = duration

		button.bar:SetMinMaxValues(0, duration)
		button.bar:SetValue(button.timeLeft)

		-- Bar color
		if button.isDebuff then
			if cfg.elements.barTimers.colorDebuffsByType then
				if dtype then
					local color = oUF.colors.debuff[dtype]
					button.bar:SetStatusBarColor(color[1], color[2], color[3])
				else
					button.bar:SetStatusBarColor(unpack(oUF.colors.debuff.none))
				end
			else
				button.bar:SetStatusBarColor(unpack(cfg.elements.barTimers.defaultDebuffColor))
			end
		else -- Buffs
			if cfg.elements.barTimers.colorBuffsByClass then
				button.bar:SetStatusBarColor(unpack(core:RaidColor(unit)))
			else
				button.bar:SetStatusBarColor(unpack(cfg.elements.barTimers.defaultBuffColor))
			end
		end
	else
		-- Permanent buff / debuff
		button.timeLeft = math.huge
		button.bar:SetStatusBarColor(0.6, 0.2, 0.8)
	end

	-- Spell name
	button.spell:SetText(name)

	button:SetScript("OnUpdate", OnUpdate)
end

local function SortAuras(a, b)
	if a and b and a.timeLeft and b.timeLeft then
		return a.timeLeft > b.timeLeft
	end
end

local function PreSetPosition(self)
	table.sort(self, SortAuras)
	return 1
end

local function PostCreateBar(self, button)
	button.icon:SetTexCoord(0, 1, 0, 1)

	button.overlay:SetTexture(m.textures.border)
	button.overlay:SetTexCoord(0, 1, 0, 1)
	button.overlay.Hide = function(self)
		self:SetVertexColor(0.15, 0.15, 0.15)
	end

	button.bar = CreateFrame("StatusBar", nil, button)
	button.bar:SetStatusBarTexture(m.textures.status_texture)
	button.bar:SetWidth(cfg.frames.main.width - self.size - 2)

	button.bar.bg = button.bar:CreateTexture(nil, "BORDER")
	button.bar.bg:SetAllPoints()
	button.bar.bg:SetAlpha(0.05)
	button.bar.bg:SetTexture(m.textures.bg_texture)
	button.bar.bg:SetColorTexture(1 / 3, 1 / 3, 1 / 3)

	button.spell = button.bar:CreateFontString(nil, "OVERLAY")

	button.spell:SetWidth(button.bar:GetWidth() - 25)
	button.spell:SetTextColor(1, 1, 1)
	button.spell:SetShadowOffset(1, -1)
	button.spell:SetShadowColor(0, 0, 0, 1)
	button.spell:SetJustifyH("LEFT")
	button.spell:SetWordWrap(false)

	button.time = button.bar:CreateFontString(nil, "OVERLAY")
	button.time:SetTextColor(1, 1, 1)
	button.time:SetShadowOffset(1, -1)
	button.time:SetShadowColor(0, 0, 0, 1)
	button.time:SetJustifyH("RIGHT")

	button.count:ClearAllPoints()
	button.count:SetFont(m.fonts.font, 12, "OUTLINE")
	button.count:SetPoint("TOPRIGHT", button, 3, 3)

	if cfg.elements.barTimers.theme == "thin" then
		button.bar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 4, 1)
		button.bar:SetHeight(2)
		button.spell:SetPoint("LEFT", button.bar, "LEFT", 0, 12)
		button.spell:SetFont(m.fonts.font, 14, "THINOUTLINE")
		button.time:SetPoint("RIGHT", button.bar, "RIGHT", 0, 12)
		button.time:SetFont(m.fonts.font, 14, "THINOUTLINE")
		api:SetBackdrop(button.bar, 1.5, 1.5, 1.5, 1.5)
	else
		button.bar:SetPoint("TOPLEFT", button, "TOPRIGHT", 4, -2)
		button.bar:SetHeight(self.size - 4)
		button.spell:SetPoint("LEFT", button.bar, "LEFT", 4, 0)
		button.spell:SetFont(m.fonts.font, 16, "THINOUTLINE")
		button.time:SetPoint("RIGHT", button.bar, "RIGHT", -4, 1)
		button.time:SetFont(m.fonts.font, 12, "THINOUTLINE")
		api:SetBackdrop(button.bar, 2, 2, 2, 2)
	end
end

function lum:CreateBarTimer(self, num, rows, size, spacing)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetSize((num * (size + 9)) / rows, (size + 9) * rows)
	auras.num = num
	auras.size = size
	auras.spacing = spacing or 4
	auras.disableCooldown = true
	auras.PreSetPosition = PreSetPosition -- Sort auras by time remaining
	auras.PostCreateIcon = PostCreateBar -- Set overlay, cd, count, timer
	auras.PostUpdateIcon = PostUpdateBar
	return auras
end
