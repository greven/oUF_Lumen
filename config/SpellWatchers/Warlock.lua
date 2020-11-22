local _, ns = ...

local watchers = ns.watchers

watchers.WARLOCK = {
    [265] = { -- Affliction

    },
    [266] = { -- Demonology

    },
    [267] = { -- Destruction
        [1] = {spellID = 17962, glow = {type = "pixel"}}, -- Conflagrate
        [2] = {spellID = 116858, glow = {type = "pixel"}} -- Chaos Bolt
    }
}
