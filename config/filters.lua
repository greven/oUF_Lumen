local _, ns = ...

local filters = {}
ns.filters = filters

-- ------------------------------------------------------------------------
-- > AURAS FILTER LIST
-- ------------------------------------------------------------------------

filters.list = {
  DEMONHUNTER = {
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
      [GetSpellInfo(77764) or "Stampeding Roar"] = true,
    },

    debuffs = {
      [GetSpellInfo(203123) or "Maim"] = true,
      [GetSpellInfo(155722) or "Rake"] = true,
      [GetSpellInfo(1079) or "Rip"] = true,
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
      [GetSpellInfo(15286) or "Vampiric Embrace"] = true,
    },

    debuffs = {
      [GetSpellInfo(589) or "Shadow Word: Pain"] = true,		    	           
      [GetSpellInfo(34914) or "Vampiric Touch"] = true,   		    	         
    }
  },

  ROGUE = {
    buffs = {
      [GetSpellInfo(13750) or "Adrenaline Rush"] = true,		    	           
      [GetSpellInfo(193356) or "Broadsides"] = true,						             
      [GetSpellInfo(199600) or "Buried Treasure"] = true,						         
      [GetSpellInfo(5277) or "Evasion"] = true,			    		                 
      [GetSpellInfo(193358) or "Grand Melee"] = true,						             
      [GetSpellInfo(199603) or "Jolly Roger"] = true,						             
      [GetSpellInfo(51713) or "Shadow Dance"] = true,			    	             
      [GetSpellInfo(193357) or "Shark Infested Waters"] = true,						   
      [GetSpellInfo(5171) or "Slice and Dice"] = true,				               
      [GetSpellInfo(48594) or "Sprint"] = true,                						   
      [GetSpellInfo(193359) or "True Bearing"] = true,						           
    },

    debuffs = {
      [GetSpellInfo(2094) or "Blind"] = true,					    	                 
      [GetSpellInfo(1833) or "Cheap Shot"] = true,										       
      [GetSpellInfo(703) or "Garrote"] = true,											         
      [GetSpellInfo(1776) or "Gouge"] = true,					    						        
      [GetSpellInfo(408) or "Kidney Shot"] = true,										       
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
      -- [GetSpellInfo(197992) or "Landslide"] = true,			  	 	             
      [GetSpellInfo(73685) or "Unleash Life"] = true, 			  	 	            
    },

    debuffs = {
      [GetSpellInfo(188389) or "Flame Shock"] = true,			  	 	              
      [GetSpellInfo(196840) or "Frost Shock"] = true,
    }		  	 	              
  },

  WARLOCK = {
    buffs = {
      [GetSpellInfo(216708) or "Deadwind Harvester"] = true,			  	 	     
      [GetSpellInfo(108416) or "Dark Pact"] = true,			  	 	               
      [GetSpellInfo(104773) or "Unending Resolve"] = true,			  	 	       
    },

    debuffs = {
      [GetSpellInfo(980) or "Agony"] = true,			  	 	                     
      [GetSpellInfo(172) or "Corruption"] = true,				  		               
      [GetSpellInfo(603) or "Doom"] = true,								 			             
      [GetSpellInfo(1098) or "Enslave Demon"] = true, 								 			 
      -- [GetSpellInfo(196412) or "Eradication"] = true, 								 		
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
      [GetSpellInfo(184364) or "Enraged Regeneration"] = true,	
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
  }
}
