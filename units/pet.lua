local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "pet"

-- ------------------------------------------------------------------------
-- > PET UNIT SPECIFIC FUNCTiONS
-- ------------------------------------------------------------------------

-- Post Health Update
local PostUpdateHealth = function(health, unit, min, max)
  local self = health.__owner

  if cfg.units[frame].health.gradientColored then
    local color = CreateColor(oUF.ColorGradient(min, max, 1, 0, 0, 1, 1, 0, 0 / 255, 204 / 255, 180 / 255)) -- Red, Yellow, Full Health Color
    health:SetStatusBarColor(color:GetRGB())
  end

  -- Class colored text
  if cfg.units[frame].health.classColoredText then
    self.Name:SetTextColor(unpack(api:RaidColor(unit)))
  end
end

-- Post Update Aura Icon
local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
  local name, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

  if duration and duration > 0 then
    icon.timeLeft = expirationTime - GetTime()
  else
    icon.timeLeft = math.huge
  end

  icon:SetScript(
    "OnUpdate",
    function(self, elapsed)
      lum:AuraTimer_OnUpdate(self, elapsed)
    end
  )
end

-- Filter Buffs
local PetBuffsFilter = function(...)
  local spellID = select(13, ...)
  if spellID and filters.PET.buffs[spellID] then
    return true
  end
end

-- -----------------------------------
-- > TARGET STYLE
-- -----------------------------------

local createStyle = function(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "secondary")

  -- Texts
  lum:CreateNameString(self, font, cfg.fontsize - 1, "THINOUTLINE", 2, 0, "LEFT", self.cfg.width - 8)
  self:Tag(self.Name, "[lum:name]")
  -- lum:CreateHealthValueString(self, font, cfg.fontsize - 4, "THINOUTLINE", -4, 0, "RIGHT")
  -- self:Tag(self.Health.value, '[lum:hpperc]')

  -- Health & Power Updates
  self.Health.PostUpdate = PostUpdateHealth

  -- Buffs
  local buffs = lum:CreateAura(self, 5, 1, cfg.frames.secondary.height + 4, 2)
  buffs:SetPoint("BOTTOMLEFT", "oUF_LumenPet", "TOPLEFT", -2, 6)
  buffs.initialAnchor = "BOTTOMLEFT"
  buffs["growth-x"] = "RIGHT"
  buffs.PostUpdateIcon = PostUpdateIcon
  if (self.cfg.buffs.filter) then
    buffs.CustomFilter = PetBuffsFilter
  end
  self.Buffs = buffs

  -- Heal Prediction
  lum:CreateHealPrediction(self)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), createStyle)
  oUF:SetActiveStyle(A .. frame:gsub("^%l", string.upper))
  local f = oUF:Spawn(frame, A .. frame:gsub("^%l", string.upper))
  -- Frame Visibility
  if cfg.units[frame].visibility then
    f:Disable()
    RegisterStateDriver(f, "visibility", cfg.units[frame].visibility)
  end
  -- Fader
  if cfg.units[frame].fader then
    api:CreateFrameFader(f, cfg.units[frame].fader)
  end
end
