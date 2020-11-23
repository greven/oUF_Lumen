local _, ns = ...

local watchers = ns.watchers

watchers.WARRIOR = {
    [71] = { -- Arms

    },
    [72] = { -- Fury
        [1] = {spellID = 23881}, -- Bloodthirst
        [2] = {spellID = 85288}, -- Raging Blow
        [3] = {spellID = 184367, glow = "pixel"}, -- Rampage
        [4] = {spellID = 5308, auraID = 280776, glow = "button"}, -- Execute / Sudden Death
        [5] = {spellID = 1719} -- Recklessness
    },
    [73] = { -- Protection

    }
}
