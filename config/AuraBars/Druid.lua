local _, ns = ...

local filters = ns.filters

filters.DRUID = {
  buffs = {
    [77764 or "Stampeding Roar"] = true,
    [191034 or "Starfall"] = true
  },
  debuffs = {
    [203123 or "Maim"] = true,
    [164812 or "Moonfire"] = true,
    [155722 or "Rake"] = true,
    [1079 or "Rip"] = true,
    [164815 or "Sunfire"] = true
  }
}
