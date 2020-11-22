local _, ns = ...

local filters = ns.filters

filters.DEATHKNIGHT = {
    buffs = {
        [48792 or "Icebound Fortitude"] = true,
        [196770 or "Remorseless Winter"] = true,
        [207256 or "Obliteration"] = true,
        [55233 or "Vampiric Blood"] = true
    },
    debuffs = {
        [55078 or "Blood Plague"] = true,
        [194310 or "Festering Wound"] = true,
        [191587 or "Virulent Plague"] = true
    }
}
