local _, ns = ...

local watchers = ns.watchers

watchers.PRIEST = {
  [256] = {},
  [65] = {},
  [258] = {
    [1] = {spellID = 8092, auraID = 341207, glow = {type = "button"}}, -- Mind Blast / Dark Thought
    [2] = {spellID = 335467, glow = {type = "pixel"}}, -- Devouring Plague
    [3] = {spellID = 32379}, -- Shadow Word: Death
    [4] = {spellID = 263165}, -- Void Torrent
    [5] = {spellID = 228260, auraID = 194249, altID = 205448, glow = nil} -- Void Eruption / Voidform / Void Bolt
  }
}
