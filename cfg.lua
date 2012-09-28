	
	local addon, ns = ...
	local cfg = CreateFrame("Frame")

-- ------------------------------------------------------------------------
-- > 0. Settings
-- ------------------------------------------------------------------------

	-- General
	
	cfg.fontsize = 11 -- The Global Font Size
	cfg.scale = 1 -- The Frames Scale
	
	cfg.useShadows = true -- Creates frame drop shadows
	cfg.shadowAlpha = 0.7
	
	cfg.bdc = {r = 0, g = 0, b = 0, a = 1} -- Backdrop Color (Some frames might not be affected)
	
	cfg.hideBlizzCompactRaidFrames = true -- Hide Blizzard Compact Raid Frames
		
	-- Frames
	
		-- Colors [Only applied to non-group Frames]
		cfg.useClassColors = true -- Uses Class Color in the Frames (Player, Target...). If set to false other frames will be colored by reaction
		cfg.useReactionColor = true -- If set to false frames will be colored by the color defined below this line...
		cfg.hpColor = {0.3,0.3,0.3,1} -- The Color to use if cfg.useClassColors and cfg.useReactionColor are set to false
		cfg.useClassColoredPower = false -- Colors the Power by class color
		cfg.useClassColoredNames = false -- Colors the unit names by Class, useful if cfg.useClassColors and cfg.useReactionColor are set to false
		
		-- Sizes
		cfg.power_height = 2 -- Set the Height of the Power Bar
		cfg.hp_spacing = 2 -- Spacing between HP and Power Bars
		
		cfg.InforBar_height = 13 -- The Height of the InfoBar
		cfg.InforBar_shift = 4 -- Shifts the InfoBar Up
		cfg.InfoBarAlpha = 0.85 -- The Alpha (opacity)
		
		-- Other
		cfg.GroupUnit_FadeOutAlpha = 0.25 -- Alpha for out of range Frames in Raid/Party
		
		cfg.show_portraits = true -- Show the portraits in the InfoBar Background
	
		-- Show / Hide Frames
	
		cfg.show_PlayerFrame = true -- Player Frame
		cfg.show_TargetFrame = true -- Target Frame
		cfg.show_ToTFrame = true -- Target of Target Frame
		cfg.show_FocusFrame = true -- Focus Frame
		cfg.show_FocusTargetFrame = true -- Focus Target Frame
		cfg.show_PetFrame = true -- Pet Frame Frame
		cfg.show_PetTargetFrame = true -- Pet Target Frame
		cfg.show_PartyFrame = true -- Party Frame
		cfg.show_PartyPetsFrame = true -- Party Pets
		cfg.show_RaidFrame = true -- Raid Frame
		cfg.show_BossFrames = true -- Boss Frames
		cfg.show_MainTanks = true -- Err ye, show Main Tanks, what else?
	
		-- Player Frame

		cfg.player_frame_x = -150 -- Horizontal Position of the Player Frame 
		cfg.player_frame_y = -220 -- Vertical Position of the Player Frame
	
		cfg.target_frame_x_from_player = (cfg.player_frame_x * (-2)) -- Horizontal Position of the Target frame Relative to the Player Frame 
		cfg.target_frame_y_from_player = 0 -- Vertical Position of the Target frame Relative to the Player Frame 
	
		cfg.mainframe_width = 170 -- Set the Width of the Player and Target Frames
		cfg.mainframe_height = 21 -- Set the Height of the Player and Target Frames
	
		-- Other Frames
	
		cfg.secondaryframe_width = 82 -- Set the Width of the ToT, Focus, Pet (...) Frames
		cfg.secondaryframe_height = 16 -- Set the Height of the ToT, Focus, Pet (...) Frames
		
			-- Pet Frame
			
			cfg.pet_x = 0 -- X Position of Pet Frame
			cfg.pet_y = -(cfg.secondaryframe_height+7) -- Y Position of Pet Frame
		
			-- Pet Target
			
			cfg.pett_x = 0 -- X Position of Pet Target Frame
			cfg.pett_y = -(cfg.secondaryframe_height+7) -- Y Position of Pet Target Frame
		
		-- Raid and Party Frames
		
			cfg.hp_inverted = true -- Color the HP as deficit
			cfg.userGradientColor = false -- Color the Party / Raid Frames as a gradual gradient instead of Class Colored
		
			-- Raid 10 / Raid 25
			
			cfg.show_Raid_Solo = false -- Shows the Raid frames when solo ** Debug
			cfg.raid_width = 51 -- Raid Frames Individual Width
			cfg.raid_height = 27 -- Raid Frames Individual Height
			cfg.raid_pos_x = 30 -- Raid Frames Horizontal Position
			cfg.raid_pos_y = -78 -- Raid Frames Vertical Position
			
			-- Party
			
			cfg.party_inRaid_instead = false -- Displays Party Group using the Raid Frames instead of the Individual Party Frames. Will not show unless your raid has more than 4 members.
			cfg.show_Player_inParty = true -- Shows the player unit in the party frame.
			cfg.party_width = 60 -- Party Frames Individual Width
			cfg.party_height = 28 -- Party Frames Individual Height
			cfg.party_pos_x = 0 -- Party Frames Horizontal Position
			cfg.party_pos_y = -320 -- Party Frames Vertical Position
			cfg.party_leader_icon = true -- Show Leader Icon
						
			-- Party Pet
				
			cfg.party_pets_width = cfg.party_width -- Party Pets Individual Width
			cfg.party_pets_height = 16 -- Party Pets Individual Height
			
			-- Main Tank
			
			cfg.mt_width = cfg.raid_width -- Main Tank Width
			cfg.mt_height = 18 -- Main Tank Height
			cfg.mt_pos_x = cfg.raid_pos_x -- Main Tank Horizontal Position Point
			cfg.mt_pos_y = cfg.raid_pos_y + 30 -- Main Tank Vertical Position Point
			
			-- Boss Frames
			
			cfg.BossFrames_width = 120 -- Boss frames Width
			cfg.BossFrames_height = 20 -- Boss frames Height
			cfg.BossFrames_pos_x = -375 -- Boss frames Horizontal Position Point
			cfg.BossFrames_pos_y = -450 -- Boss frames Vertical Position Point
 		
	-- Aura Trackers (BarTimers + Corner Indicators)
	
		-- Bar Timers (Player and Target Frames)
		
		cfg.show_BarTimers = true -- Show the BarTimers
		cfg.BarTimers_height = 15 -- BarTimers Height
		cfg.BarTimers_width = false -- Set a value to define BarTimers Width
		cfg.BarTimers_Gap = 6 -- Gap between Bars
		cfg.BarTimers_Color_by_Debuff = true -- Color bars by debuff type
		cfg.BarTimers_spark = true -- Spark for the BarTimers
		cfg.invert_bar_sorting = false -- Inverts the bar sorting (Lower Duration on bottom - Inverted Pyramid)
		
		-- Corner Indicators (Party/Raid Frames)
		
		cfg.show_CornerIndicators = true -- Show the Aura Corner Indiators on Party/Raid Frames, Specially helpfull for Healing Classes
	
	-- Buffs & Debuffs
		
	cfg.show_player_debuffs = true -- Show Player Frame Debuffs
	cfg.show_target_buffs = true -- Show Target Frame Buffs
	cfg.show_target_debuffs = true -- Show Target Frame Debuffs
	cfg.show_focus_debuffs = true -- Show a small number of debuffs on the focus frame
	cfg.show_ToT_debuffs = true -- Show debuffs on the Target of Target Frame
	
	cfg.num_focus_debuffs = 3 -- Number of debuffs to show on the Focus frame
	cfg.num_ToT_debuffs = 3 -- Number of debuffs to show on the ToT frame
	cfg.focus_debuffs_filter = true -- Filters the Focus Deubuff icons in the Whitelist (True is best for PvP, false probably best for PvE)
	cfg.desat_np_debuffs = true -- Removes the color from non-Player Debuffs
	cfg.target_debuffs_custom_filter = true -- Filters (Blacklists) debuffs in the Whitelist - Useful if you're using BarTimers so debuffs don't get repeated
	cfg.show_pet_buffs = true -- Show Pet Frame Buffs
	cfg.num_Pet_buffs = 3 -- Number of buffs on the Pet Frame
	cfg.pet_custom_filter = true -- Filters (Blacklists) the Pet Frame buffs
	
	cfg.showRaidIconDebuffs = true -- Show Important Debuffs as Icons on the Party / Raid Frames
	
	-- Castbars
	
	cfg.show_castbars = true -- Show CastBars
	cfg.show_spark = true -- Adds a Spark to the castbars
	cfg.cbbdc = {r = 0, g = 0, b = 0, a = 0.85} -- Cast Bars Backdrop Color
	
		-- Player Castbar
		
		cfg.player_castbar_classColor = false -- Color the Castbar using Class Color
		cfg.player_castbar_color = {5/255,107/255,246/255} -- The Player Castbar Color if Class Color is set to false
		cfg.player_castbar_width = 405 -- The Width of the Player Castbar
		cfg.player_castbar_height = 18 -- The Height of the Player Castbar
		cfg.player_castbar_x = 10 -- The Horizontal location of the Player Castbar
		cfg.player_castbar_y = 130 -- The Vertical Location of the Player Castbar
			
		-- Target Castbar
		
		cfg.target_castbar_color = {1,0,0} -- The Target Castbar Color
		cfg.target_castbar_x = 10 -- The Horizontal location of the Target Castbar
		cfg.target_castbar_y = -330 -- The Vertical location of the Target Castbar
		cfg.target_castbar_width = 140 -- The Width of the Target Castbar
		cfg.target_castbar_height = 18 -- The Height of the Target Castbar
		
		-- Focus Castbar
		
		cfg.focus_castbar_color = {0.67,0.37,0.97} -- The Focus Castbar Color
		cfg.focus_castbar_x = 10 -- The Horizontal location of the Focus Castbar
		cfg.focus_castbar_y = -305 -- The Vertical location of the Focus Castbar
		cfg.focus_castbar_width = 120 -- The Width of the Focus Castbar
		cfg.focus_castbar_height = 14 -- The Height of the Focus Castbar
	
		-- Other
	
		cfg.show_mirrorbars = true -- Skin the Mirror Bars
		cfg.use_HealPrediction = true -- Usel Heal Prediction in Party and Raid Frames
		
	-- Extras
	
		-- Death Knight Runes
		
		cfg.show_DK_runes = true -- Show Death Knight Runes
		cfg.DK_runes_height = 6 -- DK Rune frame height
		cfg.DK_runes_width = 18 -- DK Rune frame width
		cfg.rune_spacing = 7 -- Rune Spacing
		cfg.rune_x = false -- Runes X Position (False is to use default position)
		cfg.rune_y = false -- Runes Y Position (False is to use default position)
		cfg.DK_runes_alpha = 0 -- Runes Out of Combat Alpha
		
		-- Warlock Shards
		
		cfg.use_Warlock_Shards_numbers = false -- If set to true will use Number format like combo points instead of bars
		cfg.show_WL_shards = true -- Show Warlock Shards
		cfg.WL_shards_height = 8 -- Warlock Shards frame height
		cfg.WL_shards_width = 18 -- Warlock Shards frame width
		cfg.shards_spacing = 7 -- Rune Spacing
		cfg.shards_x = false -- Shards X Position (False is to use default position)
		cfg.shards_y = false -- Shards Y Position (False is to use default position)
		cfg.shards_depleted_alpha = 0.2 -- Shard Depleted Alpha
		
		-- Paladin Holy Power
		
		cfg.use_Paladin_HP_numbers = false -- If set to true will use Number format like combo points instead of bars
		cfg.php_count_x = false -- Position of the Holy Power Number Horz
		cfg.php_count_y = false -- Position of the Holy Power Number Vert
		cfg.show_PL_HolyPower = true -- Show Warlock Shards
		cfg.PL_hp_height = 8 -- Warlock Shards frame height
		cfg.PL_hp_width = 18 -- Warlock Shards frame width
		cfg.PL_hp_spacing = 7 -- Rune Spacing
		cfg.PL_hp_x = false -- Shards X Position (False is to use default position)
		cfg.PL_hp_y = false -- Shards Y Position (False is to use default position)
		
		-- Rogue
		
		cfg.use_ComboPoints = true -- If you want Combo points, put this as true, ye?
		cfg.comboPoints_posx = false -- Set a value for Horizontal Position
		cfg.comboPoints_posy = false -- Vertical Position
		cfg.RogueDPT = true -- Small Number tracking Deadly Poison Stack next to the Combo Points
		
		-- Druid
		
		cfg.show_eclipsebar = true -- Show the Eclipse Bar
		cfg.eclipse_bar_width = 120 -- Moonkin Eclipse Bar Width
		cfg.eclipse_bar_height = 12 -- Moonkin Eclipse Bar Height
		cfg.eclipse_x = false -- Eclipse Bar X Position (False is to use default position)
		cfg.eclipse_y = false -- Eclipse Bar Y Position (False is to use default position)
		cfg.eclipse_ooc_alpha = 0.15 -- Eclipse Out of Combat Alpha
		cfg.showEclipseDirectionText = false -- Shows Direction Text on the Eclipse Bar
	
	-- Addons
		
		-- oUF_BarFader
		
		cfg.Bar_Fader_Alpha = 0.1 -- (oUF_BarFader) Alpha Value When Out of Combat...
		
		-- oUF_Experience and oUF_Reputation
		
		cfg.expbar_height = 2 -- (oUF_Experience) Experience Bar Height
		cfg.repbar_height = 2 -- (oUF_Reputation) Reputation Bar Height
		
		-- oUF_TotemBar
		
		cfg.totem_x = false -- Horizontal Position (False is to use default position)
		cfg.totem_y = false -- Vertical Position (False is to use default position)
		cfg.totem_width = 40 -- Totem bar Width
		cfg.totem_height = 8 -- Totem bar Height
		cfg.totem_spacing = 7 -- Totem bar spacing
		cfg.show_totem_names = true -- Show the abreviated totem names
		cfg.totem_ooc_alpha = 0 -- Out of Combat Alpha
		
		-- oUF_Swing
		
		cfg.swingColor = {0.6,1,0} -- Swing Bar Color
	
-- ------------------------------------------------------------------------
-- > 1. Bar Timers Whitelist
-- ------------------------------------------------------------------------

	cfg.Whitelist = {
	
	DEATHKNIGHT = {

		-- Buffs
		[GetSpellInfo(48707) or "Anti-Magic Shell"] = true,				-- Anti-Magic Shell
		[GetSpellInfo(51052) or "Anti-Magic Zone"] = true,				-- Anti-Magic Zone
		[GetSpellInfo(49222) or "Bone Shield"] = true,					-- Bone Shield
		[GetSpellInfo(59052) or "Freezing Fog"] = true,					-- Freezing Fog
		[GetSpellInfo(48792) or "Icebound Fortitude"] = true,			-- Icebound Fortitude
		[GetSpellInfo(51124) or "Killing Machine"] = true,				-- Killing Machine
		[GetSpellInfo(49039) or "Lichborne"] = true,					-- Lichborne
		[GetSpellInfo(51271) or "Pillar of Frost"] = true,				-- Pillar of Frost
		[GetSpellInfo(51271) or "Unbreakable Armor"] = true,			-- Unbreakable Armor
		[GetSpellInfo(55233) or "Vampiric Blood"] = true,				-- Vampiric Blood
		
		-- Debuffs
		[GetSpellInfo(55078) or "Blood Plague"] = true,					-- Blood Plague
		[GetSpellInfo(45524) or "Chains of Ice"] = true,				-- Chains of Ice
		[GetSpellInfo(55095) or "Frost Fever"] = true,					-- Frost Fever
		[GetSpellInfo(49203) or "Hungering Cold"] = true,				-- Hungering Cold
		[GetSpellInfo(47476) or "Strangulate"] = true,					-- Strangulate
	},
	
	DRUID = {
	
		-- Buffs
		[GetSpellInfo(22812) or "Barkskin"] = true,						-- Barkskin
		[GetSpellInfo(50334) or "Berserk"] = true,						-- Berserk
		[GetSpellInfo(1850) or "Dash"] = true,							-- Dash
		[GetSpellInfo(5229) or "Enrage"] = true, 						-- Enrage
		[GetSpellInfo(22842) or "Frenzied Regeneration"] = true,		-- Frenzied Regeneration
		[GetSpellInfo(29166) or "Innervate"] = true,					-- Innervate		
		[GetSpellInfo(33763) or "Lifebloom"] = true,					-- Lifebloom
		[GetSpellInfo(16689) or "Nature's Grasp"] = true,				-- Nature's Grasp
		[GetSpellInfo(8936) or "Regrowth"] = true,						-- Regrowth
		[GetSpellInfo(48441) or "Rejuvenation"] = true,					-- Rejuvenation
		[GetSpellInfo(52610) or "Savage Roar"] = true,					-- Savage Roar
		[GetSpellInfo(93400) or "Shooting Stars"] = true,				-- Shooting Stars
		[GetSpellInfo(61336) or "Survival Instincts"] = true,			-- Survival Instincts
		[GetSpellInfo(467) or "Thorns"] = true,							-- Thorns
		
		-- Debuffs
		[GetSpellInfo(5211) or "Bash"] = true,					    	-- Bash
		[GetSpellInfo(33786) or "Cyclone"] = true,						-- Cyclone
		[GetSpellInfo(99) or "Demoralizing Roar"] = true,	    		-- Demoralizing Roar
		[GetSpellInfo(339) or "Entangling Roots"] = true,	    		-- Entangling Roots
		[GetSpellInfo(5570) or "Insect Swarm"] = true,	    			-- Insect Swarm
		[GetSpellInfo(16979) or "Feral Charge - Bear"] = true,			-- Feral Charge - Bear
		[GetSpellInfo(2637) or "Hibernate"] = true,				   	 	-- Hibernate
		[GetSpellInfo(33745) or "Lacerate"] = true,				    	-- Lacerate
		[GetSpellInfo(49802) or "Maim"] = true,				    		-- Maim
		[GetSpellInfo(8921) or "Moonfire"] = true,			    		-- Moonfire
		[GetSpellInfo(1822) or "Rake"] = true,				    		-- Rake
		[GetSpellInfo(1079) or "Rip"] = true,							-- Rip
		[GetSpellInfo(93402) or "Sunfire"] = true,						-- Sunfire
	},
	
	HUNTER = {

		-- Buffs
		[GetSpellInfo(82692) or "Focus Fire"] = true,					-- Focus Fire
		[GetSpellInfo(82926) or "Fire!"] = true,						-- Fire!
		[GetSpellInfo(53224) or "Improved Steady Shot"] = true,			-- Improved Steady Shot
		[GetSpellInfo(56453) or "Lock and Load"] = true,				-- Lock and Load
		[GetSpellInfo(34477) or "Misdirection"] = true,					-- Misdirection
		-- [GetSpellInfo(82925) or "Ready, Set, Aim..."] = true,			-- Ready, Set, Aim...
		[GetSpellInfo(3045) or "Rapid Fire"] = true,					-- Rapid Fire
		[GetSpellInfo(35098) or "Rapid Killing"] = true,				-- Rapid Killing
		[GetSpellInfo(34692) or "The Beast Within"] = true,				-- The Beast Within
		[GetSpellInfo(77769) or "Trap Launcher"] = true,				-- Trap Launcher

		-- Debuffs
		[GetSpellInfo(3674) or "Black Arrow"] = true,					-- Black Arrow
		[GetSpellInfo(35101) or "Concussive Barrage"] = true,			-- Concussive Barrage
		[GetSpellInfo(5116) or "Concussive Shot"] = true,				-- Concussive Shot
		[GetSpellInfo(19185) or "Entrapment"] = true,					-- Entrapment
		[GetSpellInfo(53301) or "Explosive Shot"] = true,				-- Explosive Shot 
		[GetSpellInfo(3355) or "Freezing Trap"] = true,  				-- Freezing Trap
		[GetSpellInfo(51740) or "Immolation Trap"] = true,				-- Immolation Trap 
		[GetSpellInfo(1513) or "Scare Beast"] = true,					-- Scare Beast 
		[GetSpellInfo(1978) or "Serpent Sting"] = true,			    	-- Serpent Sting
		[GetSpellInfo(34490) or "Silencing Shot"] = true,				-- Silencing Shot
		[GetSpellInfo(2974) or "Wing Clip"] = true,				    	-- Wing Clip
		[GetSpellInfo(19386) or "Wyvern Sting"] = true,		    		-- Wyvern Sting
		
	},
	
	MAGE = {

		-- Buffs
		[GetSpellInfo(12042) or "Arcane Power"] = true,					-- Arcane Power
		[GetSpellInfo(11426) or "Ice Barrier"] = true,					-- Ice Barrier
		[GetSpellInfo(45438) or "Ice Block"] = true,					-- Ice Block
		[GetSpellInfo(66) or "Invisibility"] = true,					-- Invisibility
		[GetSpellInfo(543) or "Mage Ward"] = true,			    		-- Mage Ward
		[GetSpellInfo(1463) or "Mana Shield"] = true,			    	-- Mana Shield
		[GetSpellInfo(130) or "Slow Fall"] = true,				    	-- Slow Fall

		-- Debuffs
		[GetSpellInfo(44572) or "Deep Freeze"] = true,	    			-- Deep Freeze
		[GetSpellInfo(122) or "Frost Nova"] = true,			    		-- Frost Nova
		[GetSpellInfo(11255) or "Improved Counterspell"] = true,		-- Improved Counterspell
		[GetSpellInfo(44457) or "Living Bomb"] = true,					-- Living Bomb
		[GetSpellInfo(118) or "Polymorph"] = true,				   	 	-- Polymorph
		[GetSpellInfo(82676) or "Ring of Frost"] = true,				-- Ring of Frost
		[GetSpellInfo(31589) or "Slow"] = true,					   		-- Slow

	},
	
	PALADIN = {

		-- Buffs
		[GetSpellInfo(31850) or "Ardent Defender"] = true,				-- Ardent Defender
		[GetSpellInfo(31884) or "Avenging Wrath"] = true,				-- Avenging Wrath
		[GetSpellInfo(53651) or "Light's Beacon"] = true,				-- Beacon of Light		
		[GetSpellInfo(31842) or "Divine Favor"] = true,					-- Divine Favor
		[GetSpellInfo(54428) or "Divine Plea"] = true,					-- Divine Plea
		[GetSpellInfo(642) or "Divine Shield"] = true,					-- Divine Shield
		[GetSpellInfo(90174) or "Hand of Light"] = true,					-- Hand of Light
		[GetSpellInfo(84963) or "Inquisition"] = true,					-- Inquisition
		[GetSpellInfo(85696) or "Zealotry"] = true,						-- Zealotry
		
		-- Debuffs
		[GetSpellInfo(20066) or "Repentance"] = true,					-- Repentance
		
	},
	
	PRIEST = {

		-- Buffs
		[GetSpellInfo(81208) or "Chakra: Heal"] = true,					-- Chakra: Heal
		[GetSpellInfo(81206) or "Chakra: Prayer of Healing"] = true,	-- Chakra: Prayer of Healing
		[GetSpellInfo(81207) or "Chakra: Renew"] = true,				-- Chakra: Renew
		[GetSpellInfo(81209) or "Chakra: Smite"] = true,				-- Chakra: Smite
		[GetSpellInfo(87118) or "Dark Evangelism"] = true,				-- Dark Evangelism
		[GetSpellInfo(47585) or "Dispersion"] = true,					-- Dispersion
		[GetSpellInfo(81662) or "Evangelism"] = true,					-- Evangelism
		[GetSpellInfo(47788) or "Guardian Spirit"] = true,				-- Guardian Spirit
		[GetSpellInfo(33206) or "Pain Suppression"] = true,				-- Pain Suppression
		[GetSpellInfo(10060) or "Power Infusion"] = true,				-- Power Infusion
		[GetSpellInfo(48066) or "Power Word: Shield"] = true,			-- Power Word: Shield
		[GetSpellInfo(33076) or "Prayer of Mending"] = true,			-- Prayer of Mending
		[GetSpellInfo(139) or "Renew"] = true,					    	-- Renew
		[GetSpellInfo(63735) or "Serendipity"] = true,					-- Serendipity
		[GetSpellInfo(77487) or "Shadow Orb"] = true,					-- Shadow Orbs

		-- Debuffs
		[GetSpellInfo(2944) or "Devouring Plague"] = true,				-- Devouring Plague
		[GetSpellInfo(14914) or "Holy Fire"] = true,					-- Holy Fire	
		[GetSpellInfo(87178) or "Mind Spike"] = true,					-- Mind Spike
		[GetSpellInfo(64044) or "Psychic Horror"] = true,					-- Psychic Horror	
		[GetSpellInfo(589) or "Shadow Word: Pain"] = true,				-- Shadow Word: Pain	
		[GetSpellInfo(9484) or "Shackle Undead"] = true,				-- Shackle Undead	
		[GetSpellInfo(15487) or "Silence"] = true,						-- Silence	
		[GetSpellInfo(34914) or "Vampiric Touch"] = true,				-- Vampiric Touch	

	},
	
	ROGUE = {

		-- Buffs
		[GetSpellInfo(13750) or "Adrenaline Rush"] = true,		    	-- Adrenaline Rush
		[GetSpellInfo(84747) or "Deep Insight"] = true,			    	-- Bandit's Guile
		[GetSpellInfo(13877) or "Blade Flurry"] = true,			    	-- Blade Flurry
		[GetSpellInfo(31230) or "Cheat Death"] = true,			    	-- Cheat Death
		[GetSpellInfo(84617) or "Revealing Strike"] = true,			    -- Revealing Strike
		[GetSpellInfo(51713) or "Shadow Dance"] = true,			    	-- Shadow Dance
		[GetSpellInfo(5171) or "Slice and Dice"] = true,				-- Slice and Dice

		-- Debuffs
		[GetSpellInfo(2094) or "Blind"] = true,					    	-- Blind
		[GetSpellInfo(1833) or "Cheap Shot"] = true,					-- Cheap Shot
		[GetSpellInfo(26679) or "Deadly Throw"] = true,			   	 	-- Deadly Throw
		[GetSpellInfo(51722) or "Dismantle"] = true, 					-- Dismantle
		[GetSpellInfo(8647) or "Expose Armor"] = true,			    	-- Expose Armor
		[GetSpellInfo(703) or "Garrote"] = true,						-- Garrote
		[GetSpellInfo(1776) or "Gouge"] = true,					    	-- Gouge
		[GetSpellInfo(408) or "Kidney Shot"] = true,					-- Kidney Shot
		[GetSpellInfo(1943) or "Rupture"] = true,						-- Rupture
		[GetSpellInfo(6770) or "Sap"] = true,							-- Sap
		[GetSpellInfo(79140) or "Vendetta"] = true,						-- Vendetta

	},
	
	SHAMAN = {

		-- Buffs
		[GetSpellInfo(974) or "Earth Shield"] = true,			    	-- Earth Shield
		[GetSpellInfo(77796) or "Focused Insight"] = true,			    -- Focused Insight
		--[GetSpellInfo(324) or "Lightning Shield"] = true,		    	-- Lightning Shield
		[GetSpellInfo(51530) or "Maelstrom Weapon"] = true,		    	-- Maelstrom Weapon
		[GetSpellInfo(61295) or "Riptide"] = true,						-- Riptide
		[GetSpellInfo(30823) or "Shamanistic Rage"] = true,		    	-- Shamanistic Rage
		[GetSpellInfo(79206) or "Spiritwalker's Grace"] = true,		    -- Spiritwalker's Grace
		[GetSpellInfo(51564) or "Tidal Waves"] = true,			    	-- Tidal Waves
		[GetSpellInfo(73685) or "Unleash Life"] = true,		    		-- Unleash Life

		-- Debuffs
		[GetSpellInfo(76780) or "Bind Elemental"] = true,				-- Bind Elemental
		[GetSpellInfo(8042) or "Earth Shock"] = true,					-- Earth Shock
		[GetSpellInfo(8050) or "Flame Shock"] = true,					-- Flame Shock
		[GetSpellInfo(63685) or "Freeze"] = true,						-- Frozen Power Freeze
		[GetSpellInfo(8056) or "Frost Shock"] = true,					-- Frost Shock
		[GetSpellInfo(51514) or "Hex"] = true,							-- Hex

	},
	
	WARLOCK = {

		-- Buffs
		[GetSpellInfo(54277) or "Backdraft"] = true,					-- Backdraft
		[GetSpellInfo(85114) or "Improved Soul Fire"] = true,			-- Improved Soul Fire
		[GetSpellInfo(59672) or "Metamorphosis"] = true,				-- Metamorphosis
		[GetSpellInfo(91711) or "Nether Ward"] = true,					-- Nether Ward
		[GetSpellInfo(17941) or "Shadow Trance"] = true,				-- Shadow Trance
		[GetSpellInfo(6229) or "Shadow Ward"] = true,					-- Shadow Ward

		-- Debuffs
		[GetSpellInfo(980) or "Bane of Agony"] = true,			  	 	-- Bane of Agony
		[GetSpellInfo(603) or "Bane of Doom"] = true,			  	 	-- Bane of Doom
		[GetSpellInfo(80240) or "Bane of Havoc"] = true,			  	-- Bane of Havoc
		[GetSpellInfo(710) or "Banish"] = true,				  			-- Banish
		[GetSpellInfo(172) or "Corruption"] = true,				  		-- Corruption
		[GetSpellInfo(18223) or "Curse of Exhaustion"] = true,			-- Curse of Exhaustion
		[GetSpellInfo(1714) or "Curse of Tongues"] = true,				-- Curse of Tongues
		[GetSpellInfo(48181) or "Haunt"] = true,						-- Haunt
		[GetSpellInfo(348) or "Immolate"] = true,						-- Immolate
		[GetSpellInfo(74434) or "Soulburn"] = true,						-- Soulburn
		[GetSpellInfo(30108) or "Unstable Affliction"] = true,			-- Unstable Affliction

	},
	
	WARRIOR = {

		-- Buffs
		[GetSpellInfo(18499) or "Berserker Rage"] = true,				-- Berserker Rage
		[GetSpellInfo(46916) or "Bloodsurge"] = true,					-- Bloodsurge
		[GetSpellInfo(85730) or "Deadly Calm"] = true,					-- Deadly Calm
		[GetSpellInfo(12292) or "Death Wish"] = true,					-- Death Wish
		[GetSpellInfo(3411) or "Intervene"] = true,				    	-- Intervene
		[GetSpellInfo(85739) or "Meat Cleaver"] = true,				    -- Meat Cleaver
		[GetSpellInfo(12975) or "Last Stand"] = true,					-- Last Stand
		[GetSpellInfo(1719) or "Recklessness"] = true,			    	-- Recklessness
		[GetSpellInfo(20230) or "Retaliation"] = true,					-- Retaliation
		[GetSpellInfo(86663) or "Rude Interruption"] = true,			-- Rude Interruption
		[GetSpellInfo(2565) or "Shield Block"] = true,			    	-- Shield Block
		[GetSpellInfo(871) or "Shield Wall"] = true,					-- Shield Wall
		[GetSpellInfo(23920) or "Spell Reflection"] = true,	    		-- Spell Reflection
		[GetSpellInfo(52437) or "Sudden Death"] = true,		    		-- Sudden Death
		[GetSpellInfo(12328) or "Sweeping Strikes"] = true,		    	-- Sweeping Strikes
		[GetSpellInfo(50227) or "Sword and Board"] = true,		    	-- Sword and Board
		[GetSpellInfo(60503) or "Taste for Blood"] = true,				-- Taste for Blood
		[GetSpellInfo(87096) or "Thunderstruck"] = true,				-- Thunderstruck

		-- Debuffs
		[GetSpellInfo(1160) or "Demoralizing Shout"] = true,			-- Demoralizing Shout
		[GetSpellInfo(1715) or "Hamstring"] = true,				    	-- Hamstring
		[GetSpellInfo(772) or "Rend"] = true,					    	-- Rend
		[GetSpellInfo(64382) or "Shattering Throw"] = true,		    	-- Shattering Throw
		[GetSpellInfo(58567) or "Sunder Armor"] = true,			    	-- Sunder Armor
		[GetSpellInfo(85388) or "Throwdown"] = true,			    	-- Throwdown

	},
	
	PET = {
		
		-- Hunter
		[GetSpellInfo(6991) or "Feed Pet"] = true,						-- Feed Pet
		[GetSpellInfo(19615) or "Frenzy Effect"] = true,				-- Frenzy
		[GetSpellInfo(136) or "Mend Pet"] = true,						-- Mend Pet
		
		-- Death Knight
		[GetSpellInfo(63560) or "Dark Transformation"] = true,			-- Dark Transformation
		[GetSpellInfo(91342) or "Shadow Infusion"] = true,				-- Shadow Infusion
		
		-- Warlock
	}}
	
-- ------------------------------------------------------------------------
-- > 2. Corner Indicators Whitelists
-- ------------------------------------------------------------------------
	
	-- Indicators Colors
	local Colors = {
		Green = {174/255,255/255,0/255},
		Red = {235/255,15/255,15/255},
		Blue = {0/255,186/255,255/255},
		Purple = {255/255,0/255,125/255},
		Orange = {255/255,162/255,0/255},
		White = {255/255,255/255,255/255},
	}
	
	cfg.IndicatorsSpells = {
	
	DEATHKNIGHT = {
		TL = {},
		TR = {},
		BL = {},
		BR = {},
	},
	
	DRUID = {
		TL = {[GetSpellInfo(33763) or "Lifebloom"] = {color = Colors.Green, stack = 3}},
		TR = {[GetSpellInfo(8936) or "Regrowth"] = {color = Colors.Blue, stack = 1}},
		BL = {[GetSpellInfo(48441) or "Rejuvenation"] = {color = Colors.Purple, stack = 1}},
		BR = {[GetSpellInfo(48438) or "Wild Growth"] = {color = Colors.Orange, stack = 1}},
	},
	
	HUNTER = {
		TL = {[GetSpellInfo(34477) or "Misdirection"] = {color = Colors.Blue, stack = 1}},
		TR = {},
		BL = {},
		BR = {},
	},
	
	MAGE = {
		TL = {[GetSpellInfo(54646) or "Focus Magic"] = {color = Colors.Purple, stack = 1}},
		TR = {[GetSpellInfo(1459) or "Arcane Brilliance"] = {color = Colors.Blue, stack = 1}},
		BL = {},
		BR = {},
	},
	
	PALADIN = {
		TL = {},
		TR = {},
		BL = {[GetSpellInfo(53651) or "Light's Beacon"] = {color = Colors.White, stack = 1}},
		BR = {[GetSpellInfo(25771) or "Forbearance"] = {color = Colors.Red, stack = 1}},
	},
	
	PRIEST = { 
		TL = {[GetSpellInfo(139) or "Renew"] = {color = Colors.Green, stack = 1}},
		TR = {[GetSpellInfo(48066) or "Power Word: Shield"] = {color = Colors.Orange, stack = 1}},
		BL = {[GetSpellInfo(33076) or "Prayer of Mending"] = {color = Colors.Blue, stack = 5}},
		BR = {[GetSpellInfo(6788) or "Weakened Soul"] = {color = Colors.Red, stack = 1}},
	},
	
	ROGUE = {
		TL = {[GetSpellInfo(57934) or "Tricks of the Trade"] = {color = Colors.Orange, stack = 1}},
		TR = {},
		BL = {},
		BR = {},
	},
	
	SHAMAN = {
		TL = {[GetSpellInfo(61295) or "Riptide"] = {color = Colors.Blue, stack = 1}},
		TR = {[GetSpellInfo(3345) or "Earthliving"] = {color = Colors.Green, stack = 1}},
		BL = {[GetSpellInfo(974) or "Earth Shield"] = {color = Colors.Orange, stack = 6}},
		BR = {},
	},
	
	WARLOCK = {
		TL = {[GetSpellInfo(47883) or "Soulstone Resurrection"] = {color = Colors.Purple, stack = 1}},
		TR = {[GetSpellInfo(85767) or "Dark Intent"] = {color = Colors.Green, stack = 3}},
		BL = {},
		BR = {},
	},
	
	WARRIOR = {
		TL = {[GetSpellInfo(50720) or "Vigilance"] = {color = Colors.Blue, stack = 1}},
		TR = {},
		BL = {},
		BR = {},
	},
	
	}
	
-- ------------------------------------------------------------------------
-- > 3. Raid and other Important Debuffs Whitelist for Icon Display
-- ------------------------------------------------------------------------

	cfg.IconDebuffs = {
	
		-- PvE --
		
		-- CATACLYSM--
		
			-- Blackrock Caverns
			76188, -- Twilight Corruption: Ascendant Lord Obsidius
			
			-- Grim Batol
			74846, --Bleeding Wound: General Umbriss
			
			--...
		
		
		-- PvP --
		
		8122, 	-- Psychic Scream (Priest)
		15487, 	-- Silence (Priest)
		20066, 	-- Repentence (Paladin)
		6770, 	-- Sap (Rogue)
		2637, 	-- Hibernate (Druid)
		5782, 	-- Fear (Warlock)
		51514, 	-- Hex (Shaman)
		118, 	-- Polymorph (Mage)
		61305,	-- Polymorph Black Cat (Mage)
		28272,	-- Polymorph Pig (Mage)
		61721,	-- Polymorph Rabbit (Mage)
		61780,	-- Polymorph Turkey (Mage)
		28271,	-- Polymorph Turtle (Mage)
		3355, 	-- Freezing Trap (Hunter)
		19386, 	-- Wyvern Sting (Hunter)
		47476, 	-- Strangulate (Death Knight)
	
	}
	
	
	ns.cfg = cfg -- Don't change this !!