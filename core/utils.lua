local _, ns = ...

local core, cfg, m, oUF = ns.core, ns.cfg, ns.m, ns.oUF

-- ------------------------------------------------------------------------
-- > UTILITY FUNCTIONS
-- ------------------------------------------------------------------------

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
