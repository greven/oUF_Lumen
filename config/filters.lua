local _, ns = ...

local filters = {}
ns.filters = filters

-- ------------------------------------------------------------------------
-- > BARTIMERS AURAS FILTER LIST (Whitelist)
-- ------------------------------------------------------------------------

filters.list = {
  DEFAULT = {
    buffs = {
      [GetSpellInfo(2825) or "Bloodlust"] = true,
      [GetSpellInfo(32182) or "Heroism"] = true,
      [GetSpellInfo(80353) or "Time Warp"] = true,
    }
  },

  DEMONHUNTER = {
    buffs = {

    },

    debuffs = {

    }
  },

  DEATHKNIGHT = {
    buffs = {
      [GetSpellInfo(48792) or "Icebound Fortitude"] = true,
      [GetSpellInfo(196770) or "Remorseless Winter"] = true,
      [GetSpellInfo(207256) or "Obliteration"] = true,
      [GetSpellInfo(55233) or "Vampiric Blood"] = true,
    },

    debuffs = {
      [GetSpellInfo(55078) or "Blood Plague"] = true,
      [GetSpellInfo(194310) or "Festering Wound"] = true,
      [GetSpellInfo(191587) or "Virulent Plague"] = true,
    }
  },

  DRUID = {
    buffs = {
      [GetSpellInfo(77764) or "Stampeding Roar"] = true,
      [GetSpellInfo(191034) or "Starfall"] = true,
    },

    debuffs = {
      [GetSpellInfo(203123) or "Maim"] = true,
      [GetSpellInfo(164812) or "Moonfire"] = true,
      [GetSpellInfo(155722) or "Rake"] = true,
      [GetSpellInfo(1079) or "Rip"] = true,
      [GetSpellInfo(164815) or "Sunfire"] = true,
    }
  },

  HUNTER = {
    buffs = {
      [GetSpellInfo(186258) or "Aspect of the Chetah"] = true,
      [GetSpellInfo(186289) or "Aspect of the Eagle"] = true,
      [GetSpellInfo(186265) or "Aspect of the Turtle"] = true,
      [GetSpellInfo(19574) or "Bestial Wrath"] = true,
      [GetSpellInfo(199483) or "Camouflage"] = true,
      [GetSpellInfo(266779) or "Coordinated Assault"] = true,
      [GetSpellInfo(5384) or "Feign Death"] = true,
      [GetSpellInfo(193526) or "Trueshot"] = true,
    },

    debuffs = {
      [GetSpellInfo(217200) or "Barbed Shot"] = true,
      [GetSpellInfo(5116) or "Concussive Shot"] = true,
      [GetSpellInfo(3355) or "Freezing Trap"] = true,
      [GetSpellInfo(259491) or "Serpent Sting"] = true,
    }
  },

  MAGE = {
    buffs = {
      [GetSpellInfo(44544) or "Fingers of Frost"] = true,
      [GetSpellInfo(12472) or "Icy Veins"] = true,
    },

    debuffs = {

    }
  },

  MONK = {
    buffs = {

    },

    debuffs = {

    }
  },

  PALADIN = {
    buffs = {
      [GetSpellInfo(31884) or "Avenging Wrath"] = true,
      [GetSpellInfo(184662) or "Shield of Vengeance"] = true,
      [GetSpellInfo(642) or "Divine Shield"] = true,
    },

    debuffs = {
      [GetSpellInfo(853) or "Hammer of Justice"] = true,
      [GetSpellInfo(197277) or "Judgment"] = true,
    }
  },

  PRIEST = {
    buffs = {
      [GetSpellInfo(194384) or "Atonement"] = true,
      [GetSpellInfo(15286) or "Vampiric Embrace"] = true,
      [GetSpellInfo(194249) or "Voidform"] = true,
    },

    debuffs = {
      [GetSpellInfo(204213) or "Purge the Wicked"] = true,
      [GetSpellInfo(214621) or "Schism"] = true,
      [GetSpellInfo(589) or "Shadow Word: Pain"] = true,
      [GetSpellInfo(34914) or "Vampiric Touch"] = true,
    }
  },

  ROGUE = {
    buffs = {
      [GetSpellInfo(13750) or "Adrenaline Rush"] = true,
      [GetSpellInfo(13877) or "Blade Flurry"] = true,
      [GetSpellInfo(193356) or "Broadside"] = true, -- Roll the Bones
      [GetSpellInfo(199600) or "Buried Treasure"] = true, -- Roll the Bones
      [GetSpellInfo(31224) or "Cloak of Shadows"] = true,
      [GetSpellInfo(5277) or "Evasion"] = true,
      [GetSpellInfo(193358) or "Grand Melee"] = true, -- Roll the Bones
      [GetSpellInfo(199754) or "Riposte"] = true,
      [GetSpellInfo(193357) or "Ruthless Precision"] = true, -- Roll the Bones
      [GetSpellInfo(121471) or "Shadow Blades"] = true,
      [GetSpellInfo(51713) or "Shadow Dance"] = true,
      [GetSpellInfo(114018) or "Shroud of Concealment"] = true,
      [GetSpellInfo(199603) or "Skull and Crossbones"] = true, -- Roll the Bones
      [GetSpellInfo(5171) or "Slice and Dice"] = true,
      [GetSpellInfo(48594) or "Sprint"] = true,
      [GetSpellInfo(193359) or "True Bearing"] = true, -- Roll the Bones
      [GetSpellInfo(11327) or "Vanish"] = true,
    },

    debuffs = {
      [GetSpellInfo(2094) or "Blind"] = true,
      [GetSpellInfo(199804) or "Between the Eyes"] = true,
      [GetSpellInfo(1833) or "Cheap Shot"] = true,
      [GetSpellInfo(703) or "Garrote"] = true,
      [GetSpellInfo(128904) or "Garrote - Silence"] = true,
      [GetSpellInfo(1776) or "Gouge"] = true,
      [GetSpellInfo(408) or "Kidney Shot"] = true,
      [GetSpellInfo(195452) or "Knight Blade"] = true,
      [GetSpellInfo(1943) or "Rupture"] = true,
      [GetSpellInfo(6770) or "Sap"] = true,
      [GetSpellInfo(79140) or "Vendetta"] = true,
    }
  },

  SHAMAN = {
    buffs = {
      [GetSpellInfo(108281) or "Ancestral Guidance"] = true,
      [GetSpellInfo(201897) or "Boulderfist"] = true,
      [GetSpellInfo(193796) or "Flametongue"] = true,
      [GetSpellInfo(196834) or "Frostbrand"] = true,
      [GetSpellInfo(77762) or "Lave Surge"] = true,
      [GetSpellInfo(260734) or "Master of the Elements"] = true,
      [GetSpellInfo(191634) or "Stormkeeper"] = true,
      [GetSpellInfo(73685) or "Unleash Life"] = true,
    },

    debuffs = {
      [GetSpellInfo(188389) or "Flame Shock"] = true,
      [GetSpellInfo(196840) or "Frost Shock"] = true,
    }
  },

  WARLOCK = {
    buffs = {
      [GetSpellInfo(117828) or "Backdraft"] = true,
      [GetSpellInfo(216708) or "Deadwind Harvester"] = true,
      [GetSpellInfo(108416) or "Dark Pact"] = true,
      [GetSpellInfo(104773) or "Unending Resolve"] = true,
    },

    debuffs = {
      [GetSpellInfo(980) or "Agony"] = true,
      [GetSpellInfo(172) or "Corruption"] = true,
      [GetSpellInfo(603) or "Doom"] = true,
      [GetSpellInfo(1098) or "Enslave Demon"] = true,
      [GetSpellInfo(5785) or "Fear"] = true,
      [GetSpellInfo(80240) or "Havoc"] = true,
      [GetSpellInfo(348) or "Immolate"] = true,
      [GetSpellInfo(205179) or "Phantom Singularity"] = true,
      [GetSpellInfo(27243) or "Seed of Corruption"] = true,
      [GetSpellInfo(63106) or "Siphon Life"] = true,
      [GetSpellInfo(30108) or "Unstable Affliction"] = true,
    }
  },

  WARRIOR = {
    buffs = {
      [GetSpellInfo(184362) or "Enraged"] = true,
      [GetSpellInfo(184364) or "Enraged Regeneration"] = true,
      [GetSpellInfo(260708) or "Sweeping Strikes"] = true,
    },

    debuffs = {

    }
  },

  PET = {
    -- Buffs
    [GetSpellInfo(193396) or "Demonic Empowerment"] = true,
    [GetSpellInfo(136) or "Mend Pet"] = true,
  },

  PARTY = {
    -- Debuffs
    [GetSpellInfo(57723) or "Exhaustion"] = true,
    [GetSpellInfo(264689) or "Fatigued"] = true,
    [GetSpellInfo(95809) or "Insanity"] = true,
    [GetSpellInfo(57724) or "Sated"] = true,
    [GetSpellInfo(80354) or "Temporal Displacement"] = true,
  }
}
