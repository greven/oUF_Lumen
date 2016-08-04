local _, ns = ...
local oUF = ns.oUF

-- ------------------------------------------------------------------------
-- > BAR TIMERS
-- ------------------------------------------------------------------------

local VISIBLE = 1
local HIDDEN = 0

local UpdateTooltip = function(self)
	GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local CreateBar = function(bars, index)
  local bar = CreateFrame("StatusBar", "$parentBar"..index, bars)

  local icon = bar:CreateTexture(nil, 'ARTWORK')
  icon:SetPoint("TOP")
  icon:SetPoint("LEFT", bar)
  icon:SetTexCoord(.1, .93, .07, .93)
  bar.icon = icon

  local spell = bar:CreateFontString(nil, "OVERLAY")
  spell:SetFontObject(NumberFontNormal)
  spell:SetPoint("LEFT", bar, "LEFT", 4, 0)
  spell:SetJustifyH("LEFT")
  spell:SetJustifyV("CENTER")
  bar.spell = spell

  time = bar:createFontstring(nil, "OVERLAY")
  time:SetFontObject(NumberFontNormal)
  time:SetPoint("RIGHT", bar, "RIGHT", -4, 0)
  time:SetTextColor(1, 1, 1)
  time:SetJustifyH("RIGHT")
  time:SetJustifyV("CENTER")
  bar.time = time

  count = bar:createFontstring(nil, "OVERLAY")
  count:SetFontObject(NumberFontNormal)
  count:SetPoint("LEFT", bar.spell, "RIGHT", 0, 0)
  count:SetJustifyH("LEFT")
  count:SetJustifyV("CENTER")
  bar.count = count

  -- PostCreateBar Callback
  if(bars.PostCreateIcon) then bars:PostCreateBar(bar) end

	return bar
end

local customFilter = function(bars, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)
	if((icons.onlyShowPlayer and icon.isPlayer) or (not icons.onlyShowPlayer and name)) then
		return true
	end
end

local updateBar = function(unit, icons, index, offset, filter, isDebuff, visible)

end

local SetPosition = function(icons, from, to)

end

local filterBarTimers = function(unit, icons, filter, limit, isDebuff, offset, dontHide)

end

local UpdateBarTimers = function(self, event, unit)
  if(self.unit ~= unit) then return end

  local bars = self.BarTimers
  if(bars) then
    
  end

  local buffBars = self.BuffBars
  if(buffBars) then

  end

  local debuffBars = self.DebuffBars
	if(debuffBars) then

  end
end

local Update = function(self, event, unit)
  if(self.unit ~= unit) then return end

  UpdateBarTimers(self, event, unit)
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
  if(self.BarTimers or self.BuffBars or self.DebuffBars) then
		self:RegisterEvent("UNIT_AURA", UpdateBarTimers)

    local buffs = self.BuffBars
		if(buffs) then
			buffs.__owner = self
			buffs.ForceUpdate = ForceUpdate

			buffs.createdbars = 0
			buffs.anchoredbars = 0
		end

    local debuffs = self.DebuffBars
    if(debuffs) then
      debuffs.__owner = self
      debuffs.ForceUpdate = ForceUpdate

      debuffs.createdbars = 0
      debuffs.anchoredbars = 0
    end

    local bars = self.BarTimers
    if(bars) then
      bars.__owner = self
      bars.ForceUpdate = ForceUpdate

      bars.createdbars = 0
      bars.anchoredbars = 0

      return true
    end
  end
end

local Disable = function(self, unit)
  if(self.BarTimers or self.BuffBars or self.DebuffBars) then
		self:UnregisterEvent("UNIT_AURA", UpdateBarTimers)
	end
end

oUF:AddElement('BarTimers', Update, Enable, Disable)
