-- ------------------------------------------------------------------------
-- > Addons
-- ------------------------------------------------------------------------

	local addon, ns = ...
	local cfg = ns.cfg

	-- oUF_AuraWatch
	AuraWatch = function(self, unit)
		
		if IsAddOnLoaded("oUF_AuraWatch") and cfg.showRaidIconDebuffs then
			local auras = {}
			local spellIDs = cfg.IconDebuffs	
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
	TotemBars = function(self)
	
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
	SmoothUpdate = function(self)
	
		if IsAddOnLoaded("oUF_Smooth") then
			self.Health.Smooth = true
			self.Power.Smooth = true	
		end	
	end
	
	-- oUF_Swing
	function SwingBar(self)
			
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
	function SpellRange(self)
	
		if IsAddOnLoaded("oUF_SpellRange") then	
			self.SpellRange = {insideAlpha = 1, outsideAlpha = 0.60}		
		end
	end
	
	-- oUF_CombatFeedback
	CombatFeedback = function(self)
	
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
	BarFader = function(self)
	
		if IsAddOnLoaded("oUF_BarFader") then		
			self.BarFade = true
			self.BarFaderMinAlpha = cfg.Bar_Fader_Alpha	
		end
	end

	-- oUF_Experience
	function ExperienceBar(self, unit) 
	
		if(IsAddOnLoaded('oUF_Experience')) then
			
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
			self.Experience:HookScript('OnLeave', GameTooltip_Hide)
			self.Experience:HookScript('OnEnter', XPTooltip)			
		end
	end
	
	-- oUF_Repuation
	function ReputationBar(self, unit)
		
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
	DebuffHighlight = function(self)
	
		self.DebuffHighlightBackdrop = true
	end
