local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font
local font_big = m.fonts.font_big

local frame = "player"

-- ------------------------------------------------------------------------
-- > PLAYER UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  if cfg.units[frame].health.gradientColored then
    local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, unpack(core:raidColor(unit)))
    health:SetStatusBarColor(r, g, b)
  end

  -- Class colored text
  if cfg.units[frame].health.classColoredText then
    self.Name:SetTextColor(unpack(core:raidColor(unit)))
  end
end

-- Post Power Update
local PostUpdatePower = function(power, unit, min, max)

end

-- Post Update ClassIcon
local function PostUpdateClassIcon(element, cur, max, diff, powerType, event)
	if(diff or event == 'ClassPowerEnable') then
		element:UpdateTexture()

    local lastIconColor = {
      DRUID = {255/255, 26/255, 48/255},
      MAGE = {238/255, 48/255, 83/255},
      MONK = {0/255, 143/255, 247/255},
      PALADIN = {255/255, 26/255, 48/255},
      ROGUE = {255/255, 26/255, 48/255},
      WARLOCK = {255/255, 26/255, 48/255},
    }

		for index = 1, max do
			local ClassIcon = element[index]
      local maxWidth, gap = cfg.frames.main.width, 6

      if(max == 5 or max == 8) then
        ClassIcon:SetWidth(((maxWidth / 5) - ((4 * gap) / 5)))
      else
        ClassIcon:SetWidth(((maxWidth / max) - (((max-1) * gap) / max)))
      end

			if(max == 8) then -- Rogue anticipation
				if(index == 6) then
					ClassIcon:ClearAllPoints()
					ClassIcon:SetPoint('LEFT', element[index - 5])
				end

				if(index > 5) then
					ClassIcon.Texture:SetColorTexture(25/255, 255/255, 255/255)
        elseif(index == 5) then
          ClassIcon.Texture:SetColorTexture(255/255, 26/255, 48/255)
				end
			else
				if(index > 1) then
					ClassIcon:ClearAllPoints()
					ClassIcon:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
				end
        if(index == max) then
          ClassIcon.Texture:SetColorTexture(unpack(lastIconColor[core.playerClass]))
        end
			end
		end
	end
end

-- Post Update ClassIcon Texture
local function UpdateClassIconTexture(element)
	local r, g, b = 255/255, 255/255, 102/255
	if(not UnitHasVehicleUI('player')) then
		if(core.playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(core.playerClass == 'WARLOCK') then
			r, g, b = 161/255, 92/255, 255/255
		elseif(core.playerClass == 'PALADIN') then
			r, g, b = 255/255, 255/255, 125/255
		elseif(core.playerClass == 'MAGE') then
			r, g, b = 169/255, 80/255, 202/255
		end
	end

	for index = 1, 8 do
		local ClassIcon = element[index]
		ClassIcon.Texture:SetColorTexture(r, g, b)
	end
end

-- Create Class Icons (Combo Points...)
local function CreateClassIcons(self)
  local ClassIcons = {}
  ClassIcons.UpdateTexture = UpdateClassIconTexture
  ClassIcons.PostUpdate = PostUpdateClassIcon

  for index = 1, 8 do
    local ClassIcon = CreateFrame('Frame', "oUF_LumenClassIcons", self)
    ClassIcon:SetHeight(cfg.frames.main.power.height)
    core:setBackdrop(ClassIcon, 2, 2, 2, 2)

    if(index > 1) then
      ClassIcon:SetPoint('LEFT', ClassIcons[index - 1], 'RIGHT', 6, 0)
    else
      ClassIcon:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    end

    local Texture = ClassIcon:CreateTexture(nil, m.textures.status_texture, nil, index > 5 and 1 or 0)
    Texture:SetAllPoints()
    ClassIcon.Texture = Texture

    ClassIcons[index] = ClassIcon
  end
  self.ClassIcons = ClassIcons
end

-- Druid Mana post update callback
local druidManaPostUpdate = function(self, unit, cur, max)
  -- Hide DruidMana if full
  if(cur == max) then
    self:Hide()
  else
    self:Show()
  end
end

-- Create alternate power (oUF Druid Mana)
local function createAlternatePower(self)
  local height = core.playerClass == "DRUID" and -16 or -10 -- Druid has combo points also

  local DruidMana = CreateFrame("StatusBar", nil, self)
  DruidMana:SetStatusBarTexture(m.textures.status_texture)
  DruidMana:GetStatusBarTexture():SetHorizTile(false)
  DruidMana:SetSize(self.cfg.width, self.cfg.altpower.height)
  DruidMana:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, height)
  DruidMana.colorPower = true

  -- Add a background
  local Background = DruidMana:CreateTexture(nil, 'BACKGROUND')
  Background:SetAllPoints(DruidMana)
  Background:SetAlpha(0.20)
  Background:SetTexture(m.textures.bg_texture)

  -- Value
  local PowerValue = core:createFontstring(DruidMana, font, cfg.fontsize -4, "THINOUTLINE")
  PowerValue:SetPoint("RIGHT", DruidMana, -8, 0)
  PowerValue:SetJustifyH("RIGHT")
  self:Tag(PowerValue, '[lumen:altpower]')

  -- Backdrop
  core:setBackdrop(DruidMana, 2, 2, 2, 2)

  -- Post Update
  DruidMana.PostUpdate = druidManaPostUpdate

  -- Register it with oUF
  self.DruidMana = DruidMana
  self.DruidMana.bg = Background
end

-- Post Update Aura Icon
local PostUpdateIcon =  function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

	if duration and duration > 0 then
		icon.timeLeft = expirationTime - GetTime()

	else
		icon.timeLeft = math.huge
	end

	icon:SetScript('OnUpdate', function(self, elapsed)
		auras:AuraTimer_OnUpdate(self, elapsed)
	end)
end

-- -----------------------------------
-- > PLAYER STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:globalStyle(self)
  lum:setupUnitFrame(self, "main")

  -- Text strings
  core:createNameString(self, font_big, cfg.fontsize + 2, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 75)
  self:Tag(self.Name, '[lumen:level]  [lumen:name] [lumen:classification]')
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  self:Tag(self.Health.value, '[lumen:hpvalue]')
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth
  self.Power.PostUpdate = PostUpdatePower

  -- Castbar
  core:CreateCastbar(self)

  -- Class Icons
  CreateClassIcons(self)

  -- Alternate Power Bar
  createAlternatePower(self)

  -- Combat indicator
  local cbt = core:createFontstring(self, m.fonts.symbols, 40, "THINOUTLINE")
  cbt:SetPoint("RIGHT", self, "LEFT", -4, 1)
  cbt:SetText("Q")
  cbt:SetTextColor(255/255, 26/255, 48/255)
  self.Combat = cbt

  -- Bar Timers (buffs)
  local barTimers = CreateBarTimers(self, 8, 100, 25, 4)
  barTimers:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 100)
  barTimers["growth-y"] = "UP"
  barTimers.PostUpdateBar = PostUpdateBar
  self.BarTimers = barTimers
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units.target.show then
  oUF:RegisterStyle("lumen:"..frame, createStyle)
  oUF:SetActiveStyle("lumen:"..frame)
  oUF:Spawn(frame, "oUF_Lumen"..frame)
end
