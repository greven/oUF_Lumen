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

local function UpdateSpellState(button, spellID, texture)
  local element = button:GetParent()

  local isSpellKnown = IsPlayerSpell(spellID)
  local isUsable, notEnoughMana = IsUsableSpell(spellID)
  local start, duration = GetSpellCooldown(spellID)
  local count = GetSpellCount(spellID)
  local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID)

  local expirationTime

  -- Charges
  if charges and maxCharges > 1 then
    button.count:SetText(charges)
  else
    button.count:SetText("")
  end

  -- Some spells have counters and not charges (Wrath, Eclipse...)
  if not charges and count then
    if count > 0 then
      button.count:SetText(count)
    else
      button.count:SetText("")
    end
  end

  if charges and charges > 0 and charges < maxCharges then
    button.icon:SetDesaturated(false)
    button.count:SetTextColor(1, 1, 1)
  elseif count and count > 0 then
    button.count:SetTextColor(1, 1, 1)
  elseif start and duration > 1.5 then
    button.icon:SetDesaturated(true)
    button.count:SetTextColor(1, 1, 1)
  else
    button.icon:SetDesaturated(false)
    if charges == maxCharges then
      button.count:SetTextColor(1, 0, 0)
    end
  end

  -- Cooldown
  if button.cd then
    if charges and charges > 0 and charges < maxCharges then
      expirationTime = chargeStart + chargeDuration
      if not element.disableCooldown then
        button.cd:SetCooldown(chargeStart, chargeDuration)
        button.cd:Show()
      end
    elseif start and duration > 1.5 then
      expirationTime = start + duration
      if not element.disableCooldown then
        button.cd:SetCooldown(start, duration)
        button.cd:Show()
      end
    else
      button.cd:Hide()
    end
  end

  if texture then
    button.icon:SetTexture(GetSpellTexture(spellID))
  end

  -- If spell is not learned, fade it
  if not isSpellKnown then
    button.icon:SetVertexColor(0.2, 0.2, 0.2)
    return
  end

  -- Check if spell is usable (OOM, etc.)
  if isUsable then
    button.icon:SetVertexColor(1.0, 1.0, 1.0)
  else
    button.icon:SetVertexColor(0.2, 0.2, 0.2)
    if notEnoughMana then
      button.icon:SetVertexColor(0.2, 0.3, 1.0)
    end
  end

  if (element.PostUpdateSpell) then
    element:PostUpdateSpell(button, expirationTime)
  end
end

local function SetPosition(element, index)
  local button = element[index]

  if not button then
    return
  end

  local max = element.num
  local gap = element.gap or 4

  if index > 1 then
    button:SetPoint("LEFT", element[index - 1], "RIGHT", gap, 0)
  else
    button:SetPoint("TOPLEFT", element, 0, 0)
  end
end

local function CreateSpellButton(element, index)
  local button = CreateFrame("Button", element:GetDebugName() .. "Button" .. index, element)
  button:RegisterForClicks("AnyUp")

  local cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
  cd:SetFrameLevel(cd:GetParent():GetFrameLevel())
  cd:SetAllPoints()

  local icon = button:CreateTexture(nil, "BORDER")
  icon:SetAllPoints()

  local countFrame = CreateFrame("Frame", nil, button)
  countFrame:SetAllPoints(button)
  countFrame:SetFrameLevel(cd:GetFrameLevel() + 1)

  local count = countFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
  count:SetPoint("BOTTOMRIGHT", countFrame, "BOTTOMRIGHT", 0, 0)

  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
  overlay:SetAllPoints()
  overlay:SetTexCoord(.296875, .5703125, 0, .515625)
  button.overlay = overlay

  local glow = CreateFrame("Frame", nil, button)
  glow:SetPoint("CENTER")

  -- button.UpdateTooltip = UpdateTooltip
  -- button:SetScript("OnEnter", onEnter)
  -- button:SetScript("OnLeave", onLeave)

  button.icon = icon
  button.count = count
  button.cd = cd
  button.glow = glow

  --[[ Callback: SpellWatchers:PostCreateButton(button)
	Called after a new spell button has been created.

	* self   - the widget holding the spell buttons
	* button - the newly created spell button
	--]]
  if (element.PostCreateButton) then
    element:PostCreateButton(button)
  end

  return button
end

local function UpdateSpellButton(element, index)
  local spellID = element.__spells[index]

  if spellID then
    local button = element[index]

    if not button then
      button = (element.CreateButton or CreateSpellButton)(element, index)
      table.insert(element, button)
    end

    if button.overlay then
      button.overlay:SetTexCoord(0, 1, 0, 1)
      button.overlay:SetVertexColor(0.1, 0.1, 0.1)
      button.overlay:Show()
    else
      button.overlay:Hide()
    end

    UpdateSpellState(button, spellID, true)

    local num, width = element.num, element:GetWidth()

    local maxSize = ((width / num) - (((num - 1) * (element.gap or 4)) / num))
    local size = element.size or maxSize
    button:SetSize(size, size)

    -- TODO: Set the glow!
    -- if button.glow then
    --   button.glow:SetSize(button:GetSize() + 8)
    -- end

    button:EnableMouse(not element.disableMouse)
    button:SetID(index)
    button:Show()

    if (element.PostUpdateButton) then
      element:PostUpdateButton(button)
    end
  end
end

local function UpdateSpells(self, event, unit)
  local watchers = self.SpellWatchers
  if watchers and watchers.num > 0 then
    --[[ Callback: SpellWatchers:PreUpdate(unit)
		Called before the element has been updated.

		* self - the widget holding the spell buttons
		* unit - the unit for which the update has been triggered (string)
		--]]
    if (watchers.PreUpdate) then
      watchers:PreUpdate(unit)
    end

    local spells = watchers.__spells

    for index = 1, watchers.num do
      local button = watchers[index]
      if (not button) then
        button = (watchers.CreateButton or CreateSpellButton)(watchers, index)
        table.insert(watchers, button)
      end

      if (button.cd) then
        button.cd:Hide()
      end
      if (button.icon) then
        button.icon:SetTexture()
      end
      if (button.count) then
        button.count:SetText()
      end
      if (button.glow) then
        button.glow:Hide()
      end

      button:EnableMouse(false)
      button:Show()

      SetPosition(watchers, index)
      UpdateSpellButton(watchers, index)
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
    return element:PostUpdate(event, unit)
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

-- local function ForceUpdate(element)
--   return Update(element.__owner, "ForceUpdate")
-- end

do
  function SpellWatchersEnable(self)
    local element = self.SpellWatchers

    self:RegisterEvent("UNIT_AURA", Path)
    self:RegisterEvent("UNIT_POWER_UPDATE", Path)
    self:RegisterEvent("SPELL_UPDATE_COOLDOWN", Path, true)

    PlayerSpec = GetCurrentSpec()

    self.SpellWatchers.__isEnabled = true
  end

  function SpellWatchersDisable(self)
    self:UnregisterEvent("UNIT_AURA", Path)
    self:UnregisterEvent("UNIT_POWER_UPDATE", Path)
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
    element.num = self.num or 5
    element.ForceUpdate = ForceUpdate

    self:RegisterEvent("PLAYER_TALENT_UPDATE", VisibilityPath, true)
    self:RegisterEvent("SPELLS_CHANGED", VisibilityPath, true)

    return true
  end
end

local function Disable(self)
  if (self.SpellWatchers) then
    self:UnregisterEvent("UNIT_AURA", VisibilityPath)
    self:UnregisterEvent("UNIT_POWER_UPDATE", VisibilityPath)
    self:UnregisterEvent("SPELL_UPDATE_COOLDOWN", VisibilityPath)
    self:UnregisterEvent("PLAYER_TALENT_UPDATE", VisibilityPath)
    self:UnregisterEvent("SPELLS_CHANGED", VisibilityPath)
  end
end

oUF:AddElement("SpellWatchers", VisibilityPath, Enable, Disable)
