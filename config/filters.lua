local _, ns = ...

local filters = {}
ns.filters = filters

-- ------------------------------------------------------------------------
-- > AURAS FILTER LIST
-- ------------------------------------------------------------------------

filters.list = {
  DAEMONHUNTER = {
    buffs = {

    },

    debuffs = {

    }
  },

  DEATHKNIGHT = {
    buffs = {

    },

    debuffs = {

    }
  },

  DRUID = {
    buffs = {

    },

    debuffs = {

    }
  },

  HUNTER = {
    buffs = {

    },

    debuffs = {

    }
  },

  MAGE = {
    buffs = {

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

    },

    debuffs = {

    }
  },

  PRIEST = {
    buffs = {

    },

    debuffs = {

    }
  },

  ROGUE = {
    buffs = {
      [GetSpellInfo(13750) or "Adrenaline Rush"] = true,		    	           -- Adrenaline Rush
      [GetSpellInfo(193356) or "Broadsides"] = true,						             -- Broadsides (Roll the Bones)
      [GetSpellInfo(199600) or "Buried Treasure"] = true,						         -- Buried Treasure (Roll the Bones)
      [GetSpellInfo(5277) or "Evasion"] = true,			    		                 -- Evasion
      [GetSpellInfo(193358) or "Grand Melee"] = true,						             -- Grand Melee (Roll the Bones)
      [GetSpellInfo(199603) or "Jolly Roger"] = true,						             -- Jolly Roger (Roll the Bones)
      [GetSpellInfo(51713) or "Shadow Dance"] = true,			    	             -- Shadow Dance
      [GetSpellInfo(193357) or "Shark Infested Waters"] = true,						   -- Shark Infested Waters (Roll the Bones)
      [GetSpellInfo(5171) or "Slice and Dice"] = true,				               -- Slice and Dice
      [GetSpellInfo(48594) or "Sprint"] = true,                						   -- Sprint
      [GetSpellInfo(193359) or "True Bearing"] = true,						           -- True Bearing (Roll the Bones)
    },

    debuffs = {
      [GetSpellInfo(2094) or "Blind"] = true,					    	                 -- Blind
      [GetSpellInfo(1833) or "Cheap Shot"] = true,										       -- Cheap Shot
      [GetSpellInfo(703) or "Garrote"] = true,											         -- Garrote
      [GetSpellInfo(1776) or "Gouge"] = true,					    						       -- Gouge
      [GetSpellInfo(408) or "Kidney Shot"] = true,										       -- Kidney Shot
      [GetSpellInfo(1943) or "Rupture"] = true,											         -- Rupture
      [GetSpellInfo(6770) or "Sap"] = true,												           -- Sap
      [GetSpellInfo(79140) or "Vendetta"] = true,								 			       -- Vendetta
    }
  },

  SHAMAN = {
    buffs = {

    },

    debuffs = {

    }
  },

  WARLOCK = {
    buffs = {
      [GetSpellInfo(108416) or "Dark Pact"] = true,			  	 	               -- Dark Pact
    },

    debuffs = {
      [GetSpellInfo(980) or "Agony"] = true,			  	 	                     -- Agony
      [GetSpellInfo(172) or "Corruption"] = true,				  		               -- Corruption
      [GetSpellInfo(603) or "Doom"] = true,								 			             -- Doom
      [GetSpellInfo(5785) or "Fear"] = true,								 			           -- Fear
      [GetSpellInfo(348) or "Immolate"] = true,						                   -- Immolate
      [GetSpellInfo(30108) or "Unstable Affliction"] = true,			           -- Unstable Affliction
    }
  },

  WARRIOR = {
    buffs = {

    },

    debuffs = {
      [GetSpellInfo(710) or "Banish"] = true,				  			                 -- Banish
    }
  },

  PET = {
    -- Buffs
    [GetSpellInfo(193396) or "Demonic Empowerment"] = true,                  -- Demonic Empowerment (Warlock)
    [GetSpellInfo(136) or "Mend Pet"] = true,						                     -- Mend Pet (Hunter)
  }
}
