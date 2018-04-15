local _, ns = ...

local debuffs = {}
ns.debuffs = debuffs

-- ------------------------------------------------------------------------
-- > DEBUFFS BLACKLIST
-- ------------------------------------------------------------------------

debuffs.list = {
  player = {
    [GetSpellInfo(57723) or "Exhaustion"] = true,
    [GetSpellInfo(80354) or "Temporal Displacement"] = true,
  },
  target = {
    
  }
}
