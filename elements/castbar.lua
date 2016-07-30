local _, ns = ...

local core, cfg, oUF = ns.core, ns.cfg, ns.oUF

local font = core.media.font
local font_big = core.media.font_big

-- ------------------------------------------------------------------------
-- > CASTBARS
-- ------------------------------------------------------------------------

-- Castbar Custom Cast TimeText
local CustomCastTimeText = function(self, duration)
  self.Time:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
  if(self.__owner.mystyle == "player") then
    self.Max:SetText(("%.1f "):format(self.max))
  end
end

-- Castbar generator
function core:createCastbar(fr)
  fr.Castbar = CreateFrame("StatusBar", "oUF_LumenCastBar"..fr.mystyle, fr)
  fr.Castbar:SetStatusBarTexture(core.media.status_texture)
  fr.Castbar:GetStatusBarTexture():SetHorizTile(false)
  fr.Castbar:SetToplevel(true)

  fr.Castbar.Text = fr.Castbar:CreateFontString(nil, "OVERLAY")
  fr.Castbar.Text:SetTextColor(1, 1, 1)
  fr.Castbar.Text:SetShadowOffset(1, -1)
  fr.Castbar.Text:SetJustifyH("LEFT")
  fr.Castbar.Text:SetHeight(12)

  fr.Castbar.Time = fr.Castbar:CreateFontString(nil, "OVERLAY")
  fr.Castbar.Time:SetTextColor(1, 1, 1)
  fr.Castbar.Time:SetJustifyH("RIGHT")

  fr.Castbar.Icon = fr.Castbar:CreateTexture(nil, 'ARTWORK')
  fr.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  if(fr.mystyle == "player") then
    core:setBackdrop(fr.Castbar, cfg.units.player.castbar.height + 4, 2, 2, 2)
    fr.Castbar:SetBackdropColor(unpack(cfg.elements.castbar.backdrop.color))
    fr.Castbar:SetStatusBarColor(unpack(cfg.units.player.castbar.color))
    fr.Castbar:SetWidth(cfg.units.player.castbar.width * 2 - cfg.units.player.castbar.height + 6)
    fr.Castbar:SetHeight(cfg.units.player.castbar.height)
    fr.Castbar:SetPoint("TOPLEFT", "oUF_LumenPlayer", "BOTTOMLEFT", cfg.units.player.castbar.height + 2, -cfg.units.player.castbar.height + 2)

    fr.Castbar.Text:SetFont(font_big, cfg.fontsize + 1, "THINOUTLINE")
    fr.Castbar.Text:SetWidth(cfg.units.player.castbar.width - 50)
    fr.Castbar.Text:SetPoint("LEFT", fr.Castbar, 4, 0)

    fr.Castbar.Time:SetFont(font, cfg.fontsize + 1, "THINOUTLINE")
    fr.Castbar.Time:SetPoint("RIGHT", fr.Castbar, -6, 0)

    fr.Castbar.Max = fr.Castbar:CreateFontString(nil, "OVERLAY")
    fr.Castbar.Max:SetTextColor(200/255, 200/255, 200/255)
    fr.Castbar.Max:SetJustifyH("RIGHT")
    fr.Castbar.Max:SetFont(font, cfg.fontsize-2, "THINOUTLINE")
    fr.Castbar.Max:SetPoint("RIGHT", fr.Castbar.Time, "LEFT", 0, 0)
    fr.Castbar.CustomTimeText = CustomCastTimeText

    fr.Castbar.Icon:SetHeight(cfg.units.player.castbar.height)
    fr.Castbar.Icon:SetWidth(cfg.units.player.castbar.height)
    fr.Castbar.Icon:SetPoint("LEFT", fr.Castbar, -(cfg.units.player.castbar.height + 2), 0)
  elseif(fr.mystyle == "target") then

  elseif(fr.mystyle == "targettarget") then

  elseif(fr.mystyle == "focus") then

  end
end
