local _, ns = ...

local watchers = ns.watchers

watchers.DEATHKNIGHT = {
    [250] = { -- Blood
        [1] = {spellID = 195182}, -- Marrowrend
        [2] = {spellID = 50842}, -- Bloodboil
        [3] = {spellID = 43265, auraID = 81141, glow = "button"}, -- Death and Decay / Crimson Scourge
        [4] = {spellID = 49576}, -- Death Grip
        [5] = {spellID = 221562}, -- Asphyxiate
    },
    [251] = { -- Frost
        [1] = {spellID = 49020}, -- Obliterate
        [2] = {spellID = 49143}, -- Frost Strike
        [3] = {spellID = 49184, auraID = 59052, glow = "button"}, -- Howling Blast / Rime
        [4] = {spellID = 196770}, -- Remorseless Winter
        [5] = {spellID = 51271} -- Pillar of Frost
    },
    [252] = { -- Unholy
        [1] = {spellID = 85948}, -- Festering Strike
        [2] = {spellID = 77575}, -- Outbreak
        [3] = {spellID = 47541, auraID = 81340, glow = "button"}, -- Death Coil / Sudden Doom
        [4] = {spellID = 63560}, -- Dark Transformation
        [5] = {spellID = 275699}, -- Apocalypse
    }
}
