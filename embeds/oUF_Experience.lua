local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Experience was unable to locate oUF install')

local isBetaClient = select(4, GetBuildInfo()) >= 70000
if(not isBetaClient) then
	IsWatchingHonorAsXP = function() end
end

for tag, func in next, {
	['curxp'] = function(unit)
		return (IsWatchingHonorAsXP() and UnitHonor or UnitXP) (unit)
	end,
	['maxxp'] = function(unit)
		return (IsWatchingHonorAsXP() and UnitHonorMax or UnitXPMax) (unit)
	end,
	['perxp'] = function(unit)
		return math.floor(_TAGS.curxp(unit) / _TAGS.maxxp(unit) * 100 + 0.5)
	end,
	['currested'] = function()
		return (IsWatchingHonorAsXP() and UnitHonor or GetXPExhaustion) ()
	end,
	['perrested'] = function(unit)
		local rested = _TAGS.currested()
		if(rested and rested > 0) then
			return math.floor(rested / _TAGS.maxxp(unit) * 100 + 0.5)
		end
	end,
} do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'
end

local function UpdateColor(element, showHonor)
	if(showHonor) then
		element:SetStatusBarColor(1, 1/4, 0)

		if(element.Rested) then
			element.Rested:SetStatusBarColor(1, 3/4, 0)
		end
	else
		element:SetStatusBarColor(1/6, 2/3, 1/5)

		if(element.Rested) then
			element.Rested:SetStatusBarColor(0, 2/5, 1)
		end
	end
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local element = self.Experience
	if(element.PreUpdate) then element:PreUpdate(unit) end

	local showHonor
	local level = UnitLevel('player')
	if(UnitHasVehicleUI(unit) or IsXPUserDisabled()) then
		return element:Hide()
	elseif(level == element.__accountMaxLevel) then
		if(IsWatchingHonorAsXP() and element.__accountMaxLevel == MAX_PLAYER_LEVEL) then
			element:Show()
			showHonor = true
		else
			return element:Hide()
		end
	else
		element:Show()
	end

	local cur = (showHonor and UnitHonor or UnitXP)(unit)
	local max = (showHonor and UnitHonorMax or UnitXPMax)(unit)

	if(showHonor and UnitHonorLevel(unit) == GetMaxPlayerHonorLevel()) then
		cur, max = 1, 1
	end

	element:SetMinMaxValues(0, max)
	element:SetValue(cur)

	if(element.Rested) then
		local exhaustion = (showHonor and GetHonorExhaustion or GetXPExhaustion)() or 0
		element.Rested:SetMinMaxValues(0, max)
		element.Rested:SetValue(math.min(cur + exhaustion, max))
	end

	(self.OverrideUpdateColor or UpdateColor)(element, showHonor)

	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max, exhaustion, showHonor)
	end
end

local function Path(self, ...)
	return (self.Experience.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.Experience
	if(element and unit == 'player') then
		element.__owner = self

		local levelRestriction = GetRestrictedAccountData()
		if(levelRestriction > 0) then
			element.__accountMaxLevel = levelRestriction
		else
			element.__accountMaxLevel = MAX_PLAYER_LEVEL
		end

		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_XP_UPDATE', Path)
		self:RegisterEvent('PLAYER_LEVEL_UP', Path, true)
		self:RegisterEvent('DISABLE_XP_GAIN', Path, true)
		self:RegisterEvent('ENABLE_XP_GAIN', Path, true)

		if(isBetaClient) then
			self:RegisterEvent('HONOR_XP_UPDATE', Path)
			self:RegisterEvent('HONOR_LEVEL_UPDATE', Path)
			self:RegisterEvent('HONOR_PRESTIGE_UPDATE', Path)

			hooksecurefunc('SetWatchingHonorAsXP', function()
				Path(self, 'HONOR_XP_UPDATE', 'player')
			end)
		end

		local child = element.Rested
		if(child) then
			self:RegisterEvent('UPDATE_EXHAUSTION', Path)
			child:SetFrameLevel(element:GetFrameLevel() - 1)

			if(not child:GetStatusBarTexture()) then
				child:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.Experience
	if(element) then
		self:UnregisterEvent('PLAYER_XP_UPDATE', Path)
		self:UnregisterEvent('PLAYER_LEVEL_UP', Path)

		if(isBetaClient) then
			self:UnregisterEvent('HONOR_XP_UPDATE', Path)
			self:UnregisterEvent('HONOR_LEVEL_UPDATE', Path)
			self:UnregisterEvent('HONOR_PRESTIGE_UPDATE', Path)

			-- Can't undo secure hooks
		end

		if(element.Rested) then
			self:UnregisterEvent('UPDATE_EXHAUSTION', Path)
		end
	end
end

oUF:AddElement('Experience', Path, Enable, Disable)
