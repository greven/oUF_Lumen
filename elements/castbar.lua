local _, ns = ...

local lum, core, cfg, m, oUF = ns.lum, ns.core, ns.cfg, ns.m, ns.oUF

local font = m.fonts.font

local _G = _G

-- ------------------------------------------------------------------------
-- > CASTBARS
-- ------------------------------------------------------------------------

local function resetAttributes(self)
  self.castID = nil
  self.casting = nil
  self.channeling = nil
  self.notInterruptible = nil
  self.spellID = nil
end

local CheckForSpellInterrupt = function(self, unit)
  local initialColor = cfg.units[unit].castbar.color

  if unit == "vehicle" then
    unit = "player"
  end

  if (self.notInterruptible and UnitCanAttack("player", unit)) then
    self.Glowborder:SetBackdropBorderColor(25 / 255, 200 / 255, 255 / 255, 1)
    self.Glowborder:Show()
    self:SetStatusBarColor(0.2, 0.2, 0.2)
  else
    self.Glowborder:Hide()
    self:SetStatusBarColor(unpack(initialColor))
  end
end

-- Castbar Custom Cast TimeText
local CustomCastTimeText = function(self, duration)
  self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
  if self.Max then
    self.Max:SetText(("%.1f "):format(self.max))
    self.Max:Show()
  end
end

local onPostCastStart = function(self, unit)
  -- Set the castbar unit's initial color
  self:SetStatusBarColor(unpack(cfg.units[unit].castbar.color))
  CheckForSpellInterrupt(self, unit)
  core:StartFadeIn(self)
end

local OnPostCastFail = function(self, unit)
  -- Color castbar red when cast fails
  self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255)
  core:StartFadeOut(self)

  if self.Max then
    self.Max:Hide()
  end
end

local OnPostCastInterruptible = function(self, unit)
  CheckForSpellInterrupt(self, unit)
end

-- Castbar generator
function core:CreateCastbar(self)
  local Castbar = CreateFrame("StatusBar", nil, self)
  Castbar:SetStatusBarTexture(m.textures.status_texture)
  Castbar:GetStatusBarTexture():SetHorizTile(false)
  Castbar:SetFrameStrata("HIGH")
  Castbar:SetToplevel(true)

  local Background = Castbar:CreateTexture(nil, "BACKGROUND")
  Background:SetAllPoints(Castbar)
  Background:SetTexture(m.textures.bg_texture)
  Background:SetColorTexture(.1, .1, .1)
  Background:SetAlpha(0.4)

  local Text = Castbar:CreateFontString(nil, "OVERLAY")
  Text:SetTextColor(1, 1, 1)
  Text:SetShadowOffset(1, -1)
  Text:SetJustifyH("LEFT")
  Text:SetHeight(12)

  local Time = Castbar:CreateFontString(nil, "OVERLAY")
  Time:SetTextColor(1, 1, 1)
  Time:SetJustifyH("RIGHT")

  local Icon = Castbar:CreateTexture(nil, "ARTWORK")
  Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  local Shield = Castbar:CreateTexture(nil, "OVERLAY")
  Shield:SetSize(20, 20)
  Shield:SetPoint("CENTER", Castbar)

  -- Spell casting time
  Castbar.Max = Castbar:CreateFontString(nil, "OVERLAY")
  Castbar.Max:SetTextColor(150 / 255, 150 / 255, 150 / 255)
  Castbar.Max:SetJustifyH("RIGHT")
  Castbar.Max:SetFont(font, cfg.fontsize - 2, "THINOUTLINE")
  Castbar.Max:SetPoint("RIGHT", Time, "LEFT", 0, 0)

  if (self.mystyle == "player") then
    core:setBackdrop(Castbar, cfg.units.player.castbar.height + 4, 2, 2, 2)
    Castbar:SetStatusBarColor(unpack(cfg.units.player.castbar.color))
    Castbar:SetWidth(cfg.units.player.castbar.width - cfg.units.player.castbar.height + 6)
    Castbar:SetHeight(cfg.units.player.castbar.height)
    Castbar:SetPoint(
      cfg.units.player.castbar.pos.a1,
      cfg.units.player.castbar.pos.af,
      cfg.units.player.castbar.pos.a2,
      cfg.units.player.castbar.pos.x,
      cfg.units.player.castbar.pos.y
    )

    Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    Text:SetWidth(cfg.units.player.castbar.width - 60)
    Text:SetPoint("LEFT", Castbar, 4, 0)

    Time:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    Time:SetPoint("RIGHT", Castbar, -6, 0)

    Icon:SetHeight(cfg.units.player.castbar.height)
    Icon:SetWidth(cfg.units.player.castbar.height)
    Icon:SetPoint("LEFT", Castbar, -(cfg.units.player.castbar.height + 2), 0)

    -- Add safezone
    if (cfg.units.player.castbar.latency.show) then
      local SafeZone = Castbar:CreateTexture(nil, "OVERLAY")
      SafeZone:SetTexture(m.textures.status_texture)
      SafeZone:SetVertexColor(unpack(cfg.units.player.castbar.latency.color))
    end
  elseif (self.mystyle == "target") then
    core:setBackdrop(Castbar, cfg.units.target.castbar.height + 4, 2, 2, 2)
    Castbar:SetStatusBarColor(unpack(cfg.units.target.castbar.color))
    Castbar:SetWidth(cfg.units.target.castbar.width - cfg.units.target.castbar.height + 6)
    Castbar:SetHeight(cfg.units.target.castbar.height)
    Castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 350)

    Text:SetFont(font, cfg.fontsize + 2, "THINOUTLINE")
    Text:SetWidth(cfg.units.target.castbar.width - 60)
    Text:SetPoint("LEFT", Castbar, 6, 0)

    Time:SetFont(font, cfg.fontsize + 2, "THINOUTLINE")
    Time:SetPoint("RIGHT", Castbar, -6, 0)

    Icon:SetHeight(cfg.units.target.castbar.height)
    Icon:SetWidth(cfg.units.target.castbar.height)
    Icon:SetPoint("LEFT", Castbar, -(cfg.units.target.castbar.height + 2), 0)
  elseif (self.mystyle == "focus") then
    core:setBackdrop(Castbar, cfg.units.focus.castbar.height + 4, 2, 2, 2)
    Castbar:SetStatusBarColor(unpack(cfg.units.focus.castbar.color))
    Castbar:SetWidth(cfg.units.focus.castbar.width - cfg.units.focus.castbar.height + 6)
    Castbar:SetHeight(cfg.units.focus.castbar.height)
    Castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 300)

    Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    Text:SetWidth(cfg.units.focus.castbar.width - 60)
    Text:SetPoint("LEFT", Castbar, 4, 0)

    Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
    Time:SetPoint("RIGHT", Castbar, -6, 0)

    Icon:SetHeight(cfg.units.focus.castbar.height)
    Icon:SetWidth(cfg.units.focus.castbar.height)
    Icon:SetPoint("LEFT", Castbar, -(cfg.units.focus.castbar.height + 2), 0)
  elseif (self.mystyle == "boss") then
    core:setBackdrop(Castbar, 2, 2, 2, 2)
    Castbar:SetStatusBarColor(unpack(cfg.units.boss.castbar.color))
    Castbar:SetWidth(cfg.units.boss.castbar.width - cfg.units.boss.castbar.height + 6)
    Castbar:SetHeight(cfg.units.boss.castbar.height)
    Castbar:SetPoint("LEFT", self, cfg.units.boss.height + 2, 0)
    Castbar:SetPoint("TOPRIGHT", self, 0, 0)

    Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    Text:SetWidth(cfg.units.boss.width - 50)
    Text:SetPoint("LEFT", Castbar, 4, 0)

    Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
    Time:SetPoint("RIGHT", Castbar, -6, 0)

    Icon:SetHeight(cfg.units.boss.height)
    Icon:SetWidth(cfg.units.boss.height)
    Icon:SetPoint("LEFT", Castbar, -(cfg.units.boss.castbar.height + 2), 0)
  end

  -- Non Interruptable glow
  core:setglowBorder(Castbar)
  Castbar.Glowborder:SetPoint("TOPLEFT", Castbar, "TOPLEFT", -(Castbar:GetHeight() + 2) - 6, 6)

  Castbar.PostCastStart = onPostCastStart
  Castbar.PostCastFail = OnPostCastFail
  Castbar.PostCastInterruptible = OnPostCastInterruptible

  Castbar.CustomTimeText = CustomCastTimeText
  Castbar.timeToHold = cfg.elements.castbar.timeToHold

  -- FadeIn / FadeOut animation
  core:CreateFaderAnimation(Castbar)
  Castbar.faderConfig = cfg.elements.castbar.fader

  Castbar.Text = Text
  Castbar.Time = Time
  Castbar.Icon = Icon
  -- Castbar.Shield = Shield
  Castbar.SafeZone = SafeZone
  Castbar.bg = Background
  self.Castbar = Castbar -- register with oUF
end

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

function core:MirrorBars()
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
