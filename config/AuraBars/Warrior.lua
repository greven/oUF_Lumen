local _, ns = ...

local filters = ns.filters

filters.WARRIOR = {
  buffs = {
    [184362 or "Enraged"] = true,
    [184364 or "Enraged Regeneration"] = true,
    [260708 or "Sweeping Strikes"] = true
  },
  debuffs = {}
}
