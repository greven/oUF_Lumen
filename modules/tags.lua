-- ------------------------------------------------------------------------
-- > Custom Tags
-- ------------------------------------------------------------------------
	
	local addon, ns = ...
	local colors = ns.colors

	-- Name	
	oUF.Tags.Methods["lumen:name"] = function(u, r)
			
		return UnitName(r or u)
	end
	oUF.Tags.Events["lumen:name"] = "UNIT_NAME_UPDATE UNIT_ENTERING_VEHICLE UNIT_ENTERED_VEHICLE UNIT_EXITING_VEHICLE UNIT_EXITED_VEHICLE"
	
	-- Player Flags (AFK, DND, Combat...)
	oUF.Tags.Methods["lumen:Info"] = function(unit) 
		
		local Status 
	
		if(UnitAffectingCombat(unit)) then -- 1. Combat
			if(UnitIsPlayer(unit)) then
				Status = string.format("|cff%02x%02x%02xcbt|r", unpack(colors.TEXT.Red))
			else
				local _, status, percent = UnitDetailedThreatSituation('player', 'target')
				if(percent and percent > 0) then
					Status = ('%s%d%%|r'):format(Hex(GetThreatStatusColor(status)), percent)
				else
					Status = string.format("|cff%02x%02x%02xcbt|r", unpack(colors.TEXT.Red))
				end
			end	
		elseif(UnitIsAFK(unit)) then
			Status = string.format("|cff%02x%02x%02xafk|r", unpack(colors.TEXT.Yellow)) -- 2. AFK
		elseif(UnitIsDND(unit)) then
			Status = string.format("|cff%02x%02x%02xdnd|r", unpack(colors.TEXT.Yellow)) -- 3. DND
		elseif(unit == 'player' and IsResting() and (UnitLevel('player') < MAX_PLAYER_LEVEL)) then
			Status = string.format("|cff%02x%02x%02xzZz|r", unpack(colors.TEXT.Blue)) -- 4. Resting and < Max Level
		elseif(unit == 'player' and UnitIsPVP(unit)) then -- 5. PvP
			local isPvPtimer, PvPtime, PvPdesired = IsPVPTimerRunning(), math.floor(GetPVPTimer()/1000), GetPVPDesired()
			if isPvPtimer then 
				Status = string.format("|CFF9bff00PvP|r %d|cffaaaaaa%s|r", (PvPtime > 60 and math.floor(PvPtime/60)) or (PvPtime%60), (PvPtime > 60 and 'm') or 's')
			elseif(PvPdesired == 1) then 
				Status = string.format("|cff%02x%02x%02xPvP|r", unpack(colors.TEXT.Green))
			end
		end
		return Status
	end
	oUF.Tags.Events["lumen:Info"] = "PLAYER_ENTERING_WORLD PLAYER_FLAGS_CHANGED PLAYER_REGEN_DISABLED PLAYER_REGEN_ENABLED PLAYER_UPDATE_RESTING UNIT_FACTION UNIT_THREAT_LIST_UPDATE"
	
	-- Smart Level	
	oUF.Tags.Methods["lumen:level"] = function(unit)
		
		local c, l, ur, t = UnitClassification(unit), UnitLevel(unit), UnitRace(unit), UnitCreatureFamily(unit)
		local d = GetQuestDifficultyColor(l)

		if (not t) then t = '' end
		
		local str = l -- Fallback value
			
		if l <= 0 then l = "??" end
		
		if c == "worldboss" then
			str = string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02xBoss|r",d.r*255,d.g*255,d.b*255,l,250,20,0)
		elseif c == "eliterare" then
			str = string.format("|cff%02x%02x%02x%s|r |cff0080FFRare|r Elite",d.r*255,d.g*255,d.b*255,l)
		elseif c == "elite" then
			str = string.format("|cff%02x%02x%02x%s|r Elite",d.r*255,d.g*255,d.b*255,l)
		elseif c == "rare" then
			str = string.format("|cff%02x%02x%02x%s|r |cff0080FFRare|r",d.r*255,d.g*255,d.b*255,l)
		else
			if not UnitIsConnected(unit) then
				str = "??"
			else
				if UnitIsPlayer(unit) then
					str = string.format("|cff%02x%02x%02x%s |cffffffff%s",d.r*255,d.g*255,d.b*255,l,ur)
				elseif UnitPlayerControlled(unit) then
					str = string.format("|cff%02x%02x%02x%s|r |cffc2c2c2%s|r",d.r*255,d.g*255,d.b*255,l,t)
				else
					str = string.format("|cff%02x%02x%02x%s|r",d.r*255,d.g*255,d.b*255,l)
				end
			end		
		end	
		return str
	end
	oUF.Tags.Events["lumen:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
	
	-- ComboPoints
	oUF.Tags.Methods["lumen:cp"] = function(unit)
	
		local cp		
		if(UnitExists'vehicle') then
			cp = GetComboPoints('vehicle', 'target')
		else
			cp = GetComboPoints('player', 'target')
		end
	
		if (cp == 1) then
			return string.format("|cff69e80c%d|r",cp)
		elseif cp == 2 then
			return string.format("|cffb2e80c%d|r",cp)
		elseif cp == 3 then
			return string.format("|cffffd800%d|r",cp) 
		elseif cp == 4 then
			return string.format("|cffffba00%d|r",cp) 
		elseif cp == 5 then
			return string.format("|cfff10b0b%d|r",cp)
		end
	end
	oUF.Tags.Events["lumen:cp"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED"
	
	-- Deadly Poison Tracker
	oUF.Tags.Methods["lumen:dp"] = function(unit)
	
		local Spell = "Deadly Poison" or GetSpellInfo(43233)
		local ct, cp = hasUnitDebuff(unit, Spell, true), GetComboPoints('player', 'target')
		
		if cp > 0 then -- If Combo Points are bigger than 1 Show Deadly Poison Stack
			if (ct == 1) then
				return string.format("|cffc1e79f%d|r",ct)
			elseif ct == 2 then
				return string.format("|cfface678%d|r",ct)
			elseif ct == 3 then
				return string.format("|cff9de65c%d|r",ct) 
			elseif ct == 4 then
				return string.format("|cff8be739%d|r",ct) 
			elseif ct == 5 then
				return string.format("|cff90ff00%d|r",ct)
			end
		else
			return ""
		end
	end
	oUF.Tags.Events["lumen:dp"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED UNIT_AURA"
	
	-- Holy Power
	oUF.Tags.Methods["lumen:holypower"] = function(unit)
	
		local hp = UnitPower('player', SPELL_POWER_HOLY_POWER)
		
		if hp > 0 then
			if hp == 1 then
				return string.format("|CFFffffff%d|r",hp)
			elseif hp == 2 then
				return string.format("|CFFfff880%d|r",hp)
			elseif hp == 3 then
				return string.format("|CFFf5e92f%d|r",hp)
			end
		end
	end
	oUF.Tags.Events["lumen:holypower"] = "UNIT_POWER"
	
	-- Warlock Shards
	oUF.Tags.Methods["lumen:warlockshards"] = function(unit)
	
		local ss = UnitPower('player', SPELL_POWER_SOUL_SHARDS)
		
		if ss > 0 then
			if ss == 1 then
				return string.format("|CFFedc7ff%d|r",ss)
			elseif ss == 2 then
				return string.format("|CFFcf68ff%d|r",ss)
			elseif ss == 3 then
				return string.format("|CFFae00ff%d|r",ss)
			end
		end
	end
	oUF.Tags.Events["lumen:warlockshards"] = "UNIT_POWER"


	-- Monk Chi
	oUF.Tags.Methods["lumen:monkchi"] = function(unit)
	
		local ch = UnitPower('player', SPELL_POWER_LIGHT_FORCE)

		if ch > 0 then
			if ch == 1 then
				return string.format("|CFFe2eeff%d|r",ch)
			elseif ch == 2 then
				return string.format("|CFFa7ccff%d|r",ch)
			elseif ch == 3 then
				return string.format("|CFF6eabff%d|r",ch)
			elseif ch == 4 then
				return string.format("|CFF1d7dff%d|r",ch)
			elseif ch == 5 then
				return string.format("|CFF026dff%d|r",ch)
			end
		end
	end
	oUF.Tags.Events["lumen:monkchi"] = "UNIT_POWER"
	
	-- LFGRole
	oUF.Tags.Methods["lumen:lfdrole"] = function(unit)
	
		local role = UnitGroupRolesAssigned(unit)
		if role == 'DAMAGER' then role = 'DPS' end
		if role then return role end
	end
	oUF.Tags.Events["lumen:lfdrole"] = "PARTY_MEMBERS_CHANGED PLAYER_ROLES_ASSIGNED"
	
	-- Druid Mana
	oUF.Tags.Methods["lumen:druidPower"] = function(unit)
	 
		local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
				
		if (UnitPowerType(unit) ~= 0) and min ~= max then -- If Power Type is not Mana(it's Energy or Rage) and Mana is not at Maximum
			return string.format('|cff009cff %d%%|r', (min/max * 100))
		end
	end
	oUF.Tags.Events["lumen:druidPower"] = "UNIT_MAXPOWER UNIT_POWER UPDATE_SHAPESHIFT_FORM"