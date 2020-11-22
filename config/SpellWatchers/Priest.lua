local _, ns = ...

local watchers = ns.watchers

watchers.PRIEST = {
  Discipline = {
    [1] = {spellID = 47540, auraID = 198069, glow = {type = "pixel"}}, -- Penance /
    [2] = {spellID = 194509}, -- Power Word: Radiance
    [3] = {spellID = 8092}, -- Mind Blast
    [4] = {spellID = 214621}, -- Schism
    [5] = {spellID = 129250} -- Power Word: Solace
  },
  Holy = {
    [1] = {spellID = 2061, auraID = 114255, glow = {type = "button"}}, -- Flash Heal / Surge of Light
    [2] = {spellID = 2050}, -- Holy Word: Serenity
    [3] = {spellID = 34861}, -- Holy Word: Sanctify
    [4] = {spellID = 204883}, -- Circle of Healing
    [5] = {spellID = 33076} -- Prayer of Mending
  },
  Shadow = {
    [1] = {spellID = 8092, auraID = 341207, glow = {type = "button"}}, -- Mind Blast / Dark Thought
    [2] = {spellID = 335467, glow = {type = "pixel"}}, -- Devouring Plague
    [3] = {spellID = 32379}, -- Shadow Word: Death
    [4] = {spellID = 263165}, -- Void Torrent
    [5] = {spellID = 228260, auraID = 194249, altID = 205448, glow = nil} -- Void Eruption / Voidform / Void Bolt
  }
}
