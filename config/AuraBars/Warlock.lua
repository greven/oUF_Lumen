local _, ns = ...

local filters = ns.filters

filters.WARLOCK = {
  buffs = {
    [117828 or "Backdraft"] = true,
    [216708 or "Deadwind Harvester"] = true,
    [108416 or "Dark Pact"] = true,
    [104773 or "Unending Resolve"] = true
  },
  debuffs = {
    [980 or "Agony"] = true,
    [172 or "Corruption"] = true,
    [603 or "Doom"] = true,
    [1098 or "Enslave Demon"] = true,
    [5785 or "Fear"] = true,
    [80240 or "Havoc"] = true,
    [157736 or "Immolate"] = true,
    [205179 or "Phantom Singularity"] = true,
    [27243 or "Seed of Corruption"] = true,
    [63106 or "Siphon Life"] = true,
    [30108 or "Unstable Affliction"] = true
  }
}
