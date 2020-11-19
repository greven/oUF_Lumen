local _, ns = ...

local watchers = ns.watchers

watchers.DRUID = {
  Balance = {
    [1] = {spellID = 190984, auraID = 48517, glow = {type = "button"}}, -- Wrath / Eclipse
    [2] = {spellID = 194153, auraID = 48518, glow = {type = "button"}}, -- Starfire / Eclipse
    [3] = {spellID = 78674, glow = {type = "pixel"}}, -- Starsurge
    [4] = {spellID = 191034, glow = {type = "pixel"}}, -- Starfall
    [5] = {spellID = 78675} -- Solar Beam
  },
  Feral = {},
  Guardian = {},
  Restoration = {}
}
