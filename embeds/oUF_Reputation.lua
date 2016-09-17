local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Reputation was unable to locate oUF install')

local function GetReputation()
	local name, _, standingID, min, max, value, _, _, _, _, _, _, _, factionID = GetFactionInfo(GetSelectedFaction())
	local _, friendMin, friendMax, _, _, _, friendStanding, friendThreshold = GetFriendshipReputation(factionID)

	if(not friendMin) then
		return value - min, max - min, name, factionID, standingID, GetText('FACTION_STANDING_LABEL' .. standingID, UnitSex('player'))
	else
		return friendMin - friendThreshold, math.min(friendMax - friendThreshold, 8400), name, factionID, standingID, friendStanding
	end
end

for tag, func in next, {
	['reputation:cur'] = function()
		return (GetReputation())
	end,
	['reputation:max'] = function(unit, runit)
		local _, max = GetReputation()
		return max
	end,
	['reputation:per'] = function()
		local cur, max = GetReputation()
		return math.floor(cur / max * 100 + 1/2)
	end,
	['reputation:standing'] = function()
		local _, _, _, _, _, standingText = GetReputation()
		return standingText
	end,
	['reputation:faction'] = function()
		local _, _, name = GetReputation()
		return name
	end,
} do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'UPDATE_FACTION'
end

oUF.Tags.SharedEvents.UPDATE_FACTION = true

local function Update(self, event, unit)
	local element = self.Reputation
	if(element.PreUpdate) then element:PreUpdate(unit) end

	local cur, max, name, factionID, standingID, standingText = GetReputation()
	if(name) then
		element:SetMinMaxValues(0, max)
		element:SetValue(cur)

		if(element.colorStanding) then
			local color = FACTION_BAR_COLORS[standingID]
			element:SetStatusBarColor(color.r, color.g, color.b)
		end
	end

	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max, name, factionID, standingID, standingText)
	end
end

local function Path(self, ...)
	return (self.Reputation.Override or Update) (self, ...)
end

local function ElementEnable(self)
	self:RegisterEvent('UPDATE_FACTION', Path, true)

	self.Reputation:Show()

	Path(self, 'ElementEnable', 'player')
end

local function ElementDisable(self)
	self:UnregisterEvent('UPDATE_FACTION', Path)

	self.Reputation:Hide()

	Path(self, 'ElementDisable', 'player')
end

local function Visibility(self, event, unit, selectedFactionIndex)
	local shouldEnable
	local selectedFaction = GetSelectedFaction()

	if(selectedFactionIndex ~= nil) then
		if(selectedFactionIndex == selectedFaction) then
			shouldEnable = true
		end
	elseif(selectedFaction and select(12, GetFactionInfo(selectedFaction))) then
		shouldEnable = true
	end

	if(shouldEnable) then
		ElementEnable(self)
	else
		ElementDisable(self)
	end
end

local function VisibilityPath(self, ...)
	return (self.Reputation.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.Reputation
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		hooksecurefunc('SetWatchedFactionIndex', function(selectedFactionIndex)
			VisibilityPath(self, 'SetWatchedFactionIndex', 'player', selectedFactionIndex)
		end)

		if(not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		return true
	end
end

local function Disable(self)
	if(self.Reputation) then
		ElementDisable(self)
	end
end

oUF:AddElement('Reputation', VisibilityPath, Enable, Disable)
