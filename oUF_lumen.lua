-- ------------------------------------------------------------------------
-- > oUF Lumen (Kreoss @ Jaednar EU) <
-- ------------------------------------------------------------------------
-- Credits: Hypocrisy, P3lim, Dawn, haste, kingamajick and zork.
-- ------------------------------------------------------------------------

	local addon, ns = ...
	local oUF = ns.oUF or oUF
	local cfg = ns.cfg
	local filters = ns.filters
	local colors = ns.colors

	local lum = CreateFrame("Frame", nil, self)

-- ------------------------------------------------------------------------
-- > 1. Media
-- ------------------------------------------------------------------------

	local font = "Interface\\AddOns\\oUF_lumen\\media\\font.ttf"
	local fill_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture"
	local bg_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture_bg"
	local raid_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture"
	local border = "Interface\\AddOns\\oUF_lumen\\media\\border"
	local spark_texture = "Interface\\AddOns\\oUF_lumen\\media\\spark"
	local white_square = "Interface\\AddOns\\oUF_lumen\\media\\white"
	local glow_texture = "Interface\\AddOns\\oUF_lumen\\media\\glow"

-- ------------------------------------------------------------------------
-- > 2. Miscellaneous
-- ------------------------------------------------------------------------

	local PlayerClass = select(2, UnitClass("player"))

	local exp_shift = 0 -- Used to shift elements if Experience Bar is showing
	local rep_shift = 0 -- Used to shift elements if Reputation Bar is showing

	local function raidColor(unit)

		local _, class = UnitClass(unit)
		return oUF.colors.class[class]
	end

	local Outline = "THINOUTLINE" -- Font Outline

	-- Colors

	oUF.colors.power = {
		["MANA"] = {26/255, 160/255, 255/255},
		["RAGE"] = {255/255, 26/255, 48/255},
		["FOCUS"] = {255/255, 192/255, 0/255},
		["ENERGY"] = {255/255, 225/255, 26/255},
		["HAPPINESS"] = {0.00, 1.00, 1.00},
		["RUNES"] = {0.50, 0.50, 0.50},
		["RUNIC_POWER"] = {0.00, 0.82, 1.00},
		["AMMOSLOT"] = {0.80, 0.60, 0.00},
		["FUEL"] = {0.0, 0.55, 0.5},
		["HOLY_POWER"] = {0.96, 0.55, 0.73},
		["SOUL_SHARDS"] = {117/255, 82/255, 221/255},
	}

	oUF.colors.happiness = {
		[1] = {182/225, 34/255, 32/255},
		[2] = {220/225, 180/225, 52/225},
		[3] = {143/255, 194/255, 32/255},
	}

	oUF.colors.reaction = {
		[1] = {182/255, 34/255, 32/255},
		[2] = {182/255, 34/255, 32/255},
		[3] = {182/255, 92/255, 32/255},
		[4] = {220/225, 180/255, 52/255},
		[5] = {143/255, 194/255, 32/255},
		[6] = {143/255, 194/255, 32/255},
		[7] = {143/255, 194/255, 32/255},
		[8] = {143/255, 194/255, 32/255},
	}

	oUF.colors.smooth = {1, 0, 0, 1, 1, 0, 1, 1, 1} -- R -> Y -> W
	oUF.colors.smoothG = {1, 0, 0, 1, 1, 0, 0, 1, 0} -- R -> Y -> G
	oUF.colors.runes = {{196/255, 30/255, 58/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}

	local Whitelist = filters.Whitelist -- WhiteList for BarTimers
	local ISpells = filters.IndicatorsSpells -- WhiteList for Corner Indicators Spells
	local IconDebuffs = filters.IconDebuffs

-- ------------------------------------------------------------------------
-- > 3. Functions
-- ------------------------------------------------------------------------

	-- Dummy Function
	local noop = function() return end

	local function UpdateAnchors()

		if not InCombatLockdown() then

			if(IsAddOnLoaded('oUF_Experience') and UnitLevel('player') < MAX_PLAYER_LEVEL) then
				exp_shift = cfg.expbar_height + 6
			else
				exp_shift = 0
			end

			local isWatched = GetWatchedFactionInfo()

			if(IsAddOnLoaded('oUF_Reputation') and isWatched ~= nil) then
				rep_shift = cfg.repbar_height + 5
			else
				rep_shift = 0
			end

			-- Anchors
			if(cfg.show_FocusFrame and oUF_lumenFocus) then
				oUF_lumenFocus:SetPoint("TOPLEFT", oUF_lumenPlayer, "TOPLEFT", 0, cfg.secondaryframe_height + cfg.InforBar_height + cfg.InforBar_shift + exp_shift + 8)
			end

			if(cfg.show_PetFrame and oUF_lumenPet) then
				oUF_lumenPet:SetPoint("BOTTOMLEFT", oUF_lumenPlayer, cfg.pet_x, cfg.pet_y - rep_shift)
			end

			if(cfg.show_PetTargetFrame and oUF_lumenPettarget) then
				oUF_lumenPettarget:SetPoint("BOTTOMRIGHT", oUF_lumenPlayer, cfg.pett_x, cfg.pett_y - rep_shift)
			end

			if(cfg.show_player_debuffs and lumenplayerDebuffs) then
				lumenplayerDebuffs:SetPoint("BOTTOMLEFT", oUF_lumenPlayer, "BOTTOMLEFT", -2, -53 - rep_shift)
			end

			if(cfg.show_BarTimers and playerAuraWatchers) then
				playerAuraWatchers:SetPoint("BOTTOMLEFT", oUF_lumenPlayer, "BOTTOMLEFT", 0, cfg.mainframe_height + cfg.secondaryframe_height + cfg.InforBar_height + cfg.BarTimers_height + cfg.InforBar_shift + 3 + exp_shift)
			end
		end
	end

	-- Right Click Menu
	local SpawnMenu = function(self)
		local unit = self.unit:sub(1, -2)
		local cunit = self.unit:gsub("^%l", string.upper)

		if(cunit == 'Vehicle') then
			cunit = 'Pet'
		end

		if(unit == "party" or unit == "partypet") then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
		elseif(_G[cunit.."FrameDropDown"]) then
			ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
		end
	end

	-- Shortens Numbers
	local ShortNumber = function(num)

		if(num >= 1e6) then
			return (math.floor((num/1e6)*10 + 0.5))/10 .."|cffb3b3b3m"
		elseif(num >= 1e4) then
			return (math.floor((num/1e3)*10 + 0.5))/10 .."|cffb3b3b3k"
		else
			return num
		end
	end

	-- Format Time
	local FormatTime = function(t)

		if t >= 86400 then -- Days
			return format("%d|cff999999d|r", floor(t/86400 + 0.5))
		elseif t >= 3600 then -- Hours
			return format("%d|cff999999h|r", floor(t/3600 + 0.5))
		elseif t >= 60 then -- Minutes
			return format("%d|cff999999m|r", floor(t/60 + 0.5))
		elseif t >= 0 then -- Seconds
			return floor(mod(t, 60))
		end
	end

	-- Create the Backdrop
	local function SetBackdrop(self, inset_l, inset_r, inset_t, inset_b)

		self:SetBackdrop {bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = false, tileSize = 0, insets = {left = -inset_l, right = -inset_r, top = -inset_t, bottom = -inset_b},}
		self:SetBackdropColor(cfg.bdc.r,cfg.bdc.g,cfg.bdc.b,cfg.bdc.a)
	end

	-- Fontstring Function
  	local createFontstring = function(fr, font, size, outline)

    	local fs = fr:CreateFontString(nil, "OVERLAY")
    	fs:SetFont(font, size, outline)
    	fs:SetShadowColor(0,0,0,1)
    	return fs
  	end

	-- Generates the Name String
	local createNameString = function (s, font, size, outline, x, y, point, wd)

		s.Name = createFontstring(s.Health, font, size+1, outline)
		s.Name:SetPoint(point, s.Health, x, y)
		s.Name:SetJustifyH(point)
		s.Name:SetWidth(wd)
		s.Name:SetHeight(size)
		s:Tag(s.Name, '[lumen:name]')
	end

	-- Generates the Health Value String
	local createHPString = function (s, font, size, outline, x, y, point)

		s.Health.value = createFontstring(s.Health, font, size, outline)
		s.Health.value:SetPoint(point, s.Health, x, y)
		s.Health.value:SetJustifyH(point)
		s.Health.value:SetTextColor(1,1,1)
		s.Health.value:SetShadowOffset(1,-1)
	end

	-- Generates the Health Percent String
	local createPercentString = function (s, font, size, outline, x, y, point, align)

		s.Health.percent = createFontstring(s.Health, font, size, outline)
		s.Health.percent:SetPoint(align, s, point, x, y)
		s.Health.percent:SetShadowOffset(1,-1)
	end

	-- Generates the Power Value String
	local createPPString = function (s, font, size, outline, x, y, point)

		s.Power.value = createFontstring(s.Power, font, size, outline)
		s.Power.value:SetPoint(point, s.Power, x, y)
		s.Power.value:SetJustifyH(point)
	end

	-- Generates the Power Percent String
	local createPercentPPString = function (s, font, size, outline, x, y, point)

		s.Power.percent = createFontstring(s.Power, font, size, outline)
		s.Power.percent:SetPoint(point, s.Power, x, y)
		s.Power.percent:SetJustifyH(point)
	end

	-- Experience Bar Post Update
	local ExperiencePostUpdate = function (Experience, unit, min, max)

		local exhaustion = GetXPExhaustion()
		if(Experience.Rested) then
			Experience.exhaustion = exhaustion
		end
	end

	-- Experience Bar Pre Update
	local ExperiencePreUpdate = function (Experience, unit, min, max)

		if unit == 'vehicle' then
			Experience.Rested:SetBackdropColor(cfg.bdc.r,cfg.bdc.g,cfg.bdc.b,0)
		else
			Experience.Rested:SetBackdropColor(cfg.bdc.r,cfg.bdc.g,cfg.bdc.b,0.8)
		end
	end

	-- Get Unit Experience
	local function xp(unit)

		if(unit == 'pet') then
			return GetPetExperience()
		else
			return UnitXP(unit), UnitXPMax(unit)
		end
	end

	-- Game Tooltip for oUF_Experience
	local function XPTooltip(self)

		local unit = self.__owner.unit
		local min, max = xp(unit)

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, -3)
		GameTooltip:AddLine(format('|cffb235f0XP: %d / %d (%d%%)', min, max, min / max * 100))
		if(self.exhaustion) then
			GameTooltip:AddLine(format('|cff1369caRested: %d (%d%%)', self.exhaustion, self.exhaustion / max * 100))
		end
		GameTooltip:Show()
	end

	-- Reputation Bar Post Update
	local ReputationPostUpdate = function(Reputation)

		if(IsAddOnLoaded('oUF_Reputation')) then
			-- Color the Reputation Bar accordingto standing color
			local _, standing  = GetWatchedFactionInfo()
			local color = FACTION_BAR_COLORS[standing]
			Reputation:SetStatusBarColor(color.r,color.g,color.b)
		end
	end

	-- Game Tooltip for oUF_Reputation
	local function RepTooltip(self)

		if(IsAddOnLoaded('oUF_Reputation')) then
			local name, standing, min, max, value = GetWatchedFactionInfo()
			local color = FACTION_BAR_COLORS[standing]

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 5, 3)
			GameTooltip:AddLine(format('|cff%02x%02x%02x%s|r', color.r*255,color.g*255,color.b*255,name))
			GameTooltip:AddLine(format('|cffcecece%s:|r |cffb7b7b7%d / %d|r', _G["FACTION_STANDING_LABEL"..standing], value - min, max - min))
			GameTooltip:Show()
		end
	end

	-- Create Border
	local function createBorder(self, f, e_size, f_level, texture)

		local glowBorder = {edgeFile = texture, edgeSize = e_size}
		f:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
		f:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
		f:SetBackdrop(glowBorder)
		f:SetFrameLevel(f_level)
		f:Hide()
	end

	-- Create Glow Border
	local function Glowborder(self)

		self.Glowborder = CreateFrame("Frame", nil, self)
		self.Glowborder:SetFrameLevel(0)
		self.Glowborder:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
		self.Glowborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
		self.Glowborder:SetBackdrop({bgFile = white_square, edgeFile =  glow_texture, tile = false, tileSize = 16, edgeSize = 4, insets = {left = -4, right = -4, top = -4, bottom = -4}})
		self.Glowborder:SetBackdropColor(0, 0, 0, 0)
		self.Glowborder:SetBackdropBorderColor(0, 0, 0, 1)
	end

	-- Create Raid Health warning Status Border
	local function CreateHPBorder(self)

		self.HPborder = CreateFrame("Frame", nil, self)
		createBorder(self, self.HPborder, 1, 5, "Interface\\ChatFrame\\ChatFrameBackground")
	end

	-- Create Raid Threat Status Border
	local function CreateThreatBorder(self)

		self.Thtborder = CreateFrame("Frame", nil, self)
		createBorder(self, self.Thtborder, 1, 4, "Interface\\ChatFrame\\ChatFrameBackground")

		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	end

	-- Create Target Border
	local function CreateTargetBorder(self)

		self.Targetborder = CreateFrame("Frame", nil, self)
		createBorder(self, self.Targetborder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")

		self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
		self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
	end

	-- Create a Frame Shadow
	local function CreateDropShadow(f,point,edge,color)

		local s = CreateFrame("Frame", nil, f)
		s:SetFrameLevel(0)
		s:SetPoint("TOPLEFT",f,"TOPLEFT", -point, point)
		s:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT", point, -point)
		s:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = glow_texture, tile = false, tileSize = 32, edgeSize = edge, insets = {left = -edge, right = -edge, top = -edge, bottom = -edge}})
		s:SetBackdropColor(0, 0, 0, 0)
		s:SetBackdropBorderColor(unpack(color))
	end

	-- Post Health Update
	local PostUpdateHP = function(health, unit, min, max)
		local self = health.__owner
		local disconnnected = not UnitIsConnected(unit)
		local dead = UnitIsDead(unit)
		local ghost = UnitIsGhost(unit)

		if cfg.useClassColoredNames then self.Name:SetTextColor(unpack(raidColor(unit))) end

		if (disconnnected) or UnitIsDead(unit) or UnitIsGhost(unit) then

			health:SetValue(0)

			if(disconnnected and unit == "target") then
				health.value:SetText(0)
				health.percent:SetText "dc"
				health.percent:SetTextColor(.8,.8,.8)
			elseif(ghost and (unit == "player" or unit == "target")) then
				health.value:SetText(0)
				health.percent:SetText"ghost"
				health.percent:SetTextColor(.8,.8,.8)
			elseif(dead and (unit == "player" or unit == "target")) then
				health.value:SetText(0)
				health.percent:SetText"dead"
				health.percent:SetTextColor(.7,.7,.7)
			end
		else
			if (min ~= max) then
				local r, g, b = oUF.ColorGradient(min, max, unpack(oUF.colors.smooth))
				if(unit == "player" or unit == "target") then
					health.value:SetText(ShortNumber(min))
					health.percent:SetText(floor(min / max * 100).."%")
					health.percent:SetTextColor(r,g,b)
				elseif(unit == "targettarget" or unit == "focus") then
					health.value:SetText(floor(min / max * 100).."%")
				end
			elseif (min == max) then
				if(unit == "player" or unit == "target") then
					health.value:SetText(ShortNumber(min))
					health.percent:SetText()
				elseif(unit == "targettarget" or unit == "focus") then
					health.value:SetText(floor(min / max * 100).."%")
				end
			end
		end
	end

	-- Post Power Update
	local PostUpdatePower = function(power, unit, min, max)

		if(unit == "player" or unit == "target") then
			if(not UnitIsPlayer(unit)) then
				power.value:SetText()
				power.percent:SetText()
			else
				local _, ptype = UnitPowerType(unit)

				if(ptype == "MANA") then
					if(min == max) then
						power.value:SetText()
						power.percent:SetText()
					elseif(min ~= max) then
						local r, g, b = oUF.ColorGradient(min, max, unpack(oUF.colors.smooth))
						power.value:SetText(min)
						power.percent:SetText(floor(min / max * 100).."%")
						power.percent:SetTextColor(r,g,b)
					end
				elseif(ptype == "FOCUS" or ptype == "ENERGY") then
					if(min == max) then
						power.value:SetText()
						power.percent:SetText()
					elseif(min ~= max) then
						power.value:SetText(min)
						power.percent:SetText()
					end
				elseif(ptype == "RAGE" or ptype == "RUNIC_POWER") then
					if(min == 0) then
						power.value:SetText()
						power.percent:SetText()
					elseif(min ~= 0) then
						power.value:SetText(min)
						power.percent:SetText()
					end
				end
			end
		end
	end

	-- Post Update for Raid Frame (Text, Colors...)
	local PostUpdateRaidFrame = function(health, unit, min, max)

		local self = health.__owner
		local _, class = UnitClass(unit)
		-- local name = UnitName(unit)
		local name = oUF.Tags.Methods['lumen:name'](unit)
		local rColor = raidColor(unit)
		local disconnnected = not UnitIsConnected(unit)
		local dead = UnitIsDead(unit)
		local ghost = UnitIsGhost(unit)
		local isPlayer = UnitIsPlayer(unit)

		if cfg.userGradientColor then
			local r, g, b = oUF.ColorGradient(min, max, unpack(oUF.colors.smoothG))
			if(cfg.hp_inverted) then
				health.bg:SetVertexColor(r,g,b)
			else
				health:SetStatusBarColor(r,g,b,1)
			end
		end

		if(cfg.hp_inverted) then health:SetStatusBarColor(0,0,0,.85) end

		if unit == "vehicle" or unit:match("pet") then
			health.bg:SetVertexColor(oUF.colors.happiness[3][1], oUF.colors.happiness[3][2],oUF.colors.happiness[3][3])
		end

		if disconnnected or dead or ghost then
			if(disconnnected) then
				if(cfg.hp_inverted) then health:SetValue(max) else health:SetValue(0) end
				health:SetStatusBarColor(.20,.20,.20,1)
				health.value:Hide()
				self.HPborder:Hide()
				self.Name:Show()
				self.Name:SetText(name)
				self.Name:SetTextColor(1,1,1,0.2)
			elseif(ghost) then
				if(cfg.hp_inverted) then health:SetValue(max) else health:SetValue(0) end
				health:SetStatusBarColor(.20,.20,.20,1)
				health.value:Hide()
				self.HPborder:Hide()
				self.Name:Show()
				self.Name:SetText(name)
				self.Name:SetTextColor(1,1,1,0.2)
			elseif(dead) then
				if(cfg.hp_inverted) then health:SetValue(max) else health:SetValue(0) end
				health:SetStatusBarColor(.20,.20,.20,1)
				health.value:Hide()
				self.HPborder:Hide()
				self.Name:Show()
				self.Name:SetText(name)
				self.Name:SetTextColor(1,1,1,0.2)
			end
		else -- If Alive and Playing
			if (min ~= max) then -- Doesn't have max health
				health:SetValue(min)

				if ((min / max) < 0.35) then
					self.HPborder:Show()
					self.HPborder:SetBackdropBorderColor(180/255, 255/255, 0/255, 1)
				else
					self.HPborder:Hide()
				end

				if((min / max) >= 0.90) then
					health.value:Hide()
					self.Name:Show()
					self.Name:SetText(name)
				elseif((min / max) < 0.90) then
					if isPlayer then -- Don't show HP values in Maintank frames, they are non-important
						self.Name:Hide()
						health.value:Show()
					end
					health.value:SetText(ShortNumber(max - min))
				end

			elseif (min == max) then -- It has max health
				self.HPborder:Hide()
				health.value:Hide()
				self.Name:Show()
				self.Name:SetText(name)
				self.Name:SetTextColor(1,1,1,1)
			end

			if(cfg.hp_inverted) then
				if unit == "vehicle" or unit:match("pet") then
					self.Name:SetTextColor(oUF.colors.happiness[3][1], oUF.colors.happiness[3][2],oUF.colors.happiness[3][3])
				else
					if(rColor and isPlayer) then self.Name:SetTextColor(rColor[1],rColor[2],rColor[3]) else self.Name:SetTextColor(1,1,1) end
				end
			end
		end
	end

	-- Post Power Update for Raid Frame
	local PostUpdatePPRaidFrame = function(power, unit, min, max)

		local disconnnected = not UnitIsConnected(unit)
		local dead = UnitIsDead(unit)
		local ghost = UnitIsGhost(unit)

		if disconnnected or dead or ghost then
			power:SetValue(max)

			if(disconnnected) then
				power:SetStatusBarColor(0.84,1,0,0.7)
			elseif(ghost) then
				power:SetStatusBarColor(1,1,1,0.8)
			elseif(dead) then
				power:SetStatusBarColor(1,0,0,0.7)
			end
		else
			power:SetValue(min)
			if(unit == 'vehicle') then
				power:SetStatusBarColor(143/255, 194/255, 32/255)
			end
		end
	end

	-- Mirror Bars
	function MirrorBars()
		if(cfg.MirrorBars) then
			for _, bar in pairs({
				'MirrorTimer1',
				'MirrorTimer2',
				'MirrorTimer3',
		}) do
				local bg = select(1, _G[bar]:GetRegions())
				bg:Hide()

				_G[bar]:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = false, tileSize = 0,
				insets = {top = -2, left = -2, bottom = -2, right = -2}})

				_G[bar]:SetBackdropColor(0, 0, 0, 1)

				_G[bar..'Border']:Hide()

				_G[bar]:SetParent(UIParent)
				_G[bar]:SetScale(1)
				_G[bar]:SetHeight(15)
				_G[bar]:SetWidth(140)

				_G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
				_G[bar..'Background']:SetTexture('Interface\\Buttons\\WHITE8x8')
				_G[bar..'Background']:SetAllPoints(_G[bar])
				_G[bar..'Background']:SetVertexColor(0, 0, 0, 0.5)

				_G[bar..'Text']:SetFont(font, cfg.fontsize-1, Outline)
				_G[bar..'Text']:ClearAllPoints()
				_G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)

				_G[bar..'StatusBar']:SetStatusBarTexture('\Interface\\AddOns\\oUF_lumen\\media\\texture')

				_G[bar..'StatusBar']:SetAllPoints(_G[bar])
			end
		end
	end

	-- -- Skin BG Countdown Timer
	-- function BGTimerBar()

	-- end

	-- local bgtimer = CreateFrame("Frame")
	-- bgtimer:RegisterEvent("START_TIMER")
	-- bgtimer:SetScript("OnEvent", BGTimerBar)

	-- Castbar Custom Cast TimeText
	local CustomCastTimeText = function(self, duration)

		self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))

		if(self.__owner.mystyle == "player") then
			self.Max:SetText(("%.1f "):format(self.max))
		end
	end

	-- Castbar Check for Spell Interrupt
	local CheckForSpellInterrupt = function (self, unit)

		if unit == "vehicle" then unit = "player" end
		if(self.interrupt and UnitCanAttack("player", unit)) then
			self.Glowborder:SetBackdropBorderColor(255/255, 0/255, 0/255, 1)
			self.Glowborder:Show()
		else
			self.Glowborder:Hide()
		end
	end

	-- Castbar PostCast Update
	local myPostCastStart = function(self, unit, name, _, castid)

		CheckForSpellInterrupt(self, unit)
	end

	-- Castbar PostCastChannel Update
	local myPostChannelStart = function(self, unit, name, _, castid)

		CheckForSpellInterrupt(self, unit)
	end

	-- Castbars
	function CreateCastbar(fr)

		fr.Castbar = CreateFrame("StatusBar", "oUF_lumen_CastBar"..fr.mystyle, fr)
		fr.Castbar:SetStatusBarTexture(fill_texture)
		fr.Castbar:GetStatusBarTexture():SetHorizTile(false)
		fr.Castbar:SetToplevel(true)

		fr.Castbar.Icon = fr.Castbar:CreateTexture(nil, 'ARTWORK')
		fr.Castbar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)

		fr.Castbar.Text = fr.Castbar:CreateFontString(nil, "OVERLAY")
		fr.Castbar.Text:SetShadowOffset(1, -1)
	    fr.Castbar.Text:SetTextColor(1, 1, 1)
	    fr.Castbar.Text:SetJustifyH("LEFT")
	    fr.Castbar.Text:SetHeight(12)

		fr.Castbar.Time = fr.Castbar:CreateFontString(nil, "OVERLAY")
	    fr.Castbar.Time:SetTextColor(1, 1, 1)
	    fr.Castbar.Time:SetJustifyH("RIGHT")

		if(cfg.show_spark) then
			fr.Castbar.Spark = fr.Castbar:CreateTexture(nil, 'OVERLAY')
			fr.Castbar.Spark:SetTexture(spark_texture)
			fr.Castbar.Spark:SetBlendMode('ADD')
		end

		if(fr.mystyle == "player") then
			SetBackdrop(fr.Castbar, cfg.player_castbar_height+4, 2, 2, 2)
			fr.Castbar:SetBackdropColor(cfg.cbbdc.r,cfg.cbbdc.g,cfg.cbbdc.b,cfg.cbbdc.a)
			if(cfg.player_castbar_classColor) then fr.Castbar:SetStatusBarColor(unpack(raidColor('player'))) else fr.Castbar:SetStatusBarColor(unpack(cfg.player_castbar_color)) end
			fr.Castbar:SetPoint("BOTTOM", UIParent, cfg.player_castbar_x, cfg.player_castbar_y)
			fr.Castbar:SetWidth(cfg.player_castbar_width)
			fr.Castbar:SetHeight(cfg.player_castbar_height)
			fr.Castbar.Icon:SetHeight(cfg.player_castbar_height)
			fr.Castbar.Icon:SetWidth(cfg.player_castbar_height)
			fr.Castbar.Icon:SetPoint("LEFT", fr.Castbar, -(cfg.player_castbar_height+2), 0)
			fr.Castbar.Text:SetFont(font, cfg.fontsize, Outline)
			fr.Castbar.Text:SetPoint("LEFT", fr.Castbar, 6, 0.5)
			fr.Castbar.Text:SetWidth(200)
			fr.Castbar.Time:SetPoint("RIGHT", fr.Castbar, -6, 0)
			fr.Castbar.Time:SetFont(font, cfg.fontsize+1, Outline)
			fr.Castbar.Max = fr.Castbar:CreateFontString(nil, "OVERLAY")
			fr.Castbar.Max:SetTextColor(200/255, 200/255, 200/255)
	    	fr.Castbar.Max:SetJustifyH("RIGHT")
			fr.Castbar.Max:SetFont(font, cfg.fontsize-2, Outline)
			fr.Castbar.Max:SetPoint("RIGHT", fr.Castbar.Time, "LEFT", 0, 0)
			fr.Castbar.CustomTimeText = CustomCastTimeText

			if(cfg.show_spark) then
				if(cfg.player_castbar_classColor) then fr.Castbar.Spark:SetVertexColor(unpack(raidColor('player'))) else fr.Castbar.Spark:SetVertexColor(unpack(cfg.player_castbar_color)) end
				fr.Castbar.Spark:SetHeight(fr.Castbar:GetHeight() + (fr.Castbar:GetHeight() / 3))
				fr.Castbar.Spark:SetWidth((fr.Castbar:GetWidth()/20))
			end

			-- Hide Default Vechicle CastBar
			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = function() end
			PetCastingBarFrame:Hide()

			-- fr.Castbar.SafeZone = fr.Castbar:CreateTexture(nil,'ARTWORK')
            -- fr.Castbar.SafeZone:SetPoint('TOPRIGHT')
            -- fr.Castbar.SafeZone:SetPoint('BOTTOMRIGHT')
            -- fr.Castbar.SafeZone:SetTexture(fill_texture)
            -- fr.Castbar.SafeZone:SetVertexColor(1,0,.1, 0.4)

		elseif(fr.mystyle == "target") then
			SetBackdrop(fr.Castbar, 22, 2, 2, 2)
			fr.Castbar:SetBackdropColor(cfg.cbbdc.r,cfg.cbbdc.g,cfg.cbbdc.b,cfg.cbbdc.a)
			fr.Castbar:SetStatusBarColor(unpack(cfg.target_castbar_color))
			fr.Castbar:SetPoint("CENTER", UIParent, "TOP", cfg.target_castbar_x, cfg.target_castbar_y)
			fr.Castbar:SetWidth(cfg.target_castbar_width)
			fr.Castbar:SetHeight(cfg.target_castbar_height)
			fr.Castbar.Icon:SetHeight(cfg.target_castbar_height)
			fr.Castbar.Icon:SetWidth(cfg.target_castbar_height)
			fr.Castbar.Icon:SetPoint("LEFT", fr.Castbar, -20, 0)
			fr.Castbar.Text:SetFont(font, cfg.fontsize-1, Outline)
			fr.Castbar.Text:SetPoint("LEFT", fr.Castbar, 6, 0.5)
			fr.Castbar.Text:SetWidth(110)
			fr.Castbar.Time:SetPoint("RIGHT", fr.Castbar, -6, 0.5)
			fr.Castbar.Time:SetFont(font, cfg.fontsize-1, Outline)
			fr.Castbar.CustomTimeText = CustomCastTimeText
			Glowborder(fr.Castbar)
			fr.Castbar.Glowborder:SetPoint("TOPLEFT", fr.Castbar, "TOPLEFT", - (cfg.target_castbar_height + 2) - 6, 6) -- Resize to include icon

			if(cfg.show_spark) then
				fr.Castbar.Spark:SetVertexColor(unpack(cfg.target_castbar_color))
				fr.Castbar.Spark:SetHeight(fr.Castbar:GetHeight() + (fr.Castbar:GetHeight() / 3))
				fr.Castbar.Spark:SetWidth((fr.Castbar:GetWidth()/20))
			end

			fr.Castbar.PostCastStart = myPostCastStart
			fr.Castbar.PostChannelStart = myPostChannelStart

		elseif(fr.mystyle == "focus") then
			SetBackdrop(fr.Castbar, 18, 2, 2, 2)
			fr.Castbar:SetBackdropColor(cfg.cbbdc.r,cfg.cbbdc.g,cfg.cbbdc.b,cfg.cbbdc.a)
			fr.Castbar:SetStatusBarColor(unpack(cfg.focus_castbar_color))
			fr.Castbar:SetPoint("CENTER", UIParent, "TOP", cfg.focus_castbar_x, cfg.focus_castbar_y)
			fr.Castbar:SetWidth(cfg.focus_castbar_width)
			fr.Castbar:SetHeight(cfg.focus_castbar_height)
			fr.Castbar.Icon:SetHeight(cfg.focus_castbar_height)
			fr.Castbar.Icon:SetWidth(cfg.focus_castbar_height)
			fr.Castbar.Icon:SetPoint("LEFT", fr.Castbar, -16, 0)
			fr.Castbar.Text:SetFont(font, cfg.fontsize-2, Outline)
			fr.Castbar.Text:SetPoint("LEFT", fr.Castbar, 6, 0.5)
			fr.Castbar.Text:SetWidth(80)
			fr.Castbar.Time:SetPoint("RIGHT", fr.Castbar, -6, 0.5)
			fr.Castbar.Time:SetFont(font, cfg.fontsize-1, Outline)
			Glowborder(fr.Castbar)
			fr.Castbar.Glowborder:SetPoint("TOPLEFT", fr.Castbar, "TOPLEFT", - (cfg.focus_castbar_height + 2) - 6, 6) -- Resize to include icon

			if(cfg.show_spark) then
				fr.Castbar.Spark:SetVertexColor(unpack(cfg.focus_castbar_color))
				fr.Castbar.Spark:SetHeight(fr.Castbar:GetHeight() + (fr.Castbar:GetHeight() / 3))
				fr.Castbar.Spark:SetWidth((fr.Castbar:GetWidth()/20))
			end

			fr.Castbar.PostCastStart = myPostCastStart
			fr.Castbar.PostChannelStart = myPostChannelStart
		end
	end

	-- Create InfoBar
	local SetInfoBar = function (self)

		self.InfoBar = CreateFrame("Frame", self.mystyle.."InfoBar", self.Health)
		self.InfoBar:SetWidth(cfg.mainframe_width)
		self.InfoBar:SetHeight(cfg.InforBar_height)
		self.InfoBar:SetPoint("BOTTOM", self.Health, "TOP", 0, 2 + cfg.InforBar_shift)
		SetBackdrop(self.InfoBar, 2, 2, 2, 2)
		self.InfoBar:SetAlpha(cfg.InfoBarAlpha)

		self.InfoBar.Classify = createFontstring(self.InfoBar, font, cfg.fontsize-1, Outline)
		self.InfoBar.Classify:SetPoint("LEFT", self.InfoBar, 4, 1)
		self.InfoBar.Classify:SetJustifyH("LEFT")
		self.InfoBar.Classify:SetWidth(cfg.mainframe_width - 40)
		self.InfoBar.Classify:SetHeight(cfg.fontsize)
		self:Tag(self.InfoBar.Classify, "[lumen:level]")

		self.Info = createFontstring(self.InfoBar, font, cfg.fontsize-1, Outline)
		self.Info:SetPoint("RIGHT", self.InfoBar, "RIGHT", -4, 1)
		self.Info:SetJustifyH("RIGHT")
		self.Info.frequentUpdates = true
		self:Tag(self.Info, "[lumen:Info]")
	end

	-- Create Portraits
	local CreatePortraits = function(self, unit)

		if(self.mystyle == "player" or self.mystyle == "target") then
			self.Portrait = CreateFrame("PlayerModel", nil, self.InfoBar)
			--self.Portrait:SetAllPoints(self.InfoBar)
			self.Portrait:SetPoint('TOPLEFT', self.InfoBar, 'TOPLEFT', 0,1)
			self.Portrait:SetPoint('BOTTOMRIGHT', self.InfoBar, 'BOTTOMRIGHT', 0,0)
			self.Portrait:SetFrameLevel(4)
		end
	end

	-- Update the Portraits
	local myPortraitPostUpdate = function(Portrait, unit)

		if (not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit)) then
			Portrait:Hide()
		else
			Portrait:Show()
			local race, _ = UnitRace(unit);
			local gender = UnitSex(unit) -- 1 = Neutrum / Unknown, 2 = Male, 3 = Female
			if (race == "Human" and gender == 3 or race == "Worgen" and gender == 2 or race == "Dwarf" and gender == 2) then  -- Stupid Hack to fix buggy 3D Portrait
				Portrait:SetCamera(1)
			else
				Portrait:SetCamera(0)
			end

			Portrait:SetScale(0.85)
			-- Portrait.type = "3D"
			-- Portrait:SetAlpha(.51) -- Portrait Dirty Bug Fix.
			Portrait:SetAlpha(0.75)
		end
	end

	-- Mouseover highlight
	local OnEnter = function(self)
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
	end

	local OnLeave = function(self)
		UnitFrame_OnLeave(self)
		self.Highlight:Hide()
	end

	-- Post Create Icon Function
	local myPostCreateIcon = function(self, button)

		self.showDebuffType = true
		self.disableCooldown = true
		button.cd.noOCC = true
		button.cd.noCooldownCount = false

		button.icon:SetTexCoord(.07, .93, .07, .93)
		button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
		button.overlay:SetTexture(border)
		button.overlay:SetTexCoord(0,1,0,1)
		button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

		button.time = button:CreateFontString(nil, 'OVERLAY')
		button.time:SetFont(font, 11, Outline)
		button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
		button.time:SetJustifyH('CENTER')
		button.time:SetVertexColor(1,1,1)

		button.count:ClearAllPoints()
		button.count:SetPoint("TOPRIGHT", button, 2, 2)
		button.count:SetFont(font, 10, Outline)
		button.count:SetVertexColor(1,1,1)
	end

	-- Post Create Icon (no Cooldown) Function
	local myPostCreateIconNoCC = function(self, button)

		self.showDebuffType = true
		self.disableCooldown = true
		button.cd.noOCC = true
		button.cd.noCooldownCount = true

		button.icon:SetTexCoord(.07, .93, .07, .93)
		button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
		button.overlay:SetTexture(border)
		button.overlay:SetTexCoord(0,1,0,1)
		button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end

		button.time = button:CreateFontString(nil, 'OVERLAY')
		button.time:SetFont(font, 11, Outline)
		button.time:SetPoint("BOTTOMLEFT", button, -2, -2)
		button.time:SetJustifyH('CENTER')
		button.time:SetVertexColor(1,1,1)

		button.count:ClearAllPoints()
		button.count:SetPoint("TOPRIGHT", button, 2, 2)
		button.count:SetFont(font, 10, Outline)
		button.count:SetVertexColor(1,1,1)
	end

	-- Post Update Icon Function
	local myPostUpdateIcon = function(self, unit, icon, index, offset, filter, isDebuff)

		local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

		if duration and duration > 0 then
			icon.time:Show()
			icon.timeLeft = expirationTime
			icon:SetScript("OnUpdate", CreateBuffTimer)
		else
			icon.time:Hide()
		end

		-- Desaturate non-Player Debuffs
		if(cfg.desat_np_debuffs and icon.debuff) then
			if(unit == "target" or unit == "focus") then
				if (unitCaster == 'player' or unitCaster == 'vehicle') then
					print(unitCaster)
					icon.icon:SetDesaturated(false)
				elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don't desaturate debuffs
					icon:SetBackdropColor(0, 0, 0)
					icon.overlay:SetVertexColor(0.3, 0.3, 0.3)
					icon.icon:SetDesaturated(true)
				end
			end
		end
		icon.first = true
	end

	-- Create Buff/Debuff Timer Function
	function CreateBuffTimer(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end

			if self.timeLeft > 0 and self.timeLeft < 60 * 5 then
				local time = FormatTime(self.timeLeft)
				self.time:SetText(time)
				if self.timeLeft >= 6 and self.timeLeft <= 60*5 then -- if Between 5 min and 6sec
					self.time:SetTextColor(0.95,0.95,0.95)
				elseif self.timeLeft > 3 and self.timeLeft < 6 then -- if Between 6sec and 3sec
					self.time:SetTextColor(0.95,0.70,0)
				elseif self.timeLeft <= 3 then -- Below 3sec
					self.time:SetTextColor(0.9, 0.05, 0.05)
				else
					self.time:SetTextColor(0.95,0.95,0.95) -- Fallback Color
				end
			else
				self.time:SetText()
			end
			self.elapsed = 0
		end
	end

	-- Generates the Buffs
	function createBuffs(self)

		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs["growth-y"] = "DOWN"

		if(self.mystyle == "target") then
			self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -6)
			self.Buffs.initialAnchor = "TOPLEFT"
			self.Buffs.size = 22
			self.Buffs:SetHeight(self.Buffs.size)
			self.Buffs:SetWidth((self.Buffs.size) * 8)
			self.Buffs.num = 14
			self.Buffs.spacing = 3
		end

		if(self.mystyle == "pet") then
			self.Buffs["growth-x"] = "LEFT"
			self.Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 2)
			self.Buffs.initialAnchor = "TOPRIGHT"
			self.Buffs.size = 20
			self.Buffs:SetHeight(self.Buffs.size)
			self.Buffs:SetWidth((self.Buffs.size) * 3)
			self.Buffs.num = cfg.num_Pet_buffs
			self.Buffs.spacing = 2
			if(cfg.pet_custom_filter) then self.Buffs.CustomFilter = myCustomPetBuffsFilter end
		end
		self.Buffs.PostCreateIcon = myPostCreateIcon
		self.Buffs.PostUpdateIcon = myPostUpdateIcon
	end

	-- Generates the Debuffs
	function createDebuffs(self)

		self.Debuffs = CreateFrame("Frame", "lumen"..self.mystyle.."Debuffs", self)

		if(self.mystyle == "player") then
			self.Debuffs["growth-y"] = "DOWN"
			self.Debuffs["growth-x"] = "RIGHT"
			self.Debuffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -2, -53 - rep_shift)
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs.size = 26
			self.Debuffs:SetHeight(self.Debuffs.size)
			self.Debuffs:SetWidth(self.Debuffs.size * 6)
			self.Debuffs.num = 12
			self.Debuffs.spacing = 2
		end

		if(self.mystyle == "target") then
			self.Debuffs["growth-y"] = "TOP"
			self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 19 + cfg.InforBar_shift)
			self.Debuffs.initialAnchor = "BOTTOMLEFT"
			self.Debuffs.size = 20
			self.Debuffs:SetHeight(self.Debuffs.size)
			self.Debuffs:SetWidth((self.Debuffs.size+2) * 4)
			self.Debuffs.num = 4
			self.Debuffs.spacing = 2
			if(cfg.target_debuffs_custom_filter) then self.Debuffs.CustomFilter = myCustomDebuffsFilter end
		end

		if(cfg.show_focus_debuffs and self.mystyle == "focus") then
			self.Debuffs["growth-x"] = "LEFT"
			self.Debuffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 2)
			self.Debuffs.initialAnchor = "TOPRIGHT"
			self.Debuffs.size = 20
			self.Debuffs:SetHeight(self.Debuffs.size)
			self.Debuffs:SetWidth((self.Debuffs.size) * 3)
			self.Debuffs.num = cfg.num_focus_debuffs
			self.Debuffs.spacing = 2
			if(cfg.focus_debuffs_filter) then self.Debuffs.CustomFilter = myCustomFocusDebuffsFilter end
		end

		if(cfg.show_ToT_debuffs and self.mystyle == "tot") then
			self.Debuffs["growth-x"] = "RIGHT"
			self.Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 2)
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs.size = 20
			self.Debuffs:SetHeight(self.Debuffs.size)
			self.Debuffs:SetWidth((self.Debuffs.size) * 3)
			self.Debuffs.num = cfg.num_ToT_debuffs
			self.Debuffs.spacing = 2
		end
		self.Debuffs.PostCreateIcon = myPostCreateIcon
		self.Debuffs.PostUpdateIcon = myPostUpdateIcon
	end

	-- Target Debuff Filter
	function myCustomDebuffsFilter(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)

		if(not Whitelist[PlayerClass][name]) then -- Blacklist
			return true
		end
	end

	-- Focus Debuff Filter
	function myCustomFocusDebuffsFilter(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)

		if(caster == "player" and Whitelist[PlayerClass][name]) then -- Blacklist
			return true
		end
	end

	-- Pet Debuff Filter
	function myCustomPetBuffsFilter(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)

		if(Whitelist["PET"][name]) then
			return true
		end
	end

	-- Raid Frames Threat Highlight
	function UpdateThreat(self, event, unit)

		if (self.unit ~= unit) then return end

		local status = UnitThreatSituation(unit)
		unit = unit or self.unit

		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Thtborder:Show()
			self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
		else
			self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
			self.Thtborder:Hide()
		end
	end

	-- Raid Frames Target Highlight Border
	function ChangedTarget(self, event, unit)

		if UnitIsUnit('target', self.unit) then
			self.Targetborder:SetBackdropBorderColor(.8, .8, .8, 1)
			self.Targetborder:Show()
		else
			self.Targetborder:Hide()
		end
	end

	-- Raid Frames Dispell Debuff Hightlight (Magic, Curse, Poison, Disease) * Based on oUF_Freebgrid and DebuffHightlight

	local dispellClass = {
		PRIEST = { Magic = true, Disease = true},
		SHAMAN = { Magic = true, Curse = true},
		PALADIN = { Magic = true, Poison = true, Disease = true},
		MAGE = { Curse = true},
		DRUID = { Magic = true, Curse = true, Poison = true},
	}

	local dispellList = dispellClass[PlayerClass] or {}
	local dispellPriority = { Magic = 4, Poison = 3, Curse = 2, Disease = 1 }
	local curPriority = 0

	function GetDebuffType(unit)

		if not UnitCanAssist("player", unit) then return nil end
		local index = 1

		while true do
			local _, _, icon, _, debuffType = UnitAura(unit, index, "HARMFUL")
			if not icon then break end
			if(dispellList[debuffType]) then return debuffType end
			index = index + 1
		end

	end

	function UpdateDispell(self, event, unit)

		if self.unit ~= unit  then return end
		local debuffType = GetDebuffType(unit)

		if debuffType then
			if(dispellPriority[debuffType] >= curPriority) then
				local color = DebuffTypeColor[debuffType]
				curPriority = dispellPriority[debuffType]
				self.DispellIcon:Show()
				self.DispellIcon:SetStatusBarColor(color.r,color.g,color.b)
				self.DispellIcon:SetBackdropColor(0,0,0,1)
				self.DispellIcon:SetFrameLevel(10)

				self.Dispellborder:Show()
				self.Dispellborder:SetBackdropBorderColor(color.r,color.g,color.b,1)
			end
		else
			self.DispellIcon:Hide()
			self.Dispellborder:Hide()
			curPriority = 0
		end
	end

	function Dispell(self, unit)

		self.DispellIcon = CreateFrame("StatusBar", nil, self.Health)
		self.DispellIcon:SetStatusBarTexture(white_square)
		self.DispellIcon:SetWidth(3)
		self.DispellIcon:SetHeight(3)
		self.DispellIcon:SetPoint("CENTER", self.Health, "BOTTOMRIGHT", -4, 4)
		SetBackdrop(self.DispellIcon, 1, 1, 1, 1)

		local glowBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}
		self.Dispellborder = CreateFrame("Frame", nil, self)
		self.Dispellborder:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
		self.Dispellborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
		self.Dispellborder:SetBackdrop(glowBorder)
		self.Dispellborder:SetFrameLevel(10)

		self.Dispellborder:Hide()
		self.DispellIcon:Hide()

		self:RegisterEvent("UNIT_AURA", UpdateDispell)
	end

	-- Aura Watches (BarTimers + Raid Corner Indicators)

	function createAuraWatchers(self)

		if(self.mystyle == "player" or self.mystyle == "target") then -- Bar Timers for Player and Target Frames
			self.AuraWatchers = CreateFrame("Frame", self.mystyle.."AuraWatchers", self)
			self.AuraWatchers:SetHeight(cfg.BarTimers_height)
			self.AuraWatchers:SetWidth(cfg.BarTimers_width or cfg.mainframe_width)
			self.AuraWatchers:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, cfg.mainframe_height + cfg.secondaryframe_height + cfg.InforBar_height + cfg.BarTimers_height + cfg.InforBar_shift + 3 + exp_shift)
		end

		if(self.mystyle == "raid" or self.mystyle == "party" or self.mystyle == "partypet") then -- Corner Indicators
			if cfg.show_CornerIndicators then
				self.AuraWatchers = CreateFrame("Frame", nil, self) -- Make Indicators Awere of the Unit Aura Event

				-- Indicators
				self.IndicatorTL = CreateFrame("StatusBar", nil, self.Health)
				self.IndicatorTL:SetStatusBarTexture(white_square)
				self.IndicatorTL:SetWidth(3)
				self.IndicatorTL:SetHeight(3)
				self.IndicatorTL:SetPoint("CENTER", self.Health, "TOPLEFT", 4, -4)
				SetBackdrop(self.IndicatorTL, 1, 1, 1, 1)
				self.IndicatorTL:SetBackdropColor(0,0,0,1)
				self.IndicatorTL:Hide()

				self.IndicatorTR = CreateFrame("StatusBar", nil, self.Health)
				self.IndicatorTR:SetStatusBarTexture(white_square)
				self.IndicatorTR:SetWidth(3)
				self.IndicatorTR:SetHeight(3)
				self.IndicatorTR:SetPoint("CENTER", self.Health, "TOPRIGHT", -4, -4)
				SetBackdrop(self.IndicatorTR, 1, 1, 1, 1)
				self.IndicatorTR:SetBackdropColor(0,0,0,1)
				self.IndicatorTR:Hide()

				self.IndicatorBL = CreateFrame("StatusBar", nil, self.Health)
				self.IndicatorBL:SetStatusBarTexture(white_square)
				self.IndicatorBL:SetWidth(3)
				self.IndicatorBL:SetHeight(3)
				self.IndicatorBL:SetPoint("CENTER", self.Health, "BOTTOMLEFT", 4, 4)
				SetBackdrop(self.IndicatorBL, 1, 1, 1, 1)
				self.IndicatorBL:SetBackdropColor(0,0,0,1)
				self.IndicatorBL:Hide()

				self.IndicatorBR = CreateFrame("StatusBar", nil, self.Health)
				self.IndicatorBR:SetStatusBarTexture(white_square)
				self.IndicatorBR:SetWidth(3)
				self.IndicatorBR:SetHeight(3)
				self.IndicatorBR:SetPoint("CENTER", self.Health, "BOTTOMRIGHT", -4, 4)
				SetBackdrop(self.IndicatorBR, 1, 1, 1, 1)
				self.IndicatorBR:SetBackdropColor(0,0,0,1)
				self.IndicatorBR:Hide()
			end
		end
	end

	-- Creates a Bar for the BarTimers
	function CreateTimerBar(oUF, point)

		local root = oUF.AuraWatchers

		local bar = CreateFrame("StatusBar", nil, oUF)
		if(root == point) then
			bar:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT", cfg.BarTimers_height+2, 0)
		else
			bar:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", 0, cfg.BarTimers_height+cfg.BarTimers_Gap)
		end
		bar.Smooth = true
		bar:SetHeight(cfg.BarTimers_height)
		bar:SetWidth(cfg.BarTimers_width or cfg.mainframe_width - cfg.BarTimers_height - 2)
		bar:SetStatusBarTexture(fill_texture)
		bar:GetStatusBarTexture():SetHorizTile(false)
		SetBackdrop(bar, cfg.BarTimers_height+4, 2, 2, 2)
		bar:SetBackdropColor(0,0,0,0.85)

		bar.icon = bar:CreateTexture(nil, 'ARTWORK')
		bar.icon:SetHeight(cfg.BarTimers_height)
		bar.icon:SetWidth(cfg.BarTimers_height)
		bar.icon:SetTexCoord(.1, .93, .07, .93)
		bar.icon:SetPoint("TOP")
		bar.icon:SetPoint("LEFT", root)

		-- Strings
		bar.spell = createFontstring(bar, font, cfg.fontsize-2, Outline)
		bar.spell:SetTextColor(1, 1, 1)
		bar.spell:SetJustifyH("LEFT")
		bar.spell:SetJustifyV("CENTER")
		bar.spell:SetPoint("LEFT", bar, "LEFT", 4, 0)
		bar.spell:SetHeight(cfg.BarTimers_height)

		bar.time = createFontstring(bar, font, cfg.fontsize-2, Outline)
		bar.time:SetTextColor(1, 1, 1)
		bar.time:SetJustifyH("RIGHT")
		bar.time:SetJustifyV("CENTER")
		bar.time:SetPoint("RIGHT", bar, "RIGHT", -4, 0)

		bar.stack = createFontstring(bar, font, cfg.fontsize-2, Outline)
		bar.stack:SetJustifyH("LEFT")
		bar.stack:SetJustifyV("CENTER")
		bar.stack:SetPoint("LEFT", bar.spell, "RIGHT", 0.5, 0)

		if(cfg.BarTimers_spark) then
		bar.spark = bar:CreateTexture(nil, 'OVERLAY')
		bar.spark:SetTexture(spark_texture)
		bar.spark:SetBlendMode('ADD')
		bar.spark:SetHeight(cfg.BarTimers_height+5)
		bar.spark:SetWidth((cfg.BarTimers_height/3)*2)
		end

		return bar
	end

	-- OnUpdate
	function UpdateAuraWatchers(AuraWatchers)

		local bars = AuraWatchers.bars
		local timenow = GetTime()

		for index = 1, #bars do
			local bar = bars[index]

			if bar.timer.noTime then
				bar.time:SetText()
				if(cfg.BarTimers_spark) then bar.spark:SetPoint("CENTER", bar, "LEFT", -999999, 0) end
			else
				local curTime = bar.timer.expirationTime - timenow
				local timeleft = FormatTime(curTime)
				bar:SetValue(curTime)
				if(cfg.BarTimers_spark and bar.timer.expirationTime > 0) then bar.spark:SetPoint("CENTER", bar, "LEFT", ((curTime) * bar:GetWidth()) / bar.timer.duration, 0) end
				if(timeleft and curTime <= 60) then
					bar.time:SetText(timeleft.."|cff999999s|r")
				elseif (curTime > 60)then
					bar.time:SetText(timeleft)
				end
			end
		end
	end

	-- Use QuickSort to Sort Auras/Bars by duration
	local qsort = function(a, b)

		local aux_A, aux_B = a.noTime and math.huge or a.expirationTime, b.noTime and math.huge or b.expirationTime
		if cfg.invert_bar_sorting then return aux_B > aux_A
		else return aux_A > aux_B
		end
	end

	-- The Bar Timers Whitelist Filter
	function myCustomBarTimersFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable)

		if(unitCaster == "player" and PlayerClass) then
			return Whitelist[PlayerClass][name]
		end
	end

	-- Unit has an Aura
	function hasUnitAura(unit, name)

		local _, _, _, count, _, _, _, caster = UnitAura(unit, name)
		if (caster and caster == "player") then
			return count
		end
	end

	-- Unit has a Debuff
	function hasUnitDebuff(unit, name, myspell)

		local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
		if myspell then
			if (count and caster == 'player') then return count end
		else
			if count then return count end
		end
	end

	-- Update AuraWatchers (BarTimers / Corner Indicators)
	function UpdateAW(self, event, unit)

	if(self.mystyle == "player" or self.mystyle == "target") then -- Bar Timers
		if(self.unit ~= unit) then return end
		unit = unit or self.unit

		local reaction = UnitIsFriend('player', unit) and 'HELPFUL' or 'HARMFUL'
		local auras,lastIndex,bars = {},0,self.AuraWatchers.bars

		-- Read the Buffs/Debuffs
		for index = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, reaction)
			if not name then break end

			if ((myCustomBarTimersFilter)(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable)) then
				lastIndex = lastIndex + 1
				auras[lastIndex] = {}
				auras[lastIndex].name = name
				auras[lastIndex].rank = rank
				auras[lastIndex].icon = icon
				auras[lastIndex].count = count
				auras[lastIndex].debuffType = debuffType
				auras[lastIndex].duration = duration
				auras[lastIndex].expirationTime = expirationTime
				auras[lastIndex].unitCaster = unitCaster
				auras[lastIndex].isStealable = isStealable
				auras[lastIndex].noTime = (duration == 0 and expirationTime == 0)
			end
		end

		table.sort(auras, type(before) == "function" and before or qsort )

		-- Create the Bars
		for index = 1 , lastIndex do
			local bar = bars[index]
			local timer = auras[index]

			if not bar then
				bar = CreateTimerBar(self, index == 1 and self.AuraWatchers or bars[index-1])
				bars[index] = bar
			end

			bar.timer = timer

			if bar.timer.noTime then
				bar:SetMinMaxValues(0, 1)
				bar:SetValue(1)
			else
				bar:SetMinMaxValues(0, bar.timer.duration)
				bar:SetValue(bar.timer.expirationTime - GetTime())
			end

			bar.icon:SetTexture(bar.timer.icon)
			bar.spell:SetText(bar.timer.name)

			if(bar.timer.count ~= 0) then
				bar.stack:SetText("|cff999999".. bar.timer.count .."|r")
			else
				bar.stack:SetText()
			end

			if(reaction == 'HARMFUL') then
				if(cfg.BarTimers_Color_by_Debuff) then
					local debufftype = bar.timer.debuffType
					local color = DebuffTypeColor[debufftype] or DebuffTypeColor.none
					bar:SetStatusBarColor(color.r, color.g, color.b)
					bar.spark:SetVertexColor(color.r, color.g, color.b)
				else
					bar:SetStatusBarColor(1, 0, 0)
					bar.spark:SetVertexColor(1, 0, 0)
				end
			else
				bar:SetStatusBarColor(0, 0.4, 1)
				bar.spark:SetVertexColor(0, 0.4, 1)
			end
			bar:Show()
		end

			-- Remove unused Bars
			for index = lastIndex + 1, #bars do
				bars[index]:Hide()
			end
		end -- End Bar Timers

		if(self.mystyle == "raid" or self.mystyle == "party" or self.mystyle == "partypet") then -- Corner Indicators
			if(self.unit ~= unit) then return end
			unit = unit or self.unit
			local Corners = {"TL", "TR", "BL", "BR"}

			for _, corner in pairs(Corners) do
				for spell, v in pairs(ISpells[PlayerClass][corner]) do
					local count = hasUnitAura(unit, spell) or hasUnitDebuff(unit, spell, false)
					if count then
						if v.stack > 1 then
							if corner == "TL" then self.IndicatorTL:SetStatusBarColor(unpack(v.color)) self.IndicatorTL:SetAlpha(count/v.stack) self.IndicatorTL:Show() end
							if corner == "TR" then self.IndicatorTR:SetStatusBarColor(unpack(v.color)) self.IndicatorTR:SetAlpha(count/v.stack) self.IndicatorTR:Show() end
							if corner == "BL" then self.IndicatorBL:SetStatusBarColor(unpack(v.color)) self.IndicatorBL:SetAlpha(count/v.stack) self.IndicatorBL:Show() end
							if corner == "BR" then self.IndicatorBR:SetStatusBarColor(unpack(v.color)) self.IndicatorBR:SetAlpha(count/v.stack) self.IndicatorBR:Show() end
						else
							if corner == "TL" then self.IndicatorTL:SetStatusBarColor(unpack(v.color)) self.IndicatorTL:Show() end
							if corner == "TR" then self.IndicatorTR:SetStatusBarColor(unpack(v.color)) self.IndicatorTR:Show() end
							if corner == "BL" then self.IndicatorBL:SetStatusBarColor(unpack(v.color)) self.IndicatorBL:Show() end
							if corner == "BR" then self.IndicatorBR:SetStatusBarColor(unpack(v.color)) self.IndicatorBR:Show() end
						end
					else
						if corner == "TL" then self.IndicatorTL:Hide() end
						if corner == "TR" then self.IndicatorTR:Hide() end
						if corner == "BL" then self.IndicatorBL:Hide() end
						if corner == "BR" then self.IndicatorBR:Hide() end
					end
				end
			end
		end -- End Corner Indicators
	end

	-- Enable AuraWatchers
	function EnableAW(self)

		if self.AuraWatchers then
			self:RegisterEvent('UNIT_AURA', UpdateAW)
			self.AuraWatchers.bars = self.AuraWatchers.bars or {}
			self.AuraWatchers:SetScript('OnUpdate', UpdateAuraWatchers)
			return true
		end
	end

	-- Disable AuraWatchers
	function DisableAW(self)

		if self.AuraWatchers then
			self:UnregisterEvent('UNIT_AURA', UpdateAW)
			self.AuraWatchers:SetScript('OnUpdate', UpdateAuraWatchers)
		end
	end

	oUF:AddElement('AuraWatchers', UpdateAW, EnableAW, DisableAW) -- AuraWatchers -- END

	-- Raid Icons
	function RaidIcons(self)

		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(15)
		self.RaidIcon:SetWidth(15)

		if (self.mystyle == "player") then
			self.RaidIcon:SetPoint("RIGHT", self, 22, 23)
		elseif (self.mystyle == "target") then
			self.RaidIcon:SetPoint("LEFT", self, -22, 23)
		elseif (self.mystyle == "boss") then
			self.RaidIcon:SetSize(17,17)
			self.RaidIcon:SetPoint("LEFT", self, -24, 1)
		end
	end

	-- Phase Icon
	local PhaseIcon = function(self)

		local phIcon = self:CreateTexture(nil, 'OVERLAY')
		phIcon:SetSize(15, 15)
		self.PhaseIcon = phIcon
		self.PhaseIcon:SetPoint("RIGHT", self, 22, 0)
	end

	-- Mob Quest Icon
	local QuestIcon = function(self)

		local qstIcon = self:CreateTexture(nil, 'OVERLAY')
		qstIcon:SetSize(15, 15)
		self.QuestIcon = qstIcon
		self.QuestIcon:SetPoint("RIGHT", self, 22, 0)
	end

	-- LFG Role Indicator
	function LFGRole(self)

		self.LFGRole = CreateFrame("Frame", nil, self)
		self.LFGRole = createFontstring(self, font, cfg.fontsize-3, Outline)
		self.LFGRole:SetPoint("TOP", self, 0, 14)
		self.LFGRole:SetTextColor(.8,.8,.8,0.55)
		self:Tag(self.LFGRole, "[lumen:lfdrole]")
	end

	-- Druid Power
	local DruidPowa = function(self)

		if PlayerClass == "DRUID" then
			self.DruidPower = createFontstring(self.Power, font, cfg.fontsize-2, Outline)
			self.DruidPower:SetPoint("LEFT", self.Power, 2, 0)
			self.DruidPower:SetJustifyH("LEFT")
			self:Tag(self.DruidPower, '[lumen:druidPower]')
		end
	end

	-- ComboPoints
	local ComboPoints = function(self)

		local CPoints = self:CreateFontString(nil, 'OVERLAY')
		CPoints:SetPoint('CENTER', self, 'LEFT', cfg.comboPoints_posx or -(cfg.target_frame_x_from_player/2), cfg.comboPoints_posy or 0)
		CPoints:SetFont(font, cfg.fontsize*3, "OUTLINE")
		CPoints:SetJustifyH('CENTER')
		CPoints:SetShadowOffset(1, -1)
		self:Tag(CPoints, '[lumen:cp]')
		-- if(PlayerClass == "ROGUE" and cfg.RogueDPT) then
		-- 	DPTracker = self:CreateFontString(nil, 'OVERLAY')
		-- 	DPTracker:SetPoint('BOTTOMLEFT', CPoints, 'TOPRIGHT',0,-10)
		-- 	DPTracker:SetFont(font, cfg.fontsize+1, "OUTLINE")
		-- 	DPTracker:SetJustifyH('CENTER')
		-- 	DPTracker:SetShadowOffset(1, -1)
		-- 	self:Tag(DPTracker, '[lumen:dp]')
		-- end
	end

	-- DK Runes
	local RunesBar = function(self)

		if(cfg.show_DK_runes and PlayerClass == "DEATHKNIGHT") then
			self.Runes = CreateFrame("Frame", nil, self)

			for i= 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
				self.Runes[i]:SetHeight(cfg.DK_runes_height)
				self.Runes[i]:SetWidth((cfg.DK_runes_width))
				self.Runes[i]:SetStatusBarTexture(fill_texture)
				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetTexture(bg_texture)
				self.Runes[i].bg:SetPoint("TOPLEFT", self.Runes[i], "TOPLEFT", -1, 1)
				self.Runes[i].bg:SetPoint("BOTTOMRIGHT", self.Runes[i], "BOTTOMRIGHT", 1, -1)
				self.Runes[i].bg.multiplier = 0.2
				SetBackdrop(self.Runes[i], 2, 2, 2, 2)
				if (i == 1) then
					self.Runes[i]:SetPoint('LEFT', self, 'RIGHT', cfg.rune_x or ((cfg.target_frame_x_from_player/2) - (((cfg.DK_runes_width + cfg.rune_spacing) * 3) - (cfg.rune_spacing/2))), cfg.rune_y or 0)
				else
					self.Runes[i]:SetPoint('TOPLEFT', self.Runes[i-1], "TOPRIGHT", cfg.rune_spacing, 0)
				end

				-- Alpha
				self:RegisterEvent("PLAYER_ENTERING_WORLD", function(self) self.Runes[i]:SetAlpha(cfg.DK_runes_alpha) end)
				self:RegisterEvent("PLAYER_REGEN_ENABLED", function(self) self.Runes[i]:SetAlpha(cfg.DK_runes_alpha) end)
				self:RegisterEvent("PLAYER_REGEN_DISABLED", function(self) self.Runes[i]:SetAlpha(1) end)
			end
		end
	end

	-- Warlock Resources

	-- Warlock Resources in Number Format

	-- Priests Orbs Count
	local PriestShadowOrbsCount = function(self)

		if(PlayerClass == "PRIEST") then
			local ShadowOrbs = self:CreateFontString(nil, 'OVERLAY')
			ShadowOrbs:SetPoint('CENTER', self, 'RIGHT', cfg.php_count_x or (cfg.target_frame_x_from_player/2), cfg.php_count_y or 0)
			ShadowOrbs:SetFont(font, cfg.fontsize*3, "OUTLINE")
			ShadowOrbs:SetJustifyH('CENTER')
			ShadowOrbs:SetShadowOffset(1, -1)
			self:Tag(ShadowOrbs, '[lumen:shadoworbs]')
		end
	end

	-- Paladin Holy Power with StatusBar
	PaladinHolyPower = function(self)

		if(cfg.show_PL_HolyPower and PlayerClass == "PALADIN") then
			local HolyPower = CreateFrame("Frame", nil, self)

			for i = 1, 5 do
				local Icon = CreateFrame("StatusBar", nil, HolyPower)
				Icon:SetStatusBarTexture(fill_texture)
				Icon:GetStatusBarTexture():SetHorizTile(false)
				Icon:SetSize(cfg.PL_hp_width, cfg.PL_hp_height)
				if (i == 1) then
					Icon:SetPoint('LEFT', self, 'RIGHT', cfg.PL_hp_x or ((cfg.target_frame_x_from_player/2) - (((cfg.PL_hp_width + cfg.PL_hp_spacing) * 1.5) - (cfg.PL_hp_spacing/2))), cfg.PL_hp_y or 0)
				else
					Icon:SetPoint('TOPLEFT', HolyPower[i-1], "TOPRIGHT", cfg.PL_hp_spacing, 0)
				end
				Icon:SetStatusBarColor(245/255, 102/255, 165/255)
				SetBackdrop(Icon, 2, 2, 2, 2)
				Icon.SetVertexColor = noop
				HolyPower[i] = Icon
			end

			self.ClassIcons = HolyPower
		end
	end

	-- Paladin Holy Power in Number Format
	local PaladinHolyPowerCount = function(self)

		if(PlayerClass == "PALADIN") then
			local HolyPower = self:CreateFontString(nil, 'OVERLAY')
			HolyPower:SetPoint('CENTER', self, 'RIGHT', cfg.php_count_x or (cfg.target_frame_x_from_player/2), cfg.php_count_y or 0)
			HolyPower:SetFont(font, cfg.fontsize*3, "OUTLINE")
			HolyPower:SetJustifyH('CENTER')
			HolyPower:SetShadowOffset(1, -1)
			self:Tag(HolyPower, '[lumen:holypower]')
		end
	end

	-- Monk Chi with Status Bar
	MonkChi = function(self)

		if(cfg.show_Monk_chi and PlayerClass == "MONK") then
			local Harmony = CreateFrame("Frame", nil, self)

			for i = 1, 5 do
				local Icon = CreateFrame("StatusBar", nil, Harmony)
				Icon:SetStatusBarTexture(fill_texture)
				Icon:GetStatusBarTexture():SetHorizTile(false)
				Icon:SetSize(cfg.Monk_chi_width, cfg.Monk_chi_height)
				if (i == 1) then
					Icon:SetPoint('LEFT', self, 'RIGHT', cfg.Monk_chi_x or ((cfg.target_frame_x_from_player/2) - (((cfg.Monk_chi_width + cfg.Monk_chi_spacing) * 1.5) - (cfg.Monk_chi_spacing/2))), cfg.Monk_chi_y or 0)
				else
					Icon:SetPoint('TOPLEFT', Harmony[i-1], "TOPRIGHT", cfg.Monk_chi_spacing, 0)
				end
				Icon:SetStatusBarColor(0/255, 255/255, 150/255)
				SetBackdrop(Icon, 2, 2, 2, 2)
				Icon.SetVertexColor = noop
				Harmony[i] = Icon
			end

			self.ClassIcons = Harmony
		end
	end

	-- Monk Chi Count
	local MonkChiCount = function(self)

		if(PlayerClass == "MONK") then
			local MonkChi = self:CreateFontString(nil, 'OVERLAY')
			MonkChi:SetPoint('CENTER', self, 'RIGHT', cfg.php_count_x or (cfg.target_frame_x_from_player/2), cfg.php_count_y or 0)
			MonkChi:SetFont(font, cfg.fontsize*3, "OUTLINE")
			MonkChi:SetJustifyH('CENTER')
			MonkChi:SetShadowOffset(1, -1)
			self:Tag(MonkChi, '[lumen:monkchi]')
		end
	end

	-- Druid Eclipse Bar Post Unit Aura Update
	local EclipsePostUnitAura = function(self)

		if self.hasSolarEclipse then
			self.Glowborder:Show()
			self.Glowborder:SetBackdropBorderColor(255/255, 166/255, 0/255, 1)
			self.spark:SetVertexColor(255/255, 166/255, 0/255)
			self.spark:SetPoint('CENTER', self.SolarBar, 'LEFT', 1, 0)
		elseif self.hasLunarEclipse then
			self.Glowborder:Show()
			self.Glowborder:SetBackdropBorderColor(0/255, 108/255, 255/255, 1)
			self.spark:SetVertexColor(0/255, 108/255, 255/255)
			self.spark:SetPoint('CENTER', self.SolarBar, 'LEFT', -1, 0)
		else
			self.Glowborder:Hide()
		end
	end

	-- Druid Eclipse Post Direction Change
	local EclipsePostDirChange = function(self)

		if(self.directionIsLunar) then
			self.text:SetText(">>    >>    >>")
		else
			self.text:SetText("<<    <<    <<")
		end
	end

	-- Druid Moonkin Eclipse Bar
	local MoonkinEclipseBar = function(self)

		if(PlayerClass == "DRUID") then
			local eBar = CreateFrame('Frame', nil, self)
			eBar:SetPoint('CENTER', self, 'RIGHT', cfg.eclipse_x or (cfg.target_frame_x_from_player/2), cfg.eclipse_y or 0)
			eBar:SetSize(cfg.eclipse_bar_width, cfg.eclipse_bar_height)
			SetBackdrop(eBar, 2, 2, 2, 2)
			Glowborder(eBar)

			local lBar = CreateFrame('StatusBar', nil, eBar)
			local sBar = CreateFrame('StatusBar', nil, eBar)
			lBar:SetPoint('LEFT', eBar, 'LEFT', 0, 0)
			lBar:SetSize(cfg.eclipse_bar_width, cfg.eclipse_bar_height)
			lBar:SetStatusBarTexture(fill_texture)
			lBar:SetStatusBarColor(0/255, 108/255, 255/255)
			sBar:SetPoint('LEFT', lBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
			sBar:SetSize(cfg.eclipse_bar_width, cfg.eclipse_bar_height)
			sBar:SetStatusBarTexture(fill_texture)
			sBar:SetStatusBarColor(255/255, 166/255, 0/255)

			if cfg.showEclipseDirectionText then
				eBar.text = createFontstring(sBar, font, cfg.fontsize+2, Outline)
				eBar.text:SetPoint('CENTER', eBar, 'CENTER', 0, 1)
				eBar.text:SetTextColor(1,1,1,0.30)
			end

			eBar.spark = sBar:CreateTexture(nil, 'OVERLAY')
			eBar.spark:SetTexture(spark_texture)
			eBar.spark:SetBlendMode('ADD')
			eBar.spark:SetHeight(cfg.eclipse_bar_height+3.5)
			eBar.spark:SetWidth((cfg.eclipse_bar_height/3)*2)
			eBar.spark:SetPoint('CENTER', sBar, 'LEFT', 0, 0)
			eBar.spark:SetVertexColor(255/255, 166/255, 0/255)

			eBar.PostUnitAura = EclipsePostUnitAura
			--eBar.PostDirectionChange = EclipsePostDirChange

			eBar.LunarBar = lBar
			eBar.SolarBar = sBar
			self.EclipseBar = eBar

			-- Alpha
			self:RegisterEvent("PLAYER_ENTERING_WORLD", function(self) self.EclipseBar:SetAlpha(cfg.eclipse_ooc_alpha) end)
			self:RegisterEvent("PLAYER_REGEN_ENABLED", function(self) self.EclipseBar:SetAlpha(cfg.eclipse_ooc_alpha) end)
			self:RegisterEvent("PLAYER_REGEN_DISABLED", function(self) self.EclipseBar:SetAlpha(1) end)
		end
	end

	-- Healing Prediction
	local HealPrediction = function(self)

		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		mhpb:SetWidth(cfg.raid_width)
		mhpb:SetStatusBarTexture(bg_texture)
		mhpb:SetStatusBarColor(0, 1, .50, .60)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetWidth(cfg.raid_width)
		ohpb:SetStatusBarTexture(bg_texture)
		ohpb:SetStatusBarColor(0, 1, 0, .50, .60)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end

-- ------------------------------------------------------------------------
-- > 4. Addons
-- ------------------------------------------------------------------------

	-- oUF_AuraWatch
	local AuraWatch = function(self, unit)

		if IsAddOnLoaded("oUF_AuraWatch") and cfg.showRaidIconDebuffs then
			local auras = {}
			local spellIDs = IconDebuffs
			auras.presentAlpha = 1
			auras.missingAlpha = 0
			auras.PostCreateIcon = myPostCreateIconNoCC

			auras.icons = {}
			for i, sid in pairs(spellIDs) do
				local icon = CreateFrame("Frame", nil, self)
				icon:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
				icon:SetWidth(22)
				icon:SetHeight(22)
				icon:SetFrameLevel(4)
				icon.anyUnit = true
				icon.onlyShowPresent = true
				icon.spellID = sid
				auras.icons[sid] = icon
			end
			self.AuraWatch = auras
		end
	end

	-- oUF_TotemBar
	local TotemBars = function(self)

		if IsAddOnLoaded("oUF_TotemBar") and PlayerClass == "SHAMAN" then
			self.TotemBar = {}
			self.TotemBar.Destroy = true

			self.TotemBar.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
				self.TotemBar[i]:SetHeight(cfg.totem_height)
				self.TotemBar[i]:SetWidth(cfg.totem_width)
				if (i == 1) then
					self.TotemBar[i]:SetPoint('LEFT', self, 'RIGHT', cfg.totem_x or ((cfg.target_frame_x_from_player/2) - (((cfg.totem_width + cfg.totem_spacing) * 2) - (cfg.totem_spacing/2))), cfg.totem_y or 0)
				else
					self.TotemBar[i]:SetPoint('TOPLEFT', self.TotemBar[i-1], "TOPRIGHT", cfg.totem_spacing, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(fill_texture)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
				self.TotemBar[i].bg:SetTexture(bg_texture)
				self.TotemBar[i].bg.multiplier = 0.25
				self.TotemBar[i].bg:SetAlpha(1.0)
				if(cfg.show_totem_names) then
				self.TotemBar[i].Name = createFontstring(self.TotemBar[i], font, cfg.fontsize-3, Outline)
				self.TotemBar[i].Name:SetPoint("CENTER",self.TotemBar[i],"TOP",0,cfg.totem_height + 2)
				end
				SetBackdrop(self.TotemBar[i], 2, 2, 2, 2)

				-- Alpha
				self:RegisterEvent("PLAYER_ENTERING_WORLD", function(self) self.TotemBar[i]:SetAlpha(cfg.totem_ooc_alpha) end)
				self:RegisterEvent("PLAYER_REGEN_ENABLED", function(self) self.TotemBar[i]:SetAlpha(cfg.totem_ooc_alpha) end)
				self:RegisterEvent("PLAYER_REGEN_DISABLED", function(self) self.TotemBar[i]:SetAlpha(1) end)
			end
		end
	end

	-- oUF_Smooth
	local SmoothUpdate = function(self)

		if IsAddOnLoaded("oUF_Smooth") then
			self.Health.Smooth = true
			self.Power.Smooth = true
		end
	end

	-- oUF_Swing
	local function SwingBar(self)

		if IsAddOnLoaded("oUF_Swing") then
			self.Swing = CreateFrame("StatusBar", self:GetName().."_Swing", self)
			self.Swing:SetStatusBarTexture(fill_texture)
			self.Swing:GetStatusBarTexture():SetHorizTile(false)
			self.Swing:SetStatusBarColor(unpack(cfg.swingColor))
			self.Swing:SetPoint("BOTTOM", self.Castbar, "TOP", -10, 5)
			self.Swing:SetHeight(1)
			self.Swing:SetWidth(cfg.player_castbar_width+20)

			self.Swing.bg = self.Swing:CreateTexture(nil, "BORDER")
			self.Swing.bg:SetAllPoints(self.Swing)
			self.Swing.bg:SetTexture(bg_texture)
			self.Swing.bg:SetAlpha(0.30)

			SetBackdrop(self.Swing, 2, 2, 2, 2)
		end
	end

	-- oUF_SpellRange
	local function SpellRange(self)

		if IsAddOnLoaded("oUF_SpellRange") then
			self.SpellRange = {insideAlpha = 1, outsideAlpha = 0.60}
		end
	end

	-- oUF_CombatFeedback
	local CombatFeedback = function(self)

		if IsAddOnLoaded("oUF_CombatFeedback") then
			local cbft = self.Health:CreateFontString(nil, "ARTWORK")
			cbft:SetPoint("CENTER", self.Health, "CENTER", -2, 1)
			self.CombatFeedbackText = cbft
			self.CombatFeedbackText:SetFont(font, cfg.fontsize-1, Outline)
			self.CombatFeedbackText.maxAlpha = 0.75
			self.CombatFeedbackText.ignoreEnergize = true
		end
	end

	-- oUF_BarFader
	local BarFader = function(self)

		if IsAddOnLoaded("oUF_BarFader") then
			self.BarFade = true
			self.BarFaderMinAlpha = cfg.Bar_Fader_Alpha
		end
	end

	-- oUF_Experience
	local function ExperienceBar(self, unit)

		if(IsAddOnLoaded('oUF_Experience') and UnitLevel('player') < MAX_PLAYER_LEVEL) then

			local Experience = CreateFrame('StatusBar', nil, self)
			Experience:SetStatusBarTexture(fill_texture)
			Experience:SetStatusBarColor(178/255, 53/255, 240/255,1)
			Experience:SetPoint('BOTTOM', self.InfoBar,'TOP', 0, 6)
			Experience:SetHeight(cfg.expbar_height)
			Experience:SetWidth(cfg.mainframe_width)

			local Rested = CreateFrame('StatusBar', nil, Experience)
			Rested:SetStatusBarTexture(fill_texture)
			Rested:SetStatusBarColor(35/255, 127/255, 255/255,1)
			Rested:SetAllPoints(Experience)
			SetBackdrop(Rested, 2, 2, 2, 2)

			self.Experience = Experience
			self.Experience.Rested = Rested
			self.Experience.PostUpdate = ExperiencePostUpdate
			self.Experience.PreUpdate = ExperiencePreUpdate

			-- Tooltip
			self.Experience:EnableMouse()
			self.Experience:HookScript('OnEnter', XPTooltip)
			self.Experience:HookScript('OnLeave', GameTooltip_Hide)
		end
	end

	-- oUF_Repuation
	local function ReputationBar(self, unit)

		if(IsAddOnLoaded('oUF_Reputation')) then
			local Reputation = CreateFrame('StatusBar', nil, self)
			Reputation:SetStatusBarTexture(fill_texture)
			Reputation:SetPoint('BOTTOM', 0, -8)
			Reputation:SetHeight(cfg.repbar_height)
			Reputation:SetWidth(cfg.mainframe_width)
			SetBackdrop(Reputation, 2, 2, 2, 2)
			Reputation:SetBackdropColor(cfg.bdc.r,cfg.bdc.g,cfg.bdc.b,0.8)

			self.Reputation = Reputation
			self.Reputation.PostUpdate = ReputationPostUpdate

			-- Tooltip
			self.Reputation:EnableMouse()
			self.Reputation:HookScript('OnLeave', GameTooltip_Hide)
			self.Reputation:HookScript('OnEnter', RepTooltip)
		end
	end

	-- oUF_Debuff Highlight
	local DebuffHighlight = function(self)

		self.DebuffHighlightBackdrop = true
	end

-- ------------------------------------------------------------------------
-- > 5. Style
-- ------------------------------------------------------------------------

	-- The Shared Style Function
	local GlobalStyle = function(self, unit, isSingle)

		self.menu = SpawnMenu
		self:SetScale(cfg.scale)
		self:SetScript("OnEnter", OnEnter)
		self:SetScript("OnLeave", OnLeave)
		self:RegisterForClicks('AnyDown')
		if(cfg.show_mirrorbars) then MirrorBars() end
		SetBackdrop(self, 2, 2, 2, 2)

		-- HP Bar
		self.Health = CreateFrame("StatusBar", nil, self)
		self.Health:SetStatusBarTexture(fill_texture)
		self.Health:GetStatusBarTexture():SetHorizTile(false)
		self.Health:SetStatusBarColor(unpack(cfg.hpColor))
		self.Health:SetPoint("TOP")
		self.Health.frequentUpdates = true
		self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
		self.Health.bg:SetAllPoints(self.Health)
		self.Health.bg:SetAlpha(0.20)
		self.Health.bg:SetTexture(bg_texture)

		-- Power Bar
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetStatusBarTexture(fill_texture)
		self.Power:GetStatusBarTexture():SetHorizTile(false)
    	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.hp_spacing)
		self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture(bg_texture)
		self.Power.bg:SetAlpha(0.20)

		-- Mouseover Highlight
		local HL = self.Health:CreateTexture(nil, "OVERLAY")
		HL:SetAllPoints(self)
		HL:SetTexture(white_square)
		HL:SetVertexColor(1,1,1,.05)
		HL:SetBlendMode("ADD")
		HL:Hide()
		self.Highlight = HL

		-- Drop Shadow
		if cfg.useShadows then CreateDropShadow(self,5,5,{0,0,0,cfg.shadowAlpha}) end

		-- Colors
		if cfg.useClassColors then self.Health.colorClass = true end
		if cfg.useReactionColor then self.Health.colorReaction = true end
		self.Health.colorDisconnected = true
		self.Health.colorTapping = true
		if cfg.useClassColoredPower then self.Power.colorClass = true end
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		if not cfg.useClassColoredPower then self.Power.colorPower = true end
		self.Power.colorHappiness = false
	end

	-- The Shared Style Function for Party and Raid
	local GroupGlobalStyle = function(self, unit)

		self.menu = SpawnMenu
		self:SetScript("OnEnter", OnEnter)
		self:SetScript("OnLeave", OnLeave)
		self:RegisterForClicks('AnyDown')
		SetBackdrop(self, 2, 2, 2, 2)

		-- HP Bar
		self.Health = CreateFrame("StatusBar", nil, self)
		if(cfg.hp_inverted) then self.Health:SetStatusBarTexture(bg_texture) else self.Health:SetStatusBarTexture(raid_texture) end
		self.Health:GetStatusBarTexture():SetHorizTile(false)
		self.Health:SetPoint("TOP")
		self.Health.frequentUpdates = true
		self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
		self.Health.bg:SetAllPoints(self.Health)
		if(cfg.hp_inverted) then
			self.Health.bg:SetTexture(raid_texture)
			self.Health.bg:SetAlpha(0.95)
		else
			self.Health.bg:SetTexture(bg_texture)
			self.Health.bg:SetAlpha(0.20)
		end
		if(cfg.use_HealPrediction) then HealPrediction(self) end

		-- Power Bar
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetStatusBarTexture(fill_texture)
		self.Power:GetStatusBarTexture():SetHorizTile(false)
    	self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -cfg.hp_spacing)
		self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture(bg_texture)
		self.Power.bg:SetAlpha(0.20)

		-- Mouseover Highlight
		local HL = self.Health:CreateTexture(nil, "OVERLAY")
		HL:SetAllPoints(self)
		HL:SetTexture(white_square)
		HL:SetVertexColor(1,1,1,.05)
		HL:SetBlendMode("ADD")
		HL:Hide()
		self.Highlight = HL

		-- Drop Shadow
		if cfg.useShadows then CreateDropShadow(self,4,4,{0,0,0,cfg.shadowAlpha}) end

		-- Colors
		if cfg.userGradientColor then self.Health.colorClass = false else self.Health.colorClass = true end
		self.Health.colorReaction = true -- For Main Tank Targets
		self.Health.colorDisconnected = false
		self.Health.colorTapping = false
		self.Power.colorTapping = false
		self.Power.colorDisconnected = false
		self.Power.colorPower = true
		self.Power.colorHappiness = false
	end

	-- Unit Specific Styles
	local UnitSpecific = {

		player = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "player"
			self.Power.frequentUpdates = true
			self:SetHitRectInsets(0,0,-(cfg.InforBar_shift+cfg.InforBar_height+4),0)

			-- Size
			self:SetSize(cfg.mainframe_width, cfg.mainframe_height)
			self.Health:SetHeight(cfg.mainframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.mainframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.mainframe_width)

			-- Fontstrings
			createHPString(self, font, cfg.fontsize-2, Outline, -4, 0, "RIGHT")
			createPercentString(self, font, cfg.fontsize+3, Outline, 6, 1, "RIGHT", "LEFT")
			createPPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")
			createPercentPPString(self, font, cfg.fontsize-2, Outline, -2, 0, "RIGHT")
			createNameString(self, font, cfg.fontsize-1, Outline, 4, 0, "LEFT", cfg.mainframe_width - 52)

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateHP
			self.Power.PostUpdate = PostUpdatePower

			-- Buffs and Debuffs
			if cfg.show_player_debuffs then createDebuffs(self) end
			if(cfg.show_BarTimers) then createAuraWatchers(self) end

			-- InfoBar
			SetInfoBar(self)

			-- Portraits
			if cfg.show_portraits then
				CreatePortraits(self)
				self.Portrait.PostUpdate = myPortraitPostUpdate
			end

			-- Other
			if cfg.show_castbars then CreateCastbar(self, ...) end
			if cfg.use_Paladin_HP_numbers then PaladinHolyPowerCount(self) else PaladinHolyPower(self) end
			-- if cfg.use_Warlock_Resources_numbers then else  end
			if cfg.show_eclipsebar then MoonkinEclipseBar(self) end
			if cfg.use_Monk_Chi_numbers then MonkChiCount(self) else MonkChi(self) end
			if cfg.show_shadowOrbs_count then PriestShadowOrbsCount(self) end
			RaidIcons(self)
			DruidPowa(self)
			RunesBar(self)

			-- Plugins
			BarFader(self)
			CombatFeedback(self)
			ExperienceBar(self, unit)
			ReputationBar(self, unit)
			SmoothUpdate(self)
			SwingBar(self)
			TotemBars(self)
			DebuffHighlight(self)
		end,

		target = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "target"
			self:SetHitRectInsets(0,0,-(cfg.InforBar_shift+cfg.InforBar_height+4),0)

			-- Size
			self:SetSize(cfg.mainframe_width, cfg.mainframe_height)
			self.Health:SetHeight(cfg.mainframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.mainframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.mainframe_width)

			-- Fontstrings
			createHPString(self, font, cfg.fontsize-2, Outline, -4, 0, "RIGHT")
			createPercentString(self, font, cfg.fontsize+3, Outline, -6, 1, "LEFT", "RIGHT")
			createPPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")
			createPercentPPString(self, font, cfg.fontsize-2, Outline, -2, 0, "RIGHT")
			createNameString(self, font, cfg.fontsize-1, Outline, 4, 0, "LEFT", cfg.mainframe_width - 52)

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateHP
			self.Power.PostUpdate = PostUpdatePower

			-- Buffs and Debuffs
			if cfg.show_target_buffs then createBuffs(self) end
			if cfg.show_target_debuffs then createDebuffs(self) end
			if(cfg.show_BarTimers) then createAuraWatchers(self) end

			-- InfoBar
			SetInfoBar(self)

			-- Portraits
			if cfg.show_portraits then
				CreatePortraits(self)
				self.Portrait.PostUpdate = myPortraitPostUpdate
			end

			-- Other
			if(cfg.show_castbars) then CreateCastbar(self, ...) end
			RaidIcons(self)
			PhaseIcon(self)
			QuestIcon(self)
			if(cfg.use_ComboPoints) then ComboPoints(self) end -- Combo Points

			-- Plugins
			BarFader(self)
			CombatFeedback(self)
			SmoothUpdate(self)
			SpellRange(self)
		end,

		focus = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "focus"

			-- Size
			self:SetSize(cfg.secondaryframe_width, cfg.secondaryframe_height)
			self.Health:SetHeight(cfg.secondaryframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.secondaryframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.secondaryframe_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", cfg.secondaryframe_width - 15)

			-- Buffs and Debuffs
			if cfg.show_focus_debuffs then createDebuffs(self) end

			-- Other
			if(cfg.show_castbars) then CreateCastbar(self, ...) end

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,

		targettarget = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "tot"

			-- Size
			self:SetSize(cfg.secondaryframe_width, cfg.secondaryframe_height)
			self.Health:SetHeight(cfg.secondaryframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.secondaryframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.secondaryframe_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", 46)

			-- Buffs and Debuffs
			if cfg.show_ToT_debuffs then createDebuffs(self) end

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,

		focustarget = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "focustarget"

			-- Size
			self:SetSize(cfg.secondaryframe_width, cfg.secondaryframe_height)
			self.Health:SetHeight(cfg.secondaryframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.secondaryframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.secondaryframe_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", cfg.secondaryframe_width - 15)

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,

		pet = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "pet"

			-- Size
			self:SetSize(cfg.secondaryframe_width, cfg.secondaryframe_height)
			self.Health:SetHeight(cfg.secondaryframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.secondaryframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.secondaryframe_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", cfg.secondaryframe_width - 15)

			-- Buffs and Debuffs
			if cfg.show_pet_buffs then createBuffs(self) end

			-- Hunter Pet Hapiness
			-- if PlayerClass == "HUNTER" then
				-- self.Health.colorReaction = false
				-- self.Health.colorClass = false
				-- self.Health.colorHappiness = true
			-- end

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,

		pettarget = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "pettarget"

			-- Size
			self:SetSize(cfg.secondaryframe_width, cfg.secondaryframe_height)
			self.Health:SetHeight(cfg.secondaryframe_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.secondaryframe_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.secondaryframe_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", cfg.secondaryframe_width - 15)

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,

		party = function(self, ...)

			GroupGlobalStyle(self, ...)

			self.mystyle = "party"

			-- Size
			self.Health:SetHeight(cfg.party_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.party_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.party_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER", cfg.party_width - 10)
			createHPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateRaidFrame
			self.Power.PostUpdate = PostUpdatePPRaidFrame

			-- Borders
			CreateHPBorder(self)
			CreateThreatBorder(self)
			CreateTargetBorder(self)

			-- Range Alpha
			self.Range = {insideAlpha = 1, outsideAlpha = cfg.GroupUnit_FadeOutAlpha}

			-- ReadyCheck
			rCheck = self.Health:CreateTexture(nil, "OVERLAY")
			rCheck:SetSize(12, 12)
			rCheck:SetPoint("BOTTOMLEFT", self.Power, "LEFT", -6, -6)
			rCheck.finishedTimer = 10
			rCheck.fadeTimer = 2
			self.ReadyCheck = rCheck

			-- Leader Icon
			if(cfg.party_leader_icon) then
			LI = self.Health:CreateTexture(nil, "OVERLAY")
			LI:SetSize(12, 12)
			LI:SetPoint("CENTER", self.Health, "TOP", 0, 0)
			self.Leader = LI
			end

			-- Other
			LFGRole(self)
			Dispell(self, unit)
			if cfg.show_CornerIndicators then createAuraWatchers(self) end

			-- Plugins
			SmoothUpdate(self)
			AuraWatch(self, unit) -- Debuff Icons
		end,

		partypet = function(self, ...)

			GroupGlobalStyle(self, ...)

			self.mystyle = "partypet"

			-- Size
			self.Health:SetHeight(cfg.party_pets_height)
			self.Health:SetWidth(cfg.party_pets_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER", cfg.party_width - 10)
			createHPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateRaidFrame
			self.Power.PostUpdate = PostUpdatePPRaidFrame

			-- Borders
			CreateHPBorder(self)
			CreateThreatBorder(self)
			CreateTargetBorder(self)

			-- Range Alpha
			self.Range = {insideAlpha = 1, outsideAlpha = cfg.GroupUnit_FadeOutAlpha}

			-- Other
			Dispell(self, unit)
			if cfg.show_CornerIndicators then createAuraWatchers(self) end
		end,

		raid = function(self, ...)

			GroupGlobalStyle(self, ...)

			self.mystyle = "raid"

			-- Size
			self.Health:SetHeight(cfg.raid_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.raid_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.raid_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER", cfg.raid_width - 10)
			createHPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateRaidFrame
			self.Power.PostUpdate = PostUpdatePPRaidFrame

			-- Borders
			CreateHPBorder(self)
			CreateThreatBorder(self)
			CreateTargetBorder(self)

			-- Range Alpha
			self.Range = {insideAlpha = 1, outsideAlpha = cfg.GroupUnit_FadeOutAlpha}

			-- ReadyCheck
			rCheck = self.Health:CreateTexture(nil, "OVERLAY")
			rCheck:SetSize(12, 12)
			rCheck:SetPoint("BOTTOMLEFT", self.Power, "LEFT", -6, -6)
			rCheck.finishedTimer = 10
			rCheck.fadeTimer = 2
			self.ReadyCheck = rCheck

			-- Leader Icon
			if(cfg.party_leader_icon) then
			LI = self.Health:CreateTexture(nil, "OVERLAY")
			LI:SetSize(12, 12)
			LI:SetPoint("CENTER", self.Health, "TOP", 0, 0)
			self.Leader = LI
			end

			-- Other
			Dispell(self, unit)
			if cfg.show_CornerIndicators then createAuraWatchers(self) end

			-- Plugins
			SmoothUpdate(self)
			AuraWatch(self, unit) -- Debuff Icons
		end,

		maintank = function(self, ...)

			GroupGlobalStyle(self, ...)

			self.mystyle = "maintank"

			-- Size
			self.Health:SetHeight(cfg.mt_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.mt_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.mt_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER", cfg.mt_width - 10)
			createHPString(self, font, cfg.fontsize-2, Outline, 0, 0, "CENTER")

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateRaidFrame
			self.Power.PostUpdate = PostUpdatePPRaidFrame

			-- Borders
			CreateHPBorder(self)
			CreateThreatBorder(self)
			CreateTargetBorder(self)

			-- Range Alpha -- Bugged for MT Targets
			--self.Range = {insideAlpha = 1, outsideAlpha = cfg.GroupUnit_FadeOutAlpha}

			-- Other
			Dispell(self, unit)
			if cfg.show_CornerIndicators then createAuraWatchers(self) end
		end,

		boss = function(self, ...)

			GlobalStyle(self, ...)

			self.mystyle = "boss"

			-- Size
			self:SetSize(cfg.BossFrames_width, cfg.BossFrames_height)
			self.Health:SetHeight(cfg.BossFrames_height - cfg.hp_spacing - cfg.power_height)
			self.Health:SetWidth(cfg.BossFrames_width)
			self.Power:SetHeight(cfg.power_height)
    		self.Power:SetWidth(cfg.BossFrames_width)

			-- Fontstrings
			createNameString(self, font, cfg.fontsize-3, Outline, 4, 0, "LEFT", cfg.BossFrames_width - 15)
			--createHPString(self, font, cfg.fontsize-2, Outline, -4, 0, "RIGHT")
			--createPercentString(self, font, cfg.fontsize+3, Outline, -6, 1, "LEFT", "RIGHT")

			-- Health & Power Updates
			self.Health.PostUpdate = PostUpdateHP
			self.Power.PostUpdate = PostUpdatePower

			-- Other
			RaidIcons(self)

			-- Plugins
			SmoothUpdate(self)
			SpellRange(self)
			BarFader(self)
		end,
	}

-- ------------------------------------------------------------------------
-- > 6. Spawn the Frames
-- ------------------------------------------------------------------------

	for unit,layout in next, UnitSpecific do
		oUF:RegisterStyle('lumen - ' .. unit:gsub("^%l", string.upper), layout)
	end

	local spawnHelper = function(self, unit, ...)

		if(UnitSpecific[unit]) then
			self:SetActiveStyle('lumen - ' .. unit:gsub("^%l", string.upper))
			local object = self:Spawn(unit)
			object:SetPoint(...)
			return object
		else
			self:SetActiveStyle'lumen'
			local object = self:Spawn(unit)
			object:SetPoint(...)
			return object
		end
	end

	oUF:RegisterStyle('lumen', GlobalStyle)
	oUF:RegisterStyle('lumen - Group', GroupGlobalStyle)

	-- Single Units
	oUF:Factory(function(self)
		-- Single Frames
		if(cfg.show_PlayerFrame) then spawnHelper(self, 'player', "RIGHT", UIParent , "CENTER" , cfg.player_frame_x, cfg.player_frame_y) end
		if(cfg.show_TargetFrame) then spawnHelper(self, 'target', "TOPLEFT", oUF_lumenPlayer, "TOPRIGHT", cfg.target_frame_x_from_player, cfg.target_frame_y_from_player) end
		if(cfg.show_FocusFrame) then spawnHelper(self,  'focus', "TOPLEFT", oUF_lumenPlayer, "TOPLEFT", 0, cfg.secondaryframe_height + cfg.InforBar_height + cfg.InforBar_shift + exp_shift + 8) end
		if(cfg.show_ToTFrame) then spawnHelper(self,  'targettarget', "TOPRIGHT", oUF_lumenTarget, "TOPRIGHT", 0, cfg.secondaryframe_height + cfg.InforBar_height + cfg.InforBar_shift + 8) end
		if(cfg.show_FocusTargetFrame) then spawnHelper(self,  'focustarget', "TOPLEFT", oUF_lumenFocus, "TOPRIGHT", 6, 0) end
		if(cfg.show_PetFrame) then spawnHelper(self,  'pet', "BOTTOMLEFT", oUF_lumenPlayer, cfg.pet_x, cfg.pet_y - rep_shift) end
		if(cfg.show_PetTargetFrame) then spawnHelper(self,  'pettarget', "BOTTOMRIGHT", oUF_lumenPlayer, cfg.pett_x, cfg.pett_y - rep_shift) end

		-- Party Frames
		if cfg.show_PartyFrame and not cfg.party_inRaid_instead then
			self:SetActiveStyle('lumen - Party')
			local party = oUF:SpawnHeader('oUF_Party', nil, "custom  [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide",
			--local party = oUF:SpawnHeader('oUF_Party', nil, "party",
			--local party = oUF:SpawnHeader('oUF_Party', nil, "solo", "showSolo", true,  -- debug
			"showParty", cfg.show_PartyFrame,
			"showPlayer", cfg.show_Player_inParty,
    		"xoffset", 7,
    		"columnSpacing", 7,
			"groupBy", "CLASS",
    		"groupingOrder", "WARRIOR,PALADIN,DRUID,DEATHKNIGHT,SHAMAN,PRIEST,MAGE,WARLOCK,ROGUE,HUNTER", -- Trying to put classes that can tank first
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%d)
    		]]):format(cfg.party_width, cfg.party_height, cfg.scale))
			party:SetPoint("CENTER", cfg.party_pos_x, cfg.party_pos_y)
		end

		if cfg.show_PartyPetsFrame and cfg.show_PartyFrame and not cfg.party_inRaid_instead then
			self:SetActiveStyle('lumen - Partypet')
			local pets = oUF:SpawnHeader('oUF_PartyPets', 'SecureGroupPetHeaderTemplate', "custom  [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide",
			--local pets = oUF:SpawnHeader('oUF_PartyPets', 'SecureGroupPetHeaderTemplate', "solo", "showSolo", true,  -- debug
			"showParty", cfg.show_PartyFrame,
			"showPlayer", cfg.show_Player_inParty,
			"xoffset", 7,
			"columnSpacing", 7,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"useOwnerUnit", true,
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%d)
			self:SetAttribute('unitsuffix', 'pet')
			]]):format(cfg.party_pets_width, cfg.party_pets_height, cfg.scale))
			pets:SetPoint("TOPLEFT", "oUF_Party", "BOTTOMLEFT", 0, -6)
   		end

		-- Raid	Frames
		if cfg.show_RaidFrame then
			self:SetActiveStyle('lumen - Raid')
			local raid = oUF:SpawnHeader("oUF_Raid", nil, "solo,party,raid10,raid25,raid40", -- Till 6 members raid will display in Party frames. This allows for several stylings of raid sizes
			--local raid = oUF:SpawnHeader("oUF_Raid", nil, "solo,party,raid,raid10,raid25,raid40", -- debug
			"showRaid", cfg.show_RaidFrame,
			"showPlayer", true,
			"showSolo", cfg.show_Raid_Solo,
			"showParty", cfg.party_inRaid_instead,
    		"xoffset", 7,
    		"yOffset", 7,
    		"groupFilter", "1,2,3,4,5",
			"groupBy", "GROUP",
    		"groupingOrder", "1,2,3,4,5",
			"sortMethod", "NAME",
    		"maxColumns", 5,
    		"unitsPerColumn", 5,
    		"columnSpacing", 7,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%d)
    		]]):format(cfg.raid_width, cfg.raid_height, cfg.scale))
    		raid:SetPoint("TOPLEFT", oUF_lumenTarget, "BOTTOMRIGHT", cfg.raid_pos_x, cfg.raid_pos_y)
		end

		-- Main Tank Frames
		if cfg.show_MainTanks then
			self:SetActiveStyle('lumen - Maintank')
			-- Main Tank
			local maintank = self:SpawnHeader("oUF_MainTank", nil, "raid, party",
			"showRaid", true,
			"xoffset", 7,
    		"yOffset", 7,
			"maxColumns", 1,
    		"unitsPerColumn", 5,
			"columnSpacing", 7,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"sortMethod", "NAME",
			"groupFilter", "MAINTANK",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%d)
			]]):format(cfg.mt_width, cfg.mt_height, cfg.scale))
			maintank:SetPoint("TOPLEFT", oUF_lumenTarget, "BOTTOMRIGHT", cfg.mt_pos_x, cfg.mt_pos_y)

			-- Main Tank
			local maintanktarget = self:SpawnHeader(nil, nil, "raid, party",
			"showRaid", true,
			"xoffset", 7,
    		"yOffset", 7,
			"maxColumns", 1,
    		"unitsPerColumn", 5,
			"columnSpacing", 7,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"groupFilter", "MAINTANK",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			self:SetScale(%d)
			self:SetAttribute('unitsuffix', 'target')
			]]):format(cfg.mt_width, cfg.mt_height, cfg.scale))
			maintanktarget:SetPoint("TOPLEFT", oUF_lumenTarget, "BOTTOMRIGHT", cfg.mt_pos_x, cfg.mt_pos_y + 28)
		end

		-- Boss Frames
		if cfg.show_BossFrames then
			self:SetActiveStyle("lumen - Boss")
			local boss = {}
			for i = 1, MAX_BOSS_FRAMES do
				boss[i] = self:Spawn("boss"..i, "oUF_lumenBoss"..i)
				if i == 1 then
					boss[i]:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", cfg.BossFrames_pos_x, cfg.BossFrames_pos_y)
				else
					boss[i]:SetPoint("TOPLEFT", boss[i-1], "BOTTOMLEFT", 0, -40)
				end
			end
		end

	end)

-- ------------------------------------------------------------------------
-- > A. Appendix
-- ------------------------------------------------------------------------

	-- Hide Blizzard Compact Raid Frames
	if cfg.hideBlizzCompactRaidFrames then
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer:Hide()
		CompactRaidFrameContainer:Hide()
	end

	-- Events
	lum:RegisterEvent("PLAYER_LEVEL_UP")
	lum:RegisterEvent("UPDATE_FACTION")
	lum:SetScript("OnEvent", function() UpdateAnchors() end)
