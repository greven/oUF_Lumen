local _, ns = ...

local filters = ns.filters

filters.PET = {
  buffs = {
    [63560 or "Dark Transformation"] = true,
    [193396 or "Demonic Empowerment"] = true,
    [136 or "Mend Pet"] = true
  },
  debuffs = {}
}
