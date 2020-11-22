local _, ns = ...

local watchers = ns.watchers

watchers.ROGUE = {
    [259] = { -- Assassination
        [1] = {spellID = 8676, auraID = 121153, glow = "button"}, -- Ambush / Blindside
        [2] = {spellID = 79140}, -- Vendetta
        [3] = {spellID = 5938}, -- Shiv
        [4] = {spellID = 2094}, -- Blind
        [5] = {spellID = 31224} -- Cloak of Shadows
    },
    [260] = { -- Outlaw
        [1] = {spellID = 185763, auraID = 195627, glow = "button"}, -- Pistol Shot / Opportunity
        [2] = {spellID = 315341}, -- Between the Eyes
        [3] = {spellID = 315508}, -- Roll the Bones
        [4] = {spellID = 13877}, -- Blade Flurry
        [5] = {spellID = 13750} -- Adrenaline Rush
    },
    [261] = { -- Subtlety
        [1] = {spellID = 212283}, -- Symbols of Death
        [2] = {spellID = 185313, glow = "pixel"}, -- Shadow Dance
        [3] = {spellID = 121471}, -- Shadow Blades
        [4] = {spellID = 280719}, -- Secret Technique
        [5] = {spellID = 31224} -- Cloak of Shadows
    }
}
