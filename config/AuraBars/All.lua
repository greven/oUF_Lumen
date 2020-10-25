local _, ns = ...

local filters = {}
ns.filters = filters

filters.ALL = {
  buffs = {
    [2825 or "Bloodlust"] = true,
    [32182 or "Heroism"] = true,
    [80353 or "Time Warp"] = true,
    -- Racials
    [256948 or "Spatial Rift"] = true,
    [20594 or "Stone Form"] = true
  },
  debuffs = {}
}
