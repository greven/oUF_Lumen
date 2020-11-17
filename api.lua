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

-- ------------------------------------------------------------
-- > Button Glow
-- Credits: Hendrik "nevcairiel" Leppkes <h.leppkes@gmail.com>
-- ------------------------------------------------------------

local unusedOverlayGlows, numOverlays = {}, 0
local tinsert, tremove, tostring = table.insert, table.remove, tostring
local iconAlertTexture = [[Interface\SpellActivationOverlay\IconAlert]]
local iconAlertAntsTexture = [[Interface\SpellActivationOverlay\IconAlertAnts]]

local function overlayGlowAnimOutFinished(animGroup)
  local overlay = animGroup:GetParent()
  local button = overlay:GetParent()
  overlay:Hide()
  tinsert(unusedOverlayGlows, overlay)
  button.__overlay = nil
end

local function overlayGlow_OnHide(self)
  if self.animOut:IsPlaying() then
    self.animOut:Stop()
    overlayGlowAnimOutFinished(self.animOut)
  end
end

local function createScaleAnim(group, target, order, duration, x, y, delay)
  local scale = group:CreateAnimation("Scale")
  scale:SetTarget(target:GetName())
  scale:SetOrder(order)
  scale:SetDuration(duration)
  scale:SetScale(x, y)

  if delay then
    scale:SetStartDelay(delay)
  end
end

local function createAlphaAnim(group, target, order, duration, fromAlpha, toAlpha, delay)
  local alpha = group:CreateAnimation("Alpha")
  alpha:SetTarget(target:GetName())
  alpha:SetOrder(order)
  alpha:SetDuration(duration)
  alpha:SetFromAlpha(fromAlpha)
  alpha:SetToAlpha(toAlpha)

  if delay then
    alpha:SetStartDelay(delay)
  end
end

local function animIn_OnPlay(group)
  local frame = group:GetParent()
  local frameWidth, frameHeight = frame:GetSize()
  frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2)
  frame.innerGlow:SetAlpha(1)
  frame.innerGlowOver:SetAlpha(1)
  frame.outerGlow:SetSize(frameWidth * 1.1, frameHeight * 1.1)
  frame.outerGlow:SetAlpha(1)
  frame.outerGlowOver:SetAlpha(1)
  frame.ants:SetSize(frameWidth * .85, frameHeight * .85)
  frame.ants:SetAlpha(0)
  frame:Show()
end

local function animIn_OnFinished(group)
  local frame = group:GetParent()
  local frameWidth, frameHeight = frame:GetSize()
  frame.innerGlow:SetAlpha(0)
  frame.innerGlow:SetSize(frameWidth, frameHeight)
  frame.innerGlowOver:SetAlpha(0)
  frame.outerGlow:SetSize(frameWidth, frameHeight)
  frame.outerGlowOver:SetAlpha(0)
  frame.outerGlowOver:SetSize(frameWidth, frameHeight)
  frame.ants:SetAlpha(1)
end

local function overlayGlow_OnUpdate(self, elapsed)
  AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
  local cooldown = self:GetParent().cooldown
  -- we need some threshold to avoid dimming the glow during the gdc
  -- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
  if (cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
    self:SetAlpha(.5)
  else
    self:SetAlpha(1)
  end
end

local function createOverlayGlow()
  numOverlays = numOverlays + 1

  -- create frame and textures
  local name = "ButtonGlowOverlay" .. tostring(numOverlays)
  local overlay = CreateFrame("Frame", name, UIParent)

  -- inner glow
  overlay.innerGlow = overlay:CreateTexture(name .. "InnerGlow", "ARTWORK")
  overlay.innerGlow:SetPoint("CENTER")
  overlay.innerGlow:SetAlpha(0)
  overlay.innerGlow:SetTexture(iconAlertTexture)
  overlay.innerGlow:SetTexCoord(.00781250, .50781250, .27734375, .52734375)

  -- inner glow over
  overlay.innerGlowOver = overlay:CreateTexture(name .. "InnerGlowOver", "ARTWORK")
  overlay.innerGlowOver:SetPoint("TOPLEFT", overlay.innerGlow, "TOPLEFT")
  overlay.innerGlowOver:SetPoint("BOTTOMRIGHT", overlay.innerGlow, "BOTTOMRIGHT")
  overlay.innerGlowOver:SetAlpha(0)
  overlay.innerGlowOver:SetTexture(iconAlertTexture)
  overlay.innerGlowOver:SetTexCoord(.00781250, .50781250, .53515625, .78515625)

  -- outer glow
  overlay.outerGlow = overlay:CreateTexture(name .. "OuterGlow", "ARTWORK")
  overlay.outerGlow:SetPoint("CENTER")
  overlay.outerGlow:SetAlpha(0)
  overlay.outerGlow:SetTexture(iconAlertTexture)
  overlay.outerGlow:SetTexCoord(.00781250, .50781250, .27734375, .52734375)

  -- outer glow over
  overlay.outerGlowOver = overlay:CreateTexture(name .. "OuterGlowOver", "ARTWORK")
  overlay.outerGlowOver:SetPoint("TOPLEFT", overlay.outerGlow, "TOPLEFT")
  overlay.outerGlowOver:SetPoint("BOTTOMRIGHT", overlay.outerGlow, "BOTTOMRIGHT")
  overlay.outerGlowOver:SetAlpha(0)
  overlay.outerGlowOver:SetTexture(iconAlertTexture)
  overlay.outerGlowOver:SetTexCoord(.00781250, .50781250, .53515625, .78515625)

  -- ants
  overlay.ants = overlay:CreateTexture(name .. "Ants", "OVERLAY")
  overlay.ants:SetPoint("CENTER")
  overlay.ants:SetAlpha(0)
  overlay.ants:SetTexture(iconAlertAntsTexture)

  -- setup antimations
  overlay.animIn = overlay:CreateAnimationGroup()
  createScaleAnim(overlay.animIn, overlay.innerGlow, 1, .3, 2, 2)
  createScaleAnim(overlay.animIn, overlay.innerGlowOver, 1, .3, 2, 2)
  createAlphaAnim(overlay.animIn, overlay.innerGlowOver, 1, .3, 1, 0)
  createScaleAnim(overlay.animIn, overlay.outerGlowOver, 1, .3, .5, .5)
  createAlphaAnim(overlay.animIn, overlay.outerGlowOver, 1, .3, 1, 0)
  createAlphaAnim(overlay.animIn, overlay.innerGlow, 1, .2, 1, 0, .3)
  createAlphaAnim(overlay.animIn, overlay.ants, 1, .2, 0, 1, .3)
  overlay.animIn:SetScript("OnPlay", animIn_OnPlay)
  overlay.animIn:SetScript("OnFinished", animIn_OnFinished)

  overlay.animOut = overlay:CreateAnimationGroup()
  createAlphaAnim(overlay.animOut, overlay.outerGlowOver, 1, .2, 0, 1)
  createAlphaAnim(overlay.animOut, overlay.ants, 1, .2, 1, 0)
  createAlphaAnim(overlay.animOut, overlay.outerGlowOver, 2, .2, 1, 0)
  createAlphaAnim(overlay.animOut, overlay.outerGlow, 2, .2, 1, 0)
  overlay.animOut:SetScript("OnFinished", overlayGlowAnimOutFinished)

  -- scripts
  overlay:SetScript("OnUpdate", overlayGlow_OnUpdate)
  overlay:SetScript("OnHide", overlayGlow_OnHide)

  return overlay
end

local function getOverlayGlow()
  local overlay = tremove(unusedOverlayGlows)
  if not overlay then
    overlay = createOverlayGlow()
  end
  return overlay
end

function api:ShowOverlayGlow()
  if self.__overlay then
    if self.__overlay.animOut:IsPlaying() then
      self.__overlay.animOut:Stop()
      self.__overlay.animIn:Play()
    end
  else
    local overlay = getOverlayGlow()
    local frameWidth, frameHeight = self:GetSize()
    overlay:SetParent(self)
    overlay:SetFrameLevel(self:GetFrameLevel() + 5)
    overlay:ClearAllPoints()
    -- Make the height/width available before the next frame:
    overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
    overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * .2, frameHeight * .2)
    overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * .2, -frameHeight * .2)
    overlay.animIn:Play()
    self.__overlay = overlay
  end
end

function api:HideOverlayGlow()
  if self.__overlay then
    if self.__overlay.animIn:IsPlaying() then
      self.__overlay.animIn:Stop()
    end
    if self:IsVisible() then
      self.__overlay.animOut:Play()
    else
      overlayGlowAnimOutFinished(self.__overlay.animOut)
    end
  end
end
