local _, ns = ...

local filters = ns.filters

filters.PALADIN = {
  buffs = {
    [31884 or "Avenging Wrath"] = true,
    [184662 or "Shield of Vengeance"] = true,
    [642 or "Divine Shield"] = true
  },
  debuffs = {
    [853 or "Hammer of Justice"] = true,
    [197277 or "Judgment"] = true
  }
}
