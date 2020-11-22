local _, ns = ...

local filters = ns.filters

filters.DRUID = {
    buffs = {
        [1850 or "Dash"] = true,
        [48518 or "Eclipse (Lunar)"] = true,
        [48517 or "Eclipse (Solar)"] = true,
        [192081 or "Iron Fur"] = true,
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
