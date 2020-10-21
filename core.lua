local _, ns = ...

local core, cfg, m, oUF = CreateFrame("Frame"), ns.cfg, ns.m, ns.oUF
ns.core = core

local floor, mod = floor, mod

local roleIconTextures = {
  TANK = m.textures.tank_texture,
  HEALER = m.textures.healer_texture,
  DAMAGER = m.textures.damager_texture
}

local roleIconColor = {
  TANK = {0 / 255, 175 / 255, 255 / 255},
  HEALER = {0 / 255, 255 / 255, 100 / 255},
  DAMAGER = {225 / 255, 0 / 255, 25 / 255}
}

-- -----------------------------------
-- > PLAYER SPECIFIC
-- -----------------------------------

core.playerName = UnitName("player")
core.playerLevel = UnitLevel("player")
core.playerClass = select(2, UnitClass("player"))
core.playerColor = RAID_CLASS_COLORS[core.playerClass]

-- ------------------------------------------------------------------------
-- > MATH
-- ------------------------------------------------------------------------

-- Shortens Numbers
function core:shortNumber(v)
  if v > 1E10 then
    return (floor(v / 1E9)) .. "|cff999999b|r"
  elseif v > 1E9 then
    return (floor((v / 1E9) * 10) / 10) .. "|cff999999b|r"
  elseif v > 1E7 then
    return (floor(v / 1E6)) .. "|cff999999m|r"
  elseif v > 1E6 then
    return (floor((v / 1E6) * 10) / 10) .. "|cff999999m|r"
  elseif v > 1E4 then
    return (floor(v / 1E3)) .. "|cff999999k|r"
  elseif v > 1E3 then
    return (floor((v / 1E3) * 10) / 10) .. "|cff999999k|r"
  else
    return v
  end
end

function core:NumberToPerc(v1, v2)
  return floor(v1 / v2 * 100 + 0.5)
end

function core:formatTime(s)
  local day, hour, minute = 86400, 3600, 60

  if s >= day then
    return format("%dd", floor(s / day + 0.5))
  elseif s >= hour then
    return format("%dh", floor(s / hour + 0.5))
  elseif s >= minute then
    return format("%dm", floor(s / minute + 0.5))
  end
  return format("%d", mod(s, minute))
end

-- ------------------------------------------------------------------------
-- > UTILITY FUNCTIONS
-- ------------------------------------------------------------------------

-- Check if table has the argument value
function core:has_value(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

-- Convert color to HEX
function core:toHex(r, g, b)
  if r then
    if (type(r) == "table") then
      if (r.r) then
        r, g, b = r.r, r.g, r.b
      else
        r, g, b = unpack(r)
      end
    end
    return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
  end
end

-- Create Border
function core:createBorder(self, frame, e_size, f_level, texture)
  local border = {edgeFile = texture, edgeSize = e_size}
  frame:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
  frame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
  frame:SetBackdrop(border)
  frame:SetFrameLevel(f_level)
  frame:Hide()
end

-- Set the Backdrop
function core:setBackdrop(frame, inset_l, inset_r, inset_t, inset_b)
  if not frame.Backdrop then
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetAllPoints()
    backdrop:SetFrameLevel(frame:GetFrameLevel())

    backdrop:SetBackdrop {
      bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
      tile = false,
      tileSize = 0,
      insets = {
        left = -inset_l,
        right = -inset_r,
        top = -inset_t,
        bottom = -inset_b
      }
    }

    backdrop:SetBackdropColor(
      cfg.colors.backdrop.r,
      cfg.colors.backdrop.g,
      cfg.colors.backdrop.b,
      cfg.colors.backdrop.a
    )

    frame.Backdrop = backdrop
  end
end

-- Fontstring Function
function core:createFontstring(frame, font, size, outline, layer, sublayer, inheritsFrom)
  local fs = frame:CreateFontString(nil, layer or "OVERLAY", sublayer or 0, inheritsFrom or nil)
  fs:SetFont(font, size, outline)
  fs:SetShadowColor(0, 0, 0, 1)
  fs:SetShadowOffset(1, -1)
  return fs
end

-- Create a Frame Shadow
function core:createDropShadow(frame, point, edge, color)
  local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  shadow:SetFrameLevel(0)
  shadow:SetPoint("TOPLEFT", frame, "TOPLEFT", -point, point)
  shadow:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", point, -point)
  shadow:SetBackdrop(
    {
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = m.textures.glow_texture,
      tile = false,
      tileSize = 32,
      edgeSize = edge,
      insets = {
        left = -edge,
        right = -edge,
        top = -edge,
        bottom = -edge
      }
    }
  )
  shadow:SetBackdropColor(0, 0, 0, 0)
  shadow:SetBackdropBorderColor(unpack(color))
end

-- Frame Fader
local function FaderOnFinished(self)
  self.__owner:SetAlpha(self.finAlpha)
end

local function FaderOnUpdate(self)
  self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

function core:IsMouseOverFrame(frame)
  if MouseIsOver(frame) then
    return true
  end
  return false
end

function core:StartFadeIn(frame)
  if frame.fader.direction == "in" then
    return
  end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
  --start right away
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
  frame.fader.direction = "in"
  frame.fader:Play()
end

function core:StartFadeOut(frame)
  if frame.fader.direction == "out" then
    return
  end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
  -- wait for some time before starting the fadeout
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader.direction = "out"
  frame.fader:Play()
end

function core:CreateFaderAnimation(frame)
  if frame.fader then
    return
  end
  local animFrame = CreateFrame("Frame", nil, frame)
  animFrame.__owner = frame
  frame.fader = animFrame:CreateAnimationGroup()
  frame.fader.__owner = frame
  frame.fader.__animFrame = animFrame
  frame.fader.direction = nil
  frame.fader.setToFinalAlpha = false
  frame.fader.anim = frame.fader:CreateAnimation("Alpha")
  frame.fader:HookScript("OnFinished", FaderOnFinished)
  frame.fader:HookScript("OnUpdate", FaderOnUpdate)
end

local function fadeIn(frame)
  core:StartFadeIn(frame)
end

local function fadeOut(frame)
  core:StartFadeOut(frame)
end

function core:CreateFrameFader(frame, faderConfig)
  if frame.faderConfig then
    return
  end
  frame.faderConfig = faderConfig
  core:CreateFaderAnimation(frame)
  frame:HookScript("OnShow", fadeIn)
  frame:HookScript("OnHide", fadeOut)
end

-- -----------------------------------
-- > API
-- -----------------------------------

-- Party / Raid Frames Threat Highlight
local function UpdateThreat(self, event, unit)
  if (self.unit ~= unit) then
    return
  end

  local status = UnitThreatSituation(unit)
  unit = unit or self.unit

  if status and status > 1 then
    local r, g, b = GetThreatStatusColor(status)
    self.ThreatBorder:Show()
    self.ThreatBorder:SetBackdropBorderColor(r, g, b, 1)
  else
    self.ThreatBorder:SetBackdropBorderColor(r, g, b, 0)
    self.ThreatBorder:Hide()
  end
end

-- Is Player max level?
function core:isPlayerMaxLevel()
  return core.playerLevel == GetMaxPlayerLevel() and true or false
end

-- Get Unit Experience
function core:getXP(unit)
  if (unit == "pet") then
    return GetPetExperience()
  else
    return UnitXP(unit), UnitXPMax(unit)
  end
end

-- Unit has a Debuff
function core:hasUnitDebuff(unit, name, myspell)
  local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
  if myspell then
    if (count and caster == "player") then
      return count
    end
  else
    if count then
      return count
    end
  end
end

-- Is the player a healer? (healing spec)
function core:isPlayerHealer()
  local currentSpec = core:GetCurrentSpec()
  local isHealer = core:has_value(cfg.healingSpecs, currentSpec)
  return isHealer
end

-- Get current specialization name
function core:GetCurrentSpec()
  local specID = GetSpecialization()

  if (specID) then
    local _, currentSpecName = GetSpecializationInfo(specID)
    return currentSpecName
  end

  return nil
end

-- Class colors
function core:raidColor(unit)
  local _, x = UnitClass(unit)
  local color = RAID_CLASS_COLORS[x]
  return color and {color.r, color.g, color.b} or {.5, .5, .5}
end

-- Raid Frames Target Highlight Border
local function ChangedTarget(self, event, unit)
  if UnitIsUnit("target", self.unit) then
    self.TargetBorder:SetBackdropBorderColor(.8, .8, .8, 1)
    self.TargetBorder:Show()
  else
    self.TargetBorder:Hide()
  end
end

-- -----------------------------------
-- > EXTRA FUNCTIONS
-- -----------------------------------

-- Generates the Name String
function core:createNameString(self, font, size, outline, x, y, point, width)
  self.Name = core:createFontstring(self.Health, font, size, outline)
  self.Name:SetPoint(point, self.Health, x, y)
  self.Name:SetJustifyH(point)
  self.Name:SetWidth(width)
  self.Name:SetHeight(size)
end

-- Generates the Party Name String
function core:createPartyNameString(self, font, size)
  self.Name = core:createFontstring(self.Health, font, size, "THINOUTLINE")
  self.Name:SetPoint("TOPRIGHT", self, "TOPRIGHT", -4, -5)
  self.Name:SetJustifyH("RIGHT")
end

function core:createHPString(self, font, size, outline, x, y, point)
  self.Health.value = core:createFontstring(self.Health, font, size, outline)
  self.Health.value:SetPoint(point, self.Health, x, y)
  self.Health.value:SetJustifyH(point)
  self.Health.value:SetTextColor(1, 1, 1)
end

function core:createHPPercentString(self, font, size, outline, x, y, point, layer)
  self.Health.percent = core:createFontstring(self.Health, font, size, outline, layer)
  self.Health.percent:SetPoint(point, self.Health.value, x, y)
  self.Health.percent:SetJustifyH("RIGHT")
  self.Health.percent:SetTextColor(0.5, 0.5, 0.5, 0.5)
  self.Health.percent:SetShadowColor(0, 0, 0, 0)
  self:Tag(self.Health.percent, "[lum:hpperc]")
end

-- Generates the Power Percent String
function core:createPowerString(self, font, size, outline, x, y, point)
  self.Power.value = core:createFontstring(self.Power, font, size, outline)
  self.Power.value:SetPoint(point, self.Power, x, y)
  self.Power.value:SetJustifyH(point)
  self:Tag(self.Power.value, "[lum:powervalue]")
end

-- Create Glow Border
function core:setglowBorder(self)
  local glow = CreateFrame("Frame", nil, self, "BackdropTemplate")
  glow:SetFrameLevel(0)
  glow:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
  glow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
  glow:SetBackdrop(
    {
      bgFile = m.textures.white_square,
      edgeFile = m.textures.glow_texture,
      tile = false,
      tileSize = 16,
      edgeSize = 4,
      insets = {left = -4, right = -4, top = -4, bottom = -4}
    }
  )
  glow:SetBackdropColor(0, 0, 0, 0)
  glow:SetBackdropBorderColor(0, 0, 0, 1)

  self.Glowborder = glow
end

-- Create Target Border
function core:CreateTargetBorder(self)
  self.TargetBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  core:createBorder(self, self.TargetBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")
  self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)
  self:RegisterEvent("RAID_ROSTER_UPDATE", ChangedTarget)
end

-- Create Party / Raid health warning status border
function core:CreateHPBorder(self)
  self.HPborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  core:createBorder(self, self.HPborder, 1, 4, "Interface\\ChatFrame\\ChatFrameBackground")
  self.HPborder:SetBackdropBorderColor(180 / 255, 255 / 255, 0 / 255, 1)
end

-- Create Party / Raid Threat Status Border
function core:CreateThreatBorder(self)
  self.ThreatBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
  core:createBorder(self, self.ThreatBorder, 1, 3, "Interface\\ChatFrame\\ChatFrameBackground")
  self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
  self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

function core:CreateGroupRoleIndicator(self)
  local roleIcon = self.Health:CreateTexture(nil, "OVERLAY")
  roleIcon:SetPoint("LEFT", self, 8, 0)
  roleIcon:SetSize(16, 16)
  roleIcon.Override = core.UpdateRoleIcon

  self:RegisterEvent("UNIT_CONNECTION", core.UpdateRoleIcon)
  return roleIcon
end

function core:UpdateRoleIcon(event)
  local lfdrole = self.GroupRoleIndicator

  local role = UnitGroupRolesAssigned(self.unit)
  -- Show roles when testing
  if role == "NONE" and cfg.units.party.forceRole then
    local rnd = random(1, 3)
    role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
  end

  if UnitIsConnected(self.unit) and role ~= "NONE" then
    lfdrole:SetTexture(roleIconTextures[role])
    lfdrole:SetVertexColor(unpack(roleIconColor[role]))
  else
    lfdrole:Hide()
  end
end
