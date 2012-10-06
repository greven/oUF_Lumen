--[[--------------------------------------------------------------------
	oUF_WarlockPower
	by Phanx <addons@phanx.net>
	Adds support for the new (in WoW 5.0) warlock resources.

	You may embed this module in your own layout, but please do not
	distribute it as a standalone plugin.
----------------------------------------------------------------------]]

local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local WARLOCK_SOULBURN = WARLOCK_SOULBURN
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY
local WARLOCK_METAMORPHOSIS = WARLOCK_METAMORPHOSIS
local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY

local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local WARLOCK_BURNING_EMBERS = WARLOCK_BURNING_EMBERS
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local MAX_POWER_PER_EMBER = MAX_POWER_PER_EMBER

local powerTypes = {
	SOUL_SHARDS = true,
	DEMONIC_FURY = true,
	BURNING_EMBERS = true,
	[SPEC_WARLOCK_AFFLICTION] = "SOUL_SHARDS",
	[SPEC_WARLOCK_DEMONOLOGY] = "DEMONIC_FURY",
	[SPEC_WARLOCK_DESTRUCTION] = "BURNING_EMBERS",
}

local function Update(self, event, unit, powerType)
	local element = self.WarlockPower
	if self.unit ~= unit or (powerType and powerType ~= element.powerType) then return end

	if element.PreUpdate then
		element:PreUpdate()
	end

	--print("WarlockPower.Update", powerType)
	if not powerType then
		powerType = element.powerType
		if not powerType then
			return
		end
	end

	local num, max

	-- Affliction
	if powerType == "SOUL_SHARDS" then
		num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
		max = UnitPowerMax(unit, SPELL_POWER_SOUL_SHARDS)
		--print(powerType, num, "/", max)

		if element.SetValue then
			element:SetMinMaxValues(0, max)
			element:SetValue(num)
		else
			for i = 1, #element do
				local shard = element[i]
				if i <= num then
					if shard.SetValue then
						shard:SetMinMaxValues(0, 1)
						shard:SetValue(1)
					else
						shard:SetAlpha(1)
					end
					shard:Show()
				elseif i <= max then
					if shard.SetValue then
						shard:SetMinMaxValues(0, 1)
						shard:SetValue(0)
					else
						shard:SetAlpha(0.25)
					end
					shard:Show()
				else
					shard:Hide()
				end
			end
		end

	-- Demonology
	elseif powerType == "DEMONIC_FURY" then
		num = UnitPower(unit, SPELL_POWER_DEMONIC_FURY)
		max = UnitPowerMax(unit, SPELL_POWER_DEMONIC_FURY)
		--print(powerType, num, "/", max)

		local activated
		for i = 1, 40 do
			local name, _, _, _, _, _, _, _, _, _, spell = UnitBuff(unit, i)
			if not spell then
				break
			end
			if spell == WARLOCK_METAMORPHOSIS then
				activated = true
				break
			end
		end

		if element.SetValue then
			element:SetMinMaxValues(num, max)
			element:SetValue(num)
		else
			local valuePerPart = max / #element
			for i = 1, #element do
				local part = element[i]
				if num > valuePerPart then
					--print(i, "Full")
					if part.SetValue then
						part:SetMinMaxValues(0, valuePerPart)
						part:SetValue(valuePerPart)
					else
						part:SetAlpha(1)
					end
					part:Show()
					num = num - valuePerPart
				elseif num > 0 then
					--print(i, "Partial", num)
					if part.SetValue then
						--print("part.SetValue")
						part:SetMinMaxValues(0, valuePerPart)
						part:SetValue(num)
					else
						--print("part.SetAlpha")
						local percent = num / valuePerPart
						part:SetAlpha(1 - (0.75 * (percent)))
					end
					part:Show()
					num = 0
				else
					--print(i, "Empty")
					if part.SetValue then
						part:SetMinMaxValues(0, valuePerPart)
						part:SetValue(0)
					else
						part:SetAlpha(0.25)
					end
					part:Show()
				end
			end
		end

	-- Destruction
	elseif powerType == "BURNING_EMBERS" then
		num = UnitPower(unit, SPELL_POWER_BURNING_EMBERS, true)
		max = UnitPowerMax(unit, SPELL_POWER_BURNING_EMBERS, true)

		local numWhole = math.floor(num / MAX_POWER_PER_EMBER)
		local maxWhole = math.floor(max / MAX_POWER_PER_EMBER)

		local part = num % MAX_POWER_PER_EMBER

		if element.SetValue then
			--print("element.SetValue")
			element:SetMinMaxValues(0, max)
			element:SetValue(num)
		else
			--print("#elements")
			for i = 1, #element do
				local ember = element[i]
				if i > maxWhole then
					--print(i, "Hide")
					ember:Hide()
				else
					--print(i, "Show")
					if num > MAX_POWER_PER_EMBER then
						--print(i, "Full")
						if ember.SetValue then
							ember:SetMinMaxValues(0, MAX_POWER_PER_EMBER)
							ember:SetValue(MAX_POWER_PER_EMBER)
						else
							ember:SetAlpha(1)
						end
						if ember.bg then
							ember.bg:SetVertexColor(1, 0.6, 0)
						end
						ember:Show()
						num = num - MAX_POWER_PER_EMBER
					elseif num > 0 then
						--print(i, "Partial", num, part)
						if ember.SetValue then
							ember:SetMinMaxValues(0, MAX_POWER_PER_EMBER)
							ember:SetValue(num)
						else
							local percent = num / MAX_POWER_PER_EMBER
							ember:SetAlpha(1 - (0.75 * (percent)))
						end
						ember:Show()
						num = 0
					else
						--print(i, "Empty")
						if ember.SetValue then
							ember:SetMinMaxValues(0, MAX_POWER_PER_EMBER)
							ember:SetValue(0)
						else
							ember:SetAlpha(0.25)
						end
						ember:Show()
					end
				end
			end
		end
	end

	if element.PostUpdate then
		return element:PostUpdate(num, max, powerType)
	end
end

local function Path(self, ...)
	return (self.WarlockPower.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Visibility(self, event, unit)
	local spec = GetSpecialization()
	--print("WarlockPower: Visibility", spec)

	local element = self.WarlockPower
	element.powerType = powerTypes[spec]

	local show
	if UnitIsDeadOrGhost("player") or UnitHasVehicleUI("player") then
		--print("dead or in vehicle")
		-- no show
	elseif spec == SPEC_WARLOCK_AFFLICTION then
		--print("AFFLICTION")
		if IsPlayerSpell(WARLOCK_SOULBURN) then
			show = true
		else
			self.spellID = WARLOCK_SOULBURN
			self:RegisterEvent("SPELLS_CHANGED", Visibility, true)
		end
	elseif spec == SPEC_WARLOCK_DEMONOLOGY then
		--print("DEMONOLOGY")
		show = true
		if element.areOrbs then -- oooorrrrbssss!
			element:SetOrientation("HORIZONTAL")
			element:SetReverseFill(true)
		end
	elseif spec == SPEC_WARLOCK_DESTRUCTION then
		--print("DESTRUCTION")
		if IsPlayerSpell(WARLOCK_BURNING_EMBERS) then
			show = true
			if element.areOrbs then -- oooorrrrbssss!
				element:SetOrientation("VERTICAL")
				element:SetReverseFill(false)
			end
		else
			self.spellID = WARLOCK_BURNING_EMBERS
			self:RegisterEvent("SPELLS_CHANGED", Visibility, true)
		end
	end
	self.spec = spec

	if show then
		--print("show")
		if element.Show then
			element:Show()
		end

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)

		self:UnregisterEvent("SPELLS_CHANGED", Visibility)

		element:ForceUpdate("Visibility", "player")
	else
		--print("hide")
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)

		if element.Hide then
			element:Hide()
		else
			for i = 1, #element do
				element[i]:Hide()
			end
		end
	end
end

local function Enable(self, unit)
	local element = self.WarlockPower
	if element and unit == "player" then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_ALIVE", Visibility, true)
		self:RegisterEvent("PLAYER_DEAD", Visibility, true)
		self:RegisterEvent("PLAYER_UNGHOST", Visibility, true)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Visibility, true)
		self:RegisterEvent("UNIT_ENTERED_VEHICLE", Visibility)
		self:RegisterEvent("UNIT_EXITED_VEHICLE", Visibility)

		Visibility(self, nil, "player")

		return true
	end
end

local function Disable(self)
	local element = self.WarlockPower
	if element then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)

		self:UnregisterEvent("PLAYER_ALIVE", Visibility)
		self:UnregisterEvent("PLAYER_DEAD", Visibility)
		self:UnregisterEvent("PLAYER_UNGHOST", Visibility)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Visibility)
		self:UnregisterEvent("UNIT_ENTERED_VEHICLE", Visibility)
		self:UnregisterEvent("UNIT_EXITED_VEHICLE", Visibility)

		if element.Hide then
			element:Hide()
		else
			for i = 1, #element do
				element[i]:Hide()
			end
		end
	end
end

oUF:AddElement("WarlockPower", Path, Enable, Disable)
