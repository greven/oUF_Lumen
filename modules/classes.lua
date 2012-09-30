-- ------------------------------------------------------------------------
-- > Class Specific Functions
-- ------------------------------------------------------------------------

	local addon, ns = ...
	local cfg = ns.cfg

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
		if(PlayerClass == "ROGUE" and cfg.RogueDPT) then
			DPTracker = self:CreateFontString(nil, 'OVERLAY')
			DPTracker:SetPoint('BOTTOMLEFT', CPoints, 'TOPRIGHT',0,-10)
			DPTracker:SetFont(font, cfg.fontsize+1, "OUTLINE")
			DPTracker:SetJustifyH('CENTER')
			DPTracker:SetShadowOffset(1, -1)
			self:Tag(DPTracker, '[lumen:dp]')
		end
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
	
	-- Warlock Soul Shards Override
	local ssOverride = function(self, event, unit, powerType)
		
		if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end

		local ss = self.SoulShards

		local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
		for i = 1, SHARD_BAR_NUM_SHARDS do
			if(i <= num) then
				ss[i]:SetAlpha(1)
			else
				ss[i]:SetAlpha(cfg.shards_depleted_alpha)
			end
		end
	end
	
	-- Warlock Shards
	local WarlockShards = function(self)

		if(cfg.show_WL_shards and PlayerClass == "WARLOCK") then
			self.SoulShards = CreateFrame("Frame", nil, self)
			self.SoulShards.Override = ssOverride
			
			for i= 1, 3 do
				self.SoulShards[i] = CreateFrame("StatusBar", self:GetName().."_Shards"..i, self)
				self.SoulShards[i]:SetHeight(cfg.WL_shards_height)
				self.SoulShards[i]:SetWidth((cfg.WL_shards_width))
				
				self.SoulShards[i]:SetStatusBarTexture(fill_texture)
				local color = self.colors.power["SOUL_SHARDS"]
				self.SoulShards[i]:SetStatusBarColor(color[1], color[2], color[3])	
				SetBackdrop(self.SoulShards[i], 2, 2, 2, 2)
				if (i == 1) then
					self.SoulShards[i]:SetPoint('LEFT', self, 'RIGHT', cfg.shards_x or ((cfg.target_frame_x_from_player/2) - (((cfg.WL_shards_width + cfg.shards_spacing) * 1.5) - (cfg.shards_spacing/2))), cfg.shards_y or 0)
				else
					self.SoulShards[i]:SetPoint('TOPLEFT', self.SoulShards[i-1], "TOPRIGHT", cfg.shards_spacing, 0)
				end	
			end
		end
	end
	
	-- Warlock Shards in Number Format
	local WarlockShardsCount = function(self)
	
		if(PlayerClass == "WARLOCK") then
			local SoulShards = self:CreateFontString(nil, 'OVERLAY')
			SoulShards:SetPoint('CENTER', self, 'RIGHT', cfg.php_count_x or (cfg.target_frame_x_from_player/2), cfg.php_count_y or 0)
			SoulShards:SetFont(font, cfg.fontsize*3, "OUTLINE")
			SoulShards:SetJustifyH('CENTER')
			SoulShards:SetShadowOffset(1, -1)
			self:Tag(SoulShards, '[lumen:warlockshards]')
		end
	end
	
	-- Paladin Holy Power with StatusBar
	local PaladinHolyPower = function(self)
	
		if(cfg.show_PL_HolyPower and PlayerClass == "PALADIN") then
			self.HolyPower = CreateFrame("Frame", nil, self)
			
			for i= 1, 3 do
				self.HolyPower[i] = CreateFrame("StatusBar", self:GetName().."_Shards"..i, self)
				self.HolyPower[i]:SetHeight(cfg.PL_hp_height)
				self.HolyPower[i]:SetWidth((cfg.PL_hp_width))
				
				self.HolyPower[i]:SetStatusBarTexture(fill_texture)
				--local color = self.colors.power["HOLY_POWER"]
				--self.HolyPower[i]:SetStatusBarColor(color[1], color[2], color[3])
				self.HolyPower[i]:SetStatusBarColor(245/255, 102/255, 165/255)
				SetBackdrop(self.HolyPower[i], 2, 2, 2, 2)
				if (i == 1) then
					self.HolyPower[i]:SetPoint('LEFT', self, 'RIGHT', cfg.PL_hp_x or ((cfg.target_frame_x_from_player/2) - (((cfg.PL_hp_width + cfg.PL_hp_spacing) * 1.5) - (cfg.PL_hp_spacing/2))), cfg.PL_hp_y or 0)
				else
					self.HolyPower[i]:SetPoint('TOPLEFT', self.HolyPower[i-1], "TOPRIGHT", cfg.PL_hp_spacing, 0)
				end	
			end
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

	-- Monk Chi
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
	