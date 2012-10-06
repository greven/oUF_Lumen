	
	local addon, ns = ...
	local cfg = CreateFrame("Frame")

-- ------------------------------------------------------------------------
-- > Settings
-- ------------------------------------------------------------------------

	-- General
	
	cfg.fontsize = 11 -- The Global Font Size
	cfg.scale = 1 -- The Frames Scale
	
	cfg.useShadows = true -- Creates frame drop shadows
	cfg.shadowAlpha = 0.7
	
	cfg.bdc = {r = 0, g = 0, b = 0, a = 1} -- Backdrop Color (Some frames might not be affected)

	cfg.MirrorBars = true -- Skin the Mirror Bars
	cfg.BGtimer = true -- Skin the BGTimer
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
		cfg.player_castbar_y = 133 -- The Vertical Location of the Player Castbar
			
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
		
		-- Warlock Resources

		-- Monk

		cfg.use_Monk_Chi_numbers = true -- If set to true will use Number format like combo points instead of bars
		cfg.chi_count_x = false -- Position of the Chi Number Horz (False is to use default position)
		cfg.chi_count_y = false -- Position of the Chi Number Vert (False is to use default position)
		cfg.show_Monk_chi = true -- Show Monk Harmony bar
		cfg.Monk_chi_height = 8 -- Monk Chi frame height
		cfg.Monk_chi_width = 18 -- Monk Chi frame width
		cfg.Monk_chi_spacing = 7 -- Chi Spacing
		cfg.Monk_chi_x = false -- Chi X Position (False is to use default position)
		cfg.Monk_chi_y = false -- Chi Y Position (False is to use default position)
		
		-- Paladin Holy Power
		
		cfg.use_Paladin_HP_numbers = true -- If set to true will use Number format like combo points instead of bars
		cfg.php_count_x = false -- Position of the Holy Power Number Horz (False is to use default position)
		cfg.php_count_y = false -- Position of the Holy Power Number Vert (False is to use default position)
		cfg.show_PL_HolyPower = true -- Show Warlock Shards
		cfg.PL_hp_height = 8 -- Paladin Shards frame height
		cfg.PL_hp_width = 18 -- Paladin Shards frame width
		cfg.PL_hp_spacing = 7 -- Rune Spacing
		cfg.PL_hp_x = false -- Holy Bars X Position (False is to use default position)
		cfg.PL_hp_y = false -- Holy Bars Y Position (False is to use default position)
		
		-- Rogue
		
		cfg.use_ComboPoints = true -- If you want Combo points, put this as true, ye?
		cfg.comboPoints_posx = false -- Set a value for Horizontal Position (False is to use default position)
		cfg.comboPoints_posy = false -- Vertical Position (False is to use default position)
		-- cfg.RogueDPT = true -- Small Number tracking Deadly Poison Stack next to the Combo Points
		
		-- Druid
		
		cfg.show_eclipsebar = true -- Show the Eclipse Bar
		cfg.eclipse_bar_width = 120 -- Moonkin Eclipse Bar Width
		cfg.eclipse_bar_height = 12 -- Moonkin Eclipse Bar Height
		cfg.eclipse_x = false -- Eclipse Bar X Position (False is to use default position)
		cfg.eclipse_y = false -- Eclipse Bar Y Position (False is to use default position)
		cfg.eclipse_ooc_alpha = 0.15 -- Eclipse Out of Combat Alpha
		cfg.showEclipseDirectionText = false -- Shows Direction Text on the Eclipse Bar

		-- Priest
		cfg.show_shadowOrbs_count = true -- If set to true will use Number shadow orbs
		cfg.so_count_x = false -- Position of the Shadow Orbs Number Horz (False is to use default position)
		cfg.so_count_y = false -- Position of the Shadow Orbs Number Vert (False is to use default position)

	
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
	

	ns.cfg = cfg -- Don't change this !!