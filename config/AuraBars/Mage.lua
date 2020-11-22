local _, ns = ...

local filters = ns.filters

filters.MAGE = {
    buffs = {
        [44544 or "Fingers of Frost"] = true,
        [12472 or "Icy Veins"] = true
    },
    debuffs = {}
}
