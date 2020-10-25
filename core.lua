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
function core:CreateFontstring(frame, font, size, outline, layer, sublayer, inheritsFrom)
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
