local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF

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

-- ---------------
-- > Button Glow
-- ---------------
