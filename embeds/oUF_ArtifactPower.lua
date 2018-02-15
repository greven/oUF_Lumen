--[[
# Element: ArtifactPower

Handles updating and visibility of a status bar that displays the player's artifact power.

## Widget

ArtifactPower - a `StatusBar` used to display the player's artifact power

## Options

.color         - the RGB values for the widget. Defaults to {.901, .8, .601} (table)
.onAlpha       - alpha value of the widget when it is mouse-enabled and hovered. Defaults to 1 (number)[0-1]
.offAlpha      - alpha value of the widget when it is mouse-enabled and not hovered. Defaults to 1 (number)[0-1]
.tooltipAnchor - anchor point for the tooltip. Defaults to 'ANCHOR_BOTTOMRIGHT' (string)
.unusableColor - the RGB values for the widget when the equipped artifact is unusable. Defaults to {1, 0, 0} (table)

## Attributes

.name               - the name of the currently equipped artifact (string)
.power              - the amount of artifact power earned towards the next artifact trait (number)
.powerForNextTrait  - the amount of artifact power needed for the next artifact trait (number)
.totalPower         - the total amount of unspent artifact power (number)
.numTraitsLearnable - the number of traits that could be purchased with the current amount of unspent artifact power (number)
.traitsLearned      - the number of purchased traits (number)
.tier               - the current artifact tier (number)

## Notes

A default texture will be applied if the widget is a `StatusBar` and doesn't have a texture or color set.
`OnEnter` and `OnLeave` handlers to display a tooltip will be set on the widget if it is mouse-enabled and the scripts
are not set by the layout.
`OnMouseUp` handler to show the artifact UI will be set on the widget if it is mouse-enabled and the script is not set
by the layout.

## Examples

    -- Position and size
    local ArtifactPower = CreateFrame('StatusBar', nil, self)
    ArtifactPower:SetSize(200, 5)
    ArtifactPower:SetPoint('TOP', self, 'BOTTOM')

    -- Enable the tooltip
    ArtifactPower:EnableMouse(true)

    -- Register with oUF
    self.ArtifactPower = ArtifactPower
--]]

local _, ns = ...
local oUF = ns.oUF or oUF

for tag, func in next, {
	['artifactpower:name'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, name = C_ArtifactUI.GetEquippedArtifactInfo()
		return name
	end,
	['artifactpower:power'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local _, power = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		return power
	end,
	['artifactpower:until_next'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local _, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		return powerForNextTrait - power
	end,
	['artifactpower:until_next_per'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local _, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		return math.floor(((power / powerForNextTrait) * 100) + 0.5)
	end,
	['artifactpower:next_trait_cost'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local _, _, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		return powerForNextTrait
	end,
	['artifactpower:total'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower = C_ArtifactUI.GetEquippedArtifactInfo()
		return totalPower
	end,
	['artifactpower:traits_learnable'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		return numTraitsLearnable
	end,
	['artifactpower:traits_learned'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, _, traitsLearned = C_ArtifactUI.GetEquippedArtifactInfo()
		return traitsLearned
	end,
	['artifactpower:tier'] = function()
		if (not HasArtifactEquipped() or UnitHasVehicleUI('player')) then return end
		local _, _, _, _, _, _, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		return tier
	end
} do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'ARTIFACT_XP_UPDATE UNIT_INVENTORY_CHANGED'
end

--[[ Override: ArtifactPower:OnEnter()
Called when the mouse cursor enters the widget's interactive area.

* self - the ArtifactPower widget (StatusBar)
--]]
local function OnEnter(element)
	element:SetAlpha(element.onAlpha)
	GameTooltip:SetOwner(element, element.tooltipAnchor)
	GameTooltip:SetText(element.name, HIGHLIGHT_FONT_COLOR:GetRGB())
	GameTooltip:AddLine(' ')
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_TITLE:format(AbbreviateLargeNumbers(element.totalPower),
	                                                        AbbreviateLargeNumbers(element.power),
	                                                        AbbreviateLargeNumbers(element.powerForNextTrait)),
	                    nil, nil, nil, true)
	GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(element.numTraitsLearnable), nil, nil, nil, true)
	GameTooltip:Show()
end

--[[ Override: ArtifactPower:OnEnter()
Called when the mouse cursor leaves the widget's interactive area.

* self - the ArtifactPower widget (StatusBar)
--]]
local function OnLeave(element)
	element:SetAlpha(element.offAlpha)
	GameTooltip:Hide()
end

--[[ Override: ArtifactPower:OnMouseUp()
Called to show the artifact UI if the widget is mouse-enabled and has been clicked

* self - the ArtifactPower widget (StatusBar)
--]]
local function OnMouseUp()
	SocketInventoryItem(INVSLOT_MAINHAND)
end

--[[ Override: ArtifactPower:UpdateColor(isUsable)
Used to update the widget's color based whether the equipped artifact is usable.

* self     - the ArtifactPower widget (StatusBar)
* isUsable - indicates whether the equipped artifact is usable (boolean)
--]]
local function UpdateColor(element, isUsable)
	local color = isUsable and element.color or element.unusableColor
	element:SetStatusBarColor(unpack(color))
end

local function Update(self, event, unit)
	if (unit and unit ~= self.unit) then return end

	local element = self.ArtifactPower
	--[[ Callback: ArtifactPower:PreUpdate(event)
	Called before the element has been updated.

	* self  - the ArtifactPower widget (StatusBar)
	* event - the event that triggered the update (string)
	--]]
	if (element.PreUpdate) then element:PreUpdate(event) end

	local isUsable = false
	local show = HasArtifactEquipped() and not UnitHasVehicleUI('player')
	if (show) then
		local _, _, name, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable, power, powerForNextTrait
			= MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier);

		element:SetMinMaxValues(0, powerForNextTrait)
		element:SetValue(power)

		element.name = name
		element.power = power
		element.powerForNextTrait = powerForNextTrait
		element.totalPower = totalPower
		element.numTraitsLearnable = numTraitsLearnable
		element.traitsLearned = traitsLearned
		element.tier = tier

		isUsable = not GetInventoryItemEquippedUnusable('player', INVSLOT_MAINHAND)
		element:UpdateColor(isUsable)

		element:Show()
	else
		element:Hide()
	end

	--[[ Callback: ArtifactPower:PostUpdate(event, show)
	Called after the element has been updated.

	* self     - the ArtifactPower widget (StatusBar)
	* event    - the event that triggered the update (string)
	* isShown  - indicates whether the element is shown (boolean)
	* isUsable - indicates whether the equipped artifact is usable (boolean)
	--]]
	if (element.PostUpdate) then
		return element:PostUpdate(event, show, isUsable)
	end
end

local function Path(self, ...)
	--[[ Override: ArtifactPower:Override(event, ...)
	Used to completely override the element's update process.

	* self  - the ArtifactPower widget
	* event - the event that triggered the update
	* ...   - the arguments accompanying the event
	--]]
	return (self.ArtifactPower.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.ArtifactPower
	if (not element or unit ~= 'player') then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate

	if (element:IsObjectType('StatusBar')) then
		if (not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end
	end

	element.color = element.color or {.901, .8, .601}
	element.unusableColor = element.unusableColor or {1, 0, 0}
	element.UpdateColor = element.UpdateColor or UpdateColor

	if (element:IsMouseEnabled()) then
		element.tooltipAnchor = element.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'
		element.onAlpha = element.onAlpha or 1
		element.offAlpha = element.offAlpha or 1
		element:SetAlpha(element.offAlpha)
		if (not element:GetScript('OnEnter')) then
			element:SetScript('OnEnter', element.OnEnter or OnEnter)
		end
		if (not element:GetScript('OnLeave')) then
			element:SetScript('OnLeave', element.OnLeave or OnLeave)
		end
		if (not element:GetScript('OnMouseUp')) then
			element:SetScript('OnMouseUp', element.OnMouseUp or OnMouseUp)
		end
	end

	self:RegisterEvent('ARTIFACT_XP_UPDATE', Path, true)
	self:RegisterEvent('UNIT_INVENTORY_CHANGED', Path)

	return true
end

local function Disable(self)
	local element = self.ArtifactPower
	if (not element) then return end

	self:UnregisterEvent('ARTIFACT_XP_UPDATE', Path)
	self:UnregisterEvent('UNIT_INVENTORY_CHANGED', Path)
	element:Hide()
end

oUF:AddElement('ArtifactPower', Path, Enable, Disable)
