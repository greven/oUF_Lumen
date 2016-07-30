local _, ns = ...

local core, cfg, oUF = ns.core, ns.cfg, ns.oUF

local font = core.media.font
local font_big = core.media.font_big

-- ------------------------------------------------------------------------
-- > PLAYER UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  if cfg.units.player.health.gradientColored then
    local r, g, b = oUF.ColorGradient(min, max, 1,0,0, 1,1,0, unpack(core:raidColor(unit)))
    health:SetStatusBarColor(r, g, b)
  end

  -- Class colored text
  if cfg.units.player.health.classColoredText then
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
      DRUID = {255/255, 64/255, 26/255},
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

-- frame bootstrap
local setupUnitFrame = function(self)
  self:SetFrameStrata("BACKGROUND")

  self:SetSize(self.cfg.width, self.cfg.height)
  self:SetPoint(self.cfg.pos.a1, self.cfg.pos.af, self.cfg.pos.a2, self.cfg.pos.x, self.cfg.pos.y)

  self.Health:SetHeight(self.cfg.height - cfg.frames.main.health.margin - self.cfg.power.height)
  self.Health:SetWidth(self.cfg.width)
  self.Health.frequentUpdates = self.cfg.health.frequentUpdates

  self.Power:SetHeight(cfg.frames.main.power.height)
  self.Power:SetWidth(self.cfg.width)
  self.Power.frequentUpdates = self.cfg.power.frequentUpdates

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth
  self.Power.PostUpdate = PostUpdatePower
end

-- -----------------------------------
-- > PLAYER STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = "player"
  self.cfg = cfg.units.player

  core:globalStyle(self)
  setupUnitFrame(self)

  -- Texts
  core:createNameString(self, font_big, cfg.fontsize, "THINOUTLINE", 4, 0, "LEFT", self.cfg.width - 55)
  core:createHPString(self, font, cfg.fontsize, "THINOUTLINE", -4, 0, "RIGHT")
  core:createHPPercentString(self, font, cfg.fontsize, nil, -32, 0, "LEFT", "BACKGROUND")
  core:createPowerString(self, font, cfg.fontsize -4, "THINOUTLINE", 0, 0, "CENTER")

  -- Castbar
  core:createCastbar(self)

  -- Class Icons
  local ClassIcons = {}
  ClassIcons.UpdateTexture = UpdateClassIconTexture
  ClassIcons.PostUpdate = PostUpdateClassIcon

  for index = 1, 8 do
    local ClassIcon = CreateFrame('Frame', nil, self)
    ClassIcon:SetHeight(cfg.frames.main.power.height)
    core:setBackdrop(ClassIcon, 2, 2, 2, 2)

    if(index > 1) then
      ClassIcon:SetPoint('LEFT', ClassIcons[index - 1], 'RIGHT', 6, 0)
    else
      ClassIcon:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -8)
    end

    local Texture = ClassIcon:CreateTexture(nil, core.media.status_texture, nil, index > 5 and 1 or 0)
    Texture:SetAllPoints()
    ClassIcon.Texture = Texture

    ClassIcons[index] = ClassIcon
  end
  self.ClassIcons = ClassIcons

end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units.player.show then
  oUF:RegisterStyle("lumen:player", createStyle)
  oUF:SetActiveStyle("lumen:player")
  oUF:Spawn("player", "oUF_LumenPlayer")
end
