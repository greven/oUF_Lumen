local _, ns = ...

local watchers = ns.watchers

watchers.ROGUE = {
  Assassination = {
    [1] = {spellID = 1329}, -- Mutilate
    [2] = {spellID = 703}, -- Garrote
    [3] = {spellID = 8676, auraID = 121153, glow = {type = "button"}} -- Ambush / Blindside
  },
  Outlaw = {},
  Subtlety = {
    [1] = {spellID = 212283}, -- Symbols of Death
    [2] = {spellID = 185313, glow = {type = "pixel"}}, -- Shadow Dance
    [3] = {spellID = 121471}, -- Shadow Blades
    [4] = {spellID = 280719}, -- Secret Technique
    [5] = {spellID = 31224} -- Cloak of Shadows
  }
}
