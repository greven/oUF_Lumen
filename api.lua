local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

-- Class colors
function api:RaidColor(unit)
  local _, x = UnitClass(unit)
  local color = RAID_CLASS_COLORS[x]
  return color and {color.r, color.g, color.b} or {.5, .5, .5}
end

-- Get Unit Experience
function api:GetXP(unit)
  if (unit == "pet") then
    return GetPetExperience()
  else
    return UnitXP(unit), UnitXPMax(unit)
  end
end

function api:GetUnitAura(unit, spell, filter)
  for index = 1, 40 do
    local name, _, count, _, duration, expire, caster, _, _, spellID, _, _, _, _, _, value = UnitAura(unit, index, filter)
    if not name then
      break
    end
    if name and spellID == spell then
      return name, count, duration, expire, caster, spellID, value
    end
  end
end

-- Unit has a Debuff
function api:HasUnitDebuff(unit, name, spell)
  local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
  if spell then
    if count and caster == "player" then
      return count
    end
  else
    if count then
      return count
    end
  end
end

-- Get current specialization name
function api:GetCurrentSpecName()
  local specID = GetSpecialization()
  if specID then
    local _, name = GetSpecializationInfo(specID)
    return name
  end
end

-- Is the player a healer? (healing spec)
function api:IsPlayerHealer()
  local currentSpec = api:GetCurrentSpecName()
  local isHealer = core:HasValue(cfg.healingSpecs, currentSpec)
  return isHealer
end

-- Is Player max level?
function api:IsPlayerMaxLevel()
  return G.playerLevel == GetMaxPlayerLevel() and true or false
end

function api:CreateFontstring(frame, font, size, outline, layer, sublayer, inheritsFrom)
  local fs = frame:CreateFontString(nil, layer or "OVERLAY", sublayer or 0, inheritsFrom or nil)
  fs:SetFont(font, size, outline)
  fs:SetShadowColor(0, 0, 0, 1)
  fs:SetShadowOffset(1, -1)
  return fs
end

function api:CreateBorder(self, borderFrame, edgeSize, frameLevel, texture)
  if borderFrame:GetObjectType() == "Texture" then
    borderFrame = self:GetParent()
  end

  local backdrop = {edgeFile = texture or "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = edgeSize}
  borderFrame:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
  borderFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
  borderFrame:SetBackdrop(backdrop)
  borderFrame:SetFrameLevel(frameLevel or borderFrame:GetFrameLevel() - 1)
  borderFrame:SetBackdropBorderColor(0, 0, 0)
  borderFrame:Hide()
end

function api:SetBackdrop(self, insetLeft, insetRight, insetTop, insetBottom, color)
  local frame = self

  if self:GetObjectType() == "Texture" then
    frame = self:GetParent()
  end

  local lvl = frame:GetFrameLevel()

  if not frame.Backdrop then
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetAllPoints(frame)
    backdrop:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

    backdrop:SetBackdrop {
      bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
      tile = false,
      tileSize = 0,
      insets = {
        left = -insetLeft,
        right = -insetRight,
        top = -insetTop,
        bottom = -insetBottom
      }
    }
    backdrop:SetBackdropColor(unpack(color or cfg.colors.backdrop))
    frame.Backdrop = backdrop
  end
end

function api:CreateDropShadow(frame, point, edge, color)
  if not cfg.frames.shadow.show then
    return
  end

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
  shadow:SetBackdropBorderColor(unpack(color or cfg.frames.shadow.color))
end

function api:DisablePixelSnap(frame)
  if (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
    if frame.SetSnapToPixelGrid then
      frame:SetSnapToPixelGrid(false)
      frame:SetTexelSnappingBias(0)
    elseif frame.GetStatusBarTexture then
      local texture = frame:GetStatusBarTexture()
      if texture and texture.SetSnapToPixelGrid then
        texture:SetSnapToPixelGrid(false)
        texture:SetTexelSnappingBias(0)
      end
    end

    frame.PixelSnapDisabled = true
  end
end

function api:SetInside(frame, anchor, xOffset, yOffset, anchor2)
  xOffset = xOffset or G.mult
  yOffset = yOffset or G.mult
  anchor = anchor or frame:GetParent()

  api:DisablePixelSnap(frame)
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
  frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

function api:SetOutside(frame, anchor, xOffset, yOffset, anchor2)
  xOffset = xOffset or G.mult
  yOffset = yOffset or G.mult
  anchor = anchor or frame:GetParent()

  api:DisablePixelSnap(frame)
  frame:ClearAllPoints()
  frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
  frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

-- ---------------
-- > Frame Fader
-- ---------------

local function FaderOnFinished(self)
  self.__owner:SetAlpha(self.finAlpha)
end

local function FaderOnUpdate(self)
  self.__owner:SetAlpha(self.__animFrame:GetAlpha())
end

function api:IsMouseOverFrame(frame)
  if MouseIsOver(frame) then
    return true
  end
  return false
end

function api:StartFadeIn(frame)
  if frame.fader.direction == "in" then
    return
  end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeInDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeInSmooth or "OUT")
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeInDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeInAlpha
  frame.fader.direction = "in"
  frame.fader:Play()
end

function api:StartFadeOut(frame)
  if frame.fader.direction == "out" then
    return
  end
  frame.fader:Pause()
  frame.fader.anim:SetFromAlpha(frame.faderConfig.fadeInAlpha or 1)
  frame.fader.anim:SetToAlpha(frame.faderConfig.fadeOutAlpha or 0)
  frame.fader.anim:SetDuration(frame.faderConfig.fadeOutDuration or 0.3)
  frame.fader.anim:SetSmoothing(frame.faderConfig.fadeOutSmooth or "OUT")
  frame.fader.anim:SetStartDelay(frame.faderConfig.fadeOutDelay or 0)
  frame.fader.finAlpha = frame.faderConfig.fadeOutAlpha
  frame.fader.direction = "out"
  frame.fader:Play()
end

function api:CreateFaderAnimation(frame)
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
  api:StartFadeIn(frame)
end

local function fadeOut(frame)
  api:StartFadeOut(frame)
end

function api:CreateFrameFader(frame, faderConfig)
  if frame.faderConfig then
    return
  end
  frame.faderConfig = faderConfig
  api:CreateFaderAnimation(frame)
  frame:HookScript("OnShow", fadeIn)
  frame:HookScript("OnHide", fadeOut)
end
