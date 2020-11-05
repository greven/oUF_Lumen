-- ------------------------------------------------------------------------
-- > SpellWatchers: Watch class spells
-- ------------------------------------------------------------------------

local _, ns = ...
local oUF = ns.oUF

local _, PlayerClass = UnitClass("player")
local PlayerSpec

local function GetCurrentSpec()
  local specID = GetSpecialization()
  if (specID) then
    local _, currentSpecName = GetSpecializationInfo(specID)
    return currentSpecName
  end

  return nil
end

local function GetTotalElements(elements)
  local count = 0
  for _ in pairs(elements) do
    count = count + 1
  end
  return count
end

local function CreateSpellButton(element, index)
end

local function UpdateSpellButton(element, index)
  local spellID = element.__spells[index]
  local start, duration = GetSpellCooldown(spellID)
  print(spellID, duration)
end

local function UpdateSpells(self, event, unit)
  local element = self.SpellWatchers
  if element and element.__max > 0 then
    --[[ Callback: SpellWatchers:PreUpdate(unit)
		Called before the element has been updated.

		* self - the widget holding the spell buttons
		* unit - the unit for which the update has been triggered (string)
		--]]
    if (element.PreUpdate) then
      element:PreUpdate(unit)
    end

    local spells = element.__spells

    for index = 1, element.__max do
      UpdateSpellButton(element, index)
    end
  end
end

local function Update(self, event, unit)
  local element = self.SpellWatchers

  if not element.__spells then
    return
  end

  UpdateSpells(self, event, unit)

  if (element.PostUpdate) then
    return element:PostUpdate(max, oldMax ~= max)
  end
end

local function Path(self, ...)
  --[[ Override: SpellWatchers.Override(self, event, unit, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	* ...   - the arguments accompanying the event
	--]]
  return (self.SpellWatchers.Override or Update)(self, ...)
end

local function Visibility(self, event, unit)
  local element = self.SpellWatchers
  local shouldEnable

  local PlayerSpec = GetCurrentSpec()
  element.__spells = element.spells[PlayerClass][PlayerSpec]

  if (UnitHasVehicleUI("player")) then
    shouldEnable = false
  elseif not element.__spells then
    shouldEnable = false
  else
    if GetTotalElements(element.__spells) > 0 then
      shouldEnable = true
    else
      shouldEnable = false
    end
  end

  local isEnabled = element.__isEnabled

  if shouldEnable and not isEnabled then
    SpellWatchersEnable(self)

    --[[ Callback: SpellWatchers:PostVisibility(isVisible)
		Called after the element's visibility has been changed.

		* self      - the SpellWatchers element
		* isVisible - the current visibility state of the element (boolean)
		--]]
    if (element.PostVisibility) then
      element:PostVisibility(true)
    end
  elseif (not shouldEnable and (isEnabled or isEnabled == nil)) then
    SpellWatchersDisable(self)

    if (element.PostVisibility) then
      element:PostVisibility(false)
    end
  elseif shouldEnable and isEnabled then
    Path(self, event, unit)
  end
end

local function VisibilityPath(self, ...)
  --[[ Override: SpellWatchers.OverrideVisibility(self, event, unit)
	Used to completely override the internal visibility function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
  return (self.SpellWatchers.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
  return Update(element.__owner, "ForceUpdate")
end

do
  function SpellWatchersEnable(self)
    local element = self.SpellWatchers

    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", Path, true)

    PlayerSpec = GetCurrentSpec()

    local max = GetTotalElements(element.__spells)
    for i = 1, max do
      element[i]:Show()
    end

    element.__max = max

    self.SpellWatchers.__isEnabled = true
  end

  function SpellWatchersDisable(self)
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN", Path)

    local element = self.SpellWatchers
    for i = 1, #element do
      element[i]:Hide()
    end

    element.__isEnabled = false
  end
end

local function Enable(self, unit)
  local element = self.SpellWatchers

  if element and UnitIsUnit(unit, "player") then
    if not element.spells then
      return
    end

    element.__owner = self
    element.__max = #element
    element.ForceUpdate = ForceUpdate

    for i = 1, #element do
      element[i]:Hide()
    end

    self:RegisterEvent("PLAYER_TALENT_UPDATE", VisibilityPath, true)
    self:RegisterEvent("SPELLS_CHANGED", VisibilityPath, true)

    return true
  end
end

local function Disable(self)
  if (self.SpellWatchers) then
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN", VisibilityPath)
    self:UnregisterEvent("PLAYER_TALENT_UPDATE", VisibilityPath)
    self:UnregisterEvent("SPELLS_CHANGED", VisibilityPath)
  end
end

oUF:AddElement("SpellWatchers", VisibilityPath, Enable, Disable)
