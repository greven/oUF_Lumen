local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font

local _G = _G

-- -----------------------------------------
-- > MIRROR BARS (Underwater Breath, etc.)
-- -----------------------------------------

local function MirrorTimer_OnUpdate(frame, elapsed)
  if frame.paused then
    return
  end
  if frame.timeSinceUpdate >= 0.3 then
    local minutes = frame.value / 60
    local seconds = frame.value % 60

    if frame.value > 0 then
      frame.TimerText:SetFormattedText("%d:%02d", minutes, seconds)
    else
      frame.TimerText:SetText("0:00")
    end

    frame.timeSinceUpdate = 0
  else
    frame.timeSinceUpdate = frame.timeSinceUpdate + elapsed
  end
end

function lum:MirrorBars()
  for i = 1, _G.MIRRORTIMER_NUMTIMERS do
    local mirrorTimer = _G["MirrorTimer" .. i]
    local statusBar = _G["MirrorTimer" .. i .. "StatusBar"]
    local bg = select(1, mirrorTimer:GetRegions())
    local border = _G["MirrorTimer" .. i .. "Border"]
    local text = _G["MirrorTimer" .. i .. "Text"]

    mirrorTimer:SetParent(UIParent)
    mirrorTimer:SetHeight(cfg.elements.mirrorTimers.height)
    mirrorTimer:SetWidth(cfg.elements.mirrorTimers.width)

    border:Hide()

    statusBar:SetStatusBarTexture(m.textures.status_texture)
    statusBar:SetAllPoints(mirrorTimer)
    core:setBackdrop(statusBar, 2, 2, 2, 2)

    bg = mirrorTimer:CreateTexture(nil, "BORDER")
    bg:SetAllPoints()
    bg:SetAlpha(0.1)
    bg:SetTexture(m.textures.bg_texture)
    bg:SetColorTexture(0.2, 0.2, 0.2)

    text:SetFont(font, cfg.fontsize - 1, "THINOUTLINE")
    text:ClearAllPoints()
    text:SetPoint("LEFT", statusBar, 4, 0)
    mirrorTimer.label = text

    local Timer = mirrorTimer:CreateFontString(nil, "OVERLAY")
    Timer:SetFont(m.fonts.font, cfg.fontsize, "THINOUTLINE")
    Timer:SetPoint("RIGHT", statusBar, "RIGHT", -4, 0)
    mirrorTimer.TimerText = Timer

    mirrorTimer.timeSinceUpdate = 0.3 -- Make sure timer value updates right away on first show
    mirrorTimer:HookScript("OnUpdate", MirrorTimer_OnUpdate)
  end
end

-- ------------------------------------------------------------------------
-- > Blizzard UI Related
-- ------------------------------------------------------------------------

-- Hide Blizzard Compact Raid Frames
if cfg.hideBlizzardRaidFrames then
  CompactRaidFrameManager:UnregisterAllEvents()
  CompactRaidFrameManager:Hide()
  CompactRaidFrameContainer:UnregisterAllEvents()
  CompactRaidFrameContainer:Hide()
  CompactRaidFrameContainer:Hide()
end
