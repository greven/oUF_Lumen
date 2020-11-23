local _, ns = ...

local watchers = ns.watchers

watchers.SHAMAN = {
    [262] = { -- Elemental
        [1] = {spellID = 188389}, -- Flame Shock
        [2] = {spellID = 51505, auraID = 77762, glow = "button"}, -- Lava Burst / Lava Surge
        [3] = {spellID = 8042, glow = "pixel"}, -- Earth Shock
        [4] = {spellID = 191634}, -- Stormkeeper
        [5] = {spellID = 198067}, -- Fire Elemental

    },
    [263] = { -- Enhancement
        [1] = {spellID = 17364, auraID = 201846, glow = "button"}, -- Stormstrike / Stormbring
        [2] = {spellID = 60103}, -- Lava Lash
        [3] = {spellID = 188389}, -- Flame Shock
        [4] = {spellID = 187874}, -- Crash Lightning
        [5] = {spellID = 188443, auraID = 344179, auraCount = 5, glow = "button"}, -- Chain Lightning / Maelstrom Weapon
    },
    [264] = { -- Restoration

    }
}
