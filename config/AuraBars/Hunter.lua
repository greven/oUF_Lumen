local _, ns = ...

local filters = ns.filters

filters.HUNTER = {
  buffs = {
    [186258 or "Aspect of the Chetah"] = true,
    [186289 or "Aspect of the Eagle"] = true,
    [186265 or "Aspect of the Turtle"] = true,
    [19574 or "Bestial Wrath"] = true,
    [199483 or "Camouflage"] = true,
    [266779 or "Coordinated Assault"] = true,
    [5384 or "Feign Death"] = true,
    [193526 or "Trueshot"] = true
  },
  debuffs = {
    [217200 or "Barbed Shot"] = true,
    [5116 or "Concussive Shot"] = true,
    [3355 or "Freezing Trap"] = true,
    [259491 or "Serpent Sting"] = true
  }
}
