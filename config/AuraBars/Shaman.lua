local _, ns = ...

local filters = ns.filters

filters.SHAMAN = {
  buffs = {
    [108281 or "Ancestral Guidance"] = true,
    [114051 or "Ascendance"] = true,
    [187874 or "Crash Lightning"] = true,
    [193796 or "Flametongue"] = true,
    [196834 or "Frostbrand"] = true,
    [260734 or "Master of the Elements"] = true,
    [191634 or "Stormkeeper"] = true,
    [73685 or "Unleash Life"] = true
  },
  debuffs = {
    [188389 or "Flame Shock"] = true,
    [196840 or "Frost Shock"] = true
  }
}
