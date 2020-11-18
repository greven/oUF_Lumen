local _, ns = ...

local watchers = ns.watchers

watchers.PRIEST = {
  Discipline = {},
  Holy = {},
  Shadow = {
    [1] = {spellID = 8092, auraID = 341207, glow = true}, -- Mind Blast / Dark Thought
    [2] = {spellID = 335467}, -- Devouring Plague
    [3] = {spellID = 32379}, -- Shadow Word: Death
    [4] = {spellID = 263165}, -- Void Torrent
    [5] = {spellID = 228260, auraID = 194249, altID = 205448, glow = false} -- Void Eruption / Voidform / Void Bolt
  }
}
