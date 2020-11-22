local _, ns = ...

local watchers = ns.watchers

watchers.DRUID = {
    [102] = { -- Balance
        [1] = {spellID = 190984, auraID = 48517, glow = "button"}, -- Wrath / Eclipse
        [2] = {spellID = 194153, auraID = 48518, glow = "button"}, -- Starfire / Eclipse
        [3] = {spellID = 78674, glow = "pixel"}, -- Starsurge
        [4] = {spellID = 191034, glow = "pixel"}, -- Starfall
        [5] = {spellID = 78675} -- Solar Beam
    },
    [103] = { -- Feral
        [1] = {spellID = 5221, auraID = 135700, glow = "button"}, -- Shread / Clearcasting
        [2] = {spellID = 22570}, -- Maim
        [3] = {spellID = 5217}, -- Tiger's Fury
        [4] = {spellID = 106839}, -- Skull Bash
        [5] = {spellID = 106951}, -- Berserk
    },
    [104] = { -- Guardian
        [1] = {spellID = 33917, auraID = 93622, glow = "button"}, -- Mangle / Gore
        [2] = {spellID = 77758}, -- Thrash
        [3] = {spellID = 6807}, -- Maul
        [4] = {spellID = 192081, glow = "pixel"}, -- Ironfur
        [5] = {spellID = 22842}, -- Frenzied Regeneration
    },
    [105] = { -- Restoration
        [1] = {spellID = 8936, auraID = 16870}, -- Regrowth / Clearcasting
        [2] = {spellID = 18562}, -- Swiftmend
        [3] = {spellID = 48438}, -- Wild Growth
        [4] = {spellID = 740}, -- Tranquility
        [5] = {spellID = 33891}, -- Incarnation: Tree of Life
    }
}
