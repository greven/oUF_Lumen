local _, ns = ...

local filters = ns.filters

filters.PRIEST = {
  buffs = {
    [194384 or "Atonement"] = true,
    [17 or "Power Word: Shield"] = true,
    [15286 or "Vampiric Embrace"] = true,
    [194249 or "Voidform"] = true
  },
  debuffs = {
    [335467 or "Devouring Plague"] = true,
    [204213 or "Purge the Wicked"] = true,
    [214621 or "Schism"] = true,
    [64044 or "Psychic Horror"] = true,
    [589 or "Shadow Word: Pain"] = true,
    [34914 or "Vampiric Touch"] = true
  }
}
