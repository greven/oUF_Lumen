local A, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local filters = ns.filters

local font = m.fonts.font

local frame = "pet"

-- -----------------------------------

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

local function CreatePet(self)
  self.mystyle = frame
  self.cfg = cfg.units[frame]

  lum:SharedStyle(self, "secondary")

  -- Texts
  lum:CreateNameString(self, font, cfg.fontsize - 2, "THINOUTLINE", 3, 0, "LEFT", self.cfg.width - 8)
  self:Tag(self.Name, "[lum:name]")

  -- Auras
  local buffs = lum:SetBuffAuras(self, frame, 5, 1, cfg.frames.secondary.height + 4, 2, "TOPRIGHT", self, "TOPLEFT", -6, 2, "TOPRIGHT", "LEFT", "DOWN", true)

  if (self.cfg.auras.buffs.filter) then
    buffs.CustomFilter = PetBuffsFilter
  end

  -- Heal Prediction
  lum:CreateHealPrediction(self)
end

-- -----------------------------------
-- > SPAWN UNIT
-- -----------------------------------
if cfg.units[frame].show then
  oUF:RegisterStyle(A .. frame:gsub("^%l", string.upper), CreatePet)
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
