local _, ns = ...

local debuffs = {}
ns.debuffs = debuffs

-- ------------------------------------------------------------------------
-- > DEBUFFS BLACKLIST
-- ------------------------------------------------------------------------

debuffs.list = {
  player = {
    [GetSpellInfo(57723) or "Exhaustion"] = true,
    [GetSpellInfo(264689) or "Fatigued"] = true,
    [GetSpellInfo(95809) or "Insanity"] = true,
    [GetSpellInfo(57724) or "Sated"] = true,
    [GetSpellInfo(80354) or "Temporal Displacement"] = true,
  },
  target = {

  }
}
