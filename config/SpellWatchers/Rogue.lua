local _, ns = ...

local watchers = ns.watchers

watchers.ROGUE = {
    [259] = { -- Assassination
        [1] = {spellID = 1329}, -- Mutilate
        [2] = {spellID = 703}, -- Garrote
        [3] = {spellID = 8676, auraID = 121153, glow = "button"} -- Ambush / Blindside
    },
    [260] = { -- Outlaw

    },
    [261] = { -- Subtlety
        [1] = {spellID = 212283}, -- Symbols of Death
        [2] = {spellID = 185313, glow = "pixel"}, -- Shadow Dance
        [3] = {spellID = 121471}, -- Shadow Blades
        [4] = {spellID = 280719}, -- Secret Technique
        [5] = {spellID = 31224} -- Cloak of Shadows
    }
}
