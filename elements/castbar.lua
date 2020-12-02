local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m,
                                       ns.G, ns.oUF

local font = m.fonts.font
local format = string.format

-- ------------------------------------------------------------------------
-- > CASTBARS
-- ------------------------------------------------------------------------

-- Set the hearthstone bind location when casting hearthstone spells
local function SetHearthstoneBindingLocation(self, unit)
    if unit ~= "player" then return end

    if core:HasValue(G.hearthstones, self.spellID) then
        local bindLocation = GetBindLocation()
        self.Text:SetText(format("%s - |cff888888%s|r", self.Text:GetText(), bindLocation))
    end
end

local function CheckForSpellInterrupt(self, unit)
    if not unit then return end
    if unit == "vehicle" then unit = "player" end

    local hasColorConfig = cfg.units[unit] and cfg.units[unit].castbar and cfg.units[unit].castbar.color
    local initialColor = (hasColorConfig and cfg.units[unit].castbar.color) or {235 / 255, 25 / 255, 25 / 255}

    if (self.notInterruptible and UnitCanAttack("player", unit)) then
        self:SetStatusBarColor(0.2, 0.2, 0.2)

        if self.Glowborder then
            self.Glowborder:SetBackdropBorderColor(25 / 255, 200 / 255, 255 / 255, 1)
            self.Glowborder:Show()
        end
    else
        self:SetStatusBarColor(unpack(initialColor))

        if self.Glowborder then self.Glowborder:Hide() end
    end
end

-- Castbar Custom Cast TimeText
local function CustomCastTimeText(self, duration)
    local unit = self.__owner.mystyle

    if self.Time then
        self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
    end

    if self.Max and unit ~= "nameplate" then
        self.Max:SetText(("%.1f "):format(self.max))
        self.Max:Show()
    end
end

local function onPostCastStart(self, unit)
    if unit == "vehicle" then
        unit = "player"
    else
        unit = self.__owner.mystyle
    end

    -- Set the castbar unit's initial color
    self:SetStatusBarColor(unpack(cfg.units[unit].castbar.color))

    CheckForSpellInterrupt(self, unit)
    SetHearthstoneBindingLocation(self, unit)

    api:StartFadeIn(self)
end

local function OnPostCastFail(self, unit)
    self:SetStatusBarColor(235 / 255, 25 / 255, 25 / 255, 0.8)
    api:StartFadeOut(self)

    if self.Max then self.Max:Hide() end
end

local function OnPostCastInterruptible(self, unit)
    CheckForSpellInterrupt(self, unit)
end

-- Castbar generator
function lum:CreateCastbar(self)
    local unit = self.mystyle

    if not unit or not cfg.units[unit].castbar.enable then return end

    local backdropColor = cfg.elements.castbar.backdrop.color

    local Castbar = CreateFrame("StatusBar", nil, self)
    Castbar:SetStatusBarTexture(m.textures.status_texture)
    Castbar:GetStatusBarTexture():SetHorizTile(false)
    Castbar:SetFrameStrata("HIGH")
    Castbar:SetToplevel(true)

    local Background = Castbar:CreateTexture(nil, "BACKGROUND")
    Background:SetAllPoints(Castbar)
    Background:SetTexture(m.textures.bg_texture)
    Background:SetColorTexture(.1, .1, .1)
    Background:SetAlpha(0.3)

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
    local Max = Castbar:CreateFontString(nil, "BACKGROUND")
    Max:SetTextColor(100 / 255, 100 / 255, 100 / 255)
    Max:SetJustifyH("RIGHT")
    Max:SetFont(font, cfg.fontsize - 2, "THINOUTLINE")
    Max:SetPoint("RIGHT", Time, "LEFT", 0, 0)
    Castbar.Max = Max

    if (unit == "player") then
        api:SetBackdrop(Castbar, cfg.units.player.castbar.height + 4, 2, 2, 2, backdropColor)
        Castbar:SetStatusBarColor(unpack(cfg.units.player.castbar.color))
        Castbar:SetWidth(cfg.units.player.castbar.width - cfg.units.player.castbar.height + 6)
        Castbar:SetHeight(cfg.units.player.castbar.height)
        Castbar:SetPoint(cfg.units.player.castbar.pos.a1,
                         cfg.units.player.castbar.pos.af,
                         cfg.units.player.castbar.pos.a2,
                         cfg.units.player.castbar.pos.x,
                         cfg.units.player.castbar.pos.y)

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
            local Safe = Castbar:CreateTexture(nil, "OVERLAY")
            Safe:SetTexture(m.textures.status_texture)
            Safe:SetVertexColor(unpack(cfg.units.player.castbar.latency.color))
            Safe:SetPoint("TOPRIGHT")
            Safe:SetPoint("BOTTOMRIGHT")
            Castbar:SetFrameLevel(10)
        end
    elseif (unit == "target") then
        api:SetBackdrop(Castbar, cfg.units.target.castbar.height + 4, 2, 2, 2)
        Castbar:SetStatusBarColor(unpack(cfg.units.target.castbar.color))
        Castbar:SetWidth(cfg.units.target.castbar.width -
                             cfg.units.target.castbar.height + 6)
        Castbar:SetHeight(cfg.units.target.castbar.height)
        Castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 320)

        Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
        Text:SetWidth(cfg.units.target.castbar.width - 60)
        Text:SetPoint("LEFT", Castbar, 6, 0)

        Time:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
        Time:SetPoint("RIGHT", Castbar, -6, 0)

        Icon:SetHeight(cfg.units.target.castbar.height)
        Icon:SetWidth(cfg.units.target.castbar.height)
        Icon:SetPoint("LEFT", Castbar, -(cfg.units.target.castbar.height + 2), 0)
    elseif (unit == "focus") then
        api:SetBackdrop(Castbar, cfg.units.focus.castbar.height + 4, 2, 2, 2)
        Castbar:SetStatusBarColor(unpack(cfg.units.focus.castbar.color))
        Castbar:SetWidth(cfg.units.focus.castbar.width -
                             cfg.units.focus.castbar.height + 6)
        Castbar:SetHeight(cfg.units.focus.castbar.height)
        Castbar:SetPoint("CENTER", "UIParent", "CENTER", 0, 280)

        Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
        Text:SetWidth(cfg.units.focus.castbar.width - 60)
        Text:SetPoint("LEFT", Castbar, 4, 0)

        Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
        Time:SetPoint("RIGHT", Castbar, -6, 0)

        Icon:SetHeight(cfg.units.focus.castbar.height)
        Icon:SetWidth(cfg.units.focus.castbar.height)
        Icon:SetPoint("LEFT", Castbar, -(cfg.units.focus.castbar.height + 2), 0)
    elseif (unit == "boss") then
        api:SetBackdrop(Castbar, cfg.units.boss.castbar.height + 8, 2, 2, 2)
        Castbar:SetStatusBarColor(unpack(cfg.units.boss.castbar.color))
        Castbar:SetWidth(cfg.units.boss.castbar.width -
                             cfg.units.boss.castbar.height + 6)
        Castbar:SetHeight(cfg.units.boss.castbar.height)
        Castbar:SetPoint("TOPLEFT", self, 0, 0)
        Castbar:SetPoint("BOTTOMRIGHT", self, 0, 0)

        Text:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
        Text:SetWidth(cfg.units.boss.width - 50)
        Text:SetPoint("LEFT", Castbar, 4, 0)

        Time:SetFont(font, cfg.fontsize, "THINOUTLINE")
        Time:SetPoint("RIGHT", Castbar, -6, 0)

        Icon:SetHeight(cfg.units.boss.height)
        Icon:SetWidth(cfg.units.boss.height)
        Icon:SetPoint("LEFT", Castbar, -(cfg.units.boss.castbar.height + 6), 0)
    elseif (unit == "nameplate") then
        api:SetBackdrop(Castbar, 1, 1, 1, 1)
        Castbar:SetStatusBarColor(unpack(cfg.units.nameplate.castbar.color))
        Castbar:SetWidth(cfg.units.nameplate.width)
        Castbar:SetHeight(cfg.units.nameplate.castbar.height)
        Castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)

        Text:SetFont(font, cfg.fontsize - 5, "THINOUTLINE")
        Text:SetWidth(cfg.units.nameplate.width - 4)
        Text:SetPoint("CENTER", Castbar, -2, -10)

        Time:SetFont(font, cfg.fontsize - 6, "THINOUTLINE")
        Time:SetPoint("RIGHT", Castbar, 2, -10)
        Time:SetTextColor(.7, .7, .7)

        Icon:SetHeight(16)
        Icon:SetWidth(16)
        Icon:SetPoint("TOPLEFT", self, "TOPRIGHT", 6, 0)

        Icon.border = CreateFrame("Frame", nil, Castbar, "BackdropTemplate")
        api:CreateBorder(Icon, Icon.border, 2)
        Icon.border:Show()
    end

    -- Non Interruptable glow
    lum:SetGlowBorder(Castbar)
    Castbar.Glowborder:SetPoint("TOPLEFT", Castbar, "TOPLEFT",
                                -(Castbar:GetHeight() + 2) - 6, 6)

    Castbar.PostCastStart = onPostCastStart
    Castbar.PostCastFail = OnPostCastFail
    Castbar.PostCastInterruptible = OnPostCastInterruptible

    Castbar.CustomTimeText = CustomCastTimeText
    Castbar.timeToHold = cfg.elements.castbar.timeToHold

    -- FadeIn / FadeOut animation
    api:CreateFaderAnimation(Castbar)
    Castbar.faderConfig = cfg.elements.castbar.fader

    Castbar.Text = Text
    Castbar.Time = Time
    Castbar.Icon = Icon
    -- Castbar.Shield = Shield
    Castbar.SafeZone = Safe
    Castbar.bg = Background
    self.Castbar = Castbar -- register with oUF
end
