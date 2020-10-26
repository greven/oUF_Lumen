### Version 9.2.0:

- Refactoring
- Update Rogue filters
- Refactor AuraBar Filters and settings
- Add fonts and media to defaults
- Update player visibility function
- Update Target Quest Icon

### Version 9.1.1:

- Update frame visibility options

### Version 9.1.0:

- Add frame visibility options
- Move default Pet position
- Add visibility conditions to pet frame

### Version 9.0.2:

- New version of oUF_MovableFrames
- Add scaling to frames

### Version 9.0.1:

- First pass for Shadowlands.

### Version 8.0.12:

- Add paragon to experience tooltip.
- Update buff/debuff filters.

### Version 8.0.11:

- First attempt at fixing bugs for 8.2.

### Version 8.0.10:

- Small bug fixes and code cleanup.
- Update some filters (Bar Timers).
- Add player castbar position to config file.

### Version 8.0.9:

- Add Class Power counter (Combo Points, etc.) to nameplates.
- Remove HP % from nameplates.
- Small fixes.

### Version 8.0.8:

- [config] Enable player frame always visible by default.

### Version 8.0.7:

- [feature] Add player frame visibility options.

### Version 8.0.6:

- [bug] Fix PostUpdateIcon.

### Version 8.0.5:

- Bug fixes.

### Version 8.0.3:

- Move some dependencies to the packager.

### Version 8.0.2:

- Add options to hide player and target auras.

### Version 8.0.1:

- Option to hide name and level from player and target frame.

### Version 8.0.0:

- First release for the Battle for Azeroth Pre-Patch.
- Updated oUF and embedded addons.
- Fixes for API changes.

### Version 7.3.2:

- Bug fixes and small improvements

### Version 7.3.2:

- Improve Nameplates
- Add Player debuffs to the side of the frame (supports filtering)
- General Improvements
- Change In Combat Icon
- Bug fixes on party spawn

### Version 7.3.1:

- Bug fixes and improvements

### Version 7.3.0:

- First fixes for 7.03
- Style the nameplates

### Version 7.05:

- Enable absorbs on the healing prediction module.
- Add debuffs to Boss frames.
- Updates to reputation bar.
- Small tweaks.

### Version 7.04:

- Add out of combat player frame fading
- Add Shaman filters
- Add Artifact Power bar

### Version 7.03:

- Update auras
- Added Experience, Reputation and Honor tracking. Small tweaks
- First iteration of Party frames
- Implement proper Boss frames
- Lot of tweaks and changes...

### Version 7.02-beta:

- Added BarTimers for buffs / debuffs
- Added Quest Icon
- Added Heal Prediction
- Added buffs / debuffs
- Lot more changes...

### Version 7.01-beta:

- First release for Legion.
- Complete re-write of all the code.
- oUF is now embedded with the latest Push Requests.
- All supported oUF addons are now embedded.
- Major frames almost future complete.
- Some frames still missing like Party, Raid, Boss, Arena...

### Version 3.02:

- Updated some Filters.
- Preparing Re-write for Legion.

### Version 3.01:

- Some small bug fixes.
- Updated some Rogue and Monk Filters.

### Version 3.0:

- First update for WoD.
- Several bug fixes.
- Updated Rogue Filters.

### Version 2.0:

- Added Monk Chi widget.
- Updated Paladin Holy Power widget.
- Removed deprecated Warlock Soul Shards widget and tag.
- Added and cleaned several options in the config file.
- Added a new addon WarlockPower.lua in order to prepare the new Warlock Resources widgets.

### Version 2.0beta:

- First release for patch 5.0
- Fixed most of the common functions
- Still missing class specific power widgets (Holy Power...)
- Not tested at Party or Raid level

### Version 1.85:

- Added Quest and Phase Icon (Cataclysm).
- Added support for oUF_DebuffHightlight
- Other minor tweaks I don't actually remember... Opps.

### Version 1.84:

- Fixed the casting check for un-interruptable spells. It's working now as intended.

### Version 1.83:

- Minor fixes.

### Version 1.82:

- Boss Frames added (not tested, not even position...)
- Added support for oUF_AuraWatch to add Important Icon debuffs on the Party/Raid frames. It's implemented to be the equivalent of GridRaidDebuffs.
- Fixed a bug where Reputation bar would display improperly without the oUF_Reputation addon.
- Fixed a bug where party pets wouldn't display properly. Now they are displaying but might not be anchoring right to the respective owners. Will be fixed on Cataclysm (right now is not a priority).

### Version 1.81:

- Fixed a 'bug' with the position of the power bar regarding the bottom of the frame. 1 Pixel adjustment.
- Added Main Tank Target Frames.
- Added options to move Combo Points.
- Added Drop shadows to the frames. It can be turned off in the config file or alpha adjusted.

### Version 1.8:

- Adjusted alpha of a player name in Raid/Party after he goes offline and comes back.
- Pimped up the Eclipse Bar.
- Added a Red Glow for Target and Focus Castbars when spell is not interruptable.
- Added optional number visualization for Warlock Soul Shards.
- Added Main Tank Frames. ### Version 1.80 had to have something 'big'. Yay!
- Reposition the portrait 1 pixel up, it was not anchoring well... it least on CC beta.

### Version 1.79:

- New texture. To get keep old one, don't overwrite the media folder or download lumUI to get the old texture in the lumMedia/Textures folder.
- Added support for oUF_Reputation. Added a Tooltip to the Reputation bar and coloring by reputation standing.
- Added dynamic anchoring updates for the elements shifted by the reputation bar and experience bar.
- Tweaked the default sizes of the Paladin Holy Power Shards, Warlock Shards and DeathKnight Runes.

### Version 1.78:

- Fixed the Bug where combo points wouldn't show for vehicles.

### Version 1.77:

- Added option to make Party/Raid Frames colored by Gradient (Green > Red).
- Added option to configure oUF_Swing "castbar" color.

### Version 1.76:

- Fixed a bug where duration on buffs / debuffs would blink when time was zero or hidden (for good this time).

### Version 1.75:

- Added option to change Backdrop color of Frames and also Castbar (both in the cfg.lua file).
- Added option to disable Druid Moonkin Eclipse bar.
- Minor code clean up.

### Version 1.74:

- Added optional Class Color to Castbar, can be toggled in the config file.
- Changed Eclipse bar text to indicate the direction of the eclipse bar (> or <).
- Fixed a bug where buffs with no time would show a flashing 0 when casting other spells.
- Cleaned some code to make it more efficient.

### Version 1.73:

- Changed name string length on several frame.
- Shaman TotemBar fades when out of combat.
- Changed Paladin Holy Power color to Pink /barbi_style
- Changed font to a free font. Expressway Free.
- Adjust several fontstring sizes consequence of the new fonttype.

### Version 1.72:

- When in combat, target if (NPC) instead of displaying cbt in the Infobar like the player frame, will display the percentage of threat and color it accordingly.
- Changed the Alpha of the BarTimers slightly.
- Switched colors on Infobar of PvP with AFK/DND. PvP is green now.
- Changed Time formatting on BarTimers and Auras.
- Added abbreviated names to the Totem Bar. Can be turned off in the cfg file.
- Added new Paladin Holy Power 'shard' style. Alternate number system a la Combo Points can be set alternatively in the configuration file.

### Version 1.71:

- Changed Focus Power color to something more yellowish greenish. Fits hunters better.
- Minor code clean up.

### Version 1.70:

- Changed LFD Role string from the default Damager to DPS. What the hell was Blizzard thinking? Damager? Really?
- Changed Focus Power Type color slightly.
- Changed Focus Debuff tracking true by default and changed the location of the debuff icon.
- Added a PvP Tag to the InfoBar. It will only Display if Player toggles PvP manually or attacks a PvP Target. People in PvP servers shouldn't see the tag (unless they toggle PvP manually too). It will also display a timer for the remaining time until flagged non-PvP.
- Added option to invert the filling of of the party/raid frames. By default is set to inverted.
- Fixed the position options to move the Eclipse Bar,
- Changed group sorting inside a Party by Class.
- Cleaned some code in the Combo Points Tag.
- Cleaned some code in the Holy Power Tag.
- Added Arcane Brilliance to Mage Raid Corner Indicator.
- Added Dark Intent to the Warlock Raid Corner Indicator (for CC).
- Added Debuffs to the Target of Target Frame. Configuration has also been added (like number of debuffs).
- Added Focus Fire to the Hunter Whitelist.
- Added Frenzy Effect to the Hunter Pet Whitelist.
- Added Heal Prediction to Party and Raid Frames.
- Added a glow border around the Druid Moonkin Eclipse bar depending on the Eclipse state.
- Added a red glow border around Target Castbar if spell can't be interrupted and player can attack target.

### Version 1.69:

- Fixed the Druid Mana Display (when in Cat or Druid). It hides now when Mana is at maximum and it displays in percentage (so the string is so lenghty).
- Added some more Spells to the Whitelist.
- Added options in the config file to disable any frame (from Player to Raid frames).
- Fixed a bug with the display of the Party Frames.
- Added options to move the Totem Bar.

### Version 1.68:

- Fixed a small typo in the Totembar code that prevent it from working. Reminder for myself, don't write stuff at 3 AM again.

### Version 1.67:

- Added options in the config file to position Pet and Pet Target Frame.
- Fixed a bug on the display of oUF_TotemBars.

### Version 1.66:

- Leader Icon for the Raid frame.
- Hide Blizzard Compact Raid Frames.
- Added Tooltip to the Experience bar. http://i53.tinypic.com/xfnqmv.jpg
- Added an Override to the Warlock Shards to make the Alpha lower instead of hiding the element when a Shard is depleted.
- Added Alpha Fading for Eclipse Bar when Out of Combat.

### Version 1.65:

- Some spells added to the BarTimers Whitelist.
- Added options to move the Warlock Shards, Moonkin EclipseBar and Death Knight Runes.
- Party pets now spawning correctly. There is an option to turn them off.
- Changed the anchoring and position of the Raid frames.
- The Eclipsebar actually works now.

### Version 1.64:

- Added Eclipse Bar for Moonkins (due to oUF Bug the bar doesn't update well tho... for now).
- Scale is back and working.

### Version 1.63:

- Changed Frame Strata of several frames back to Background.
- Added support for oUF_Experience.
- Added support for oUF_TotemBar.
- Removed support for Castbar Safezone.
- Removed Sacred Shield from the Whitelists.
- Removed support for oUF_PowerSpark as it's unnecessary now.

### Version 1.62:

- Fixed Pet not displaying Buffs in the Whitelist Buffs.
- Corrected Target and Focus Castbar Height and Width Config.
- Updated Class Spells for Bar Timers for current Patch 4.01.
- Added Warlock Shards.

### Version 1.61:

- Added Death Knight Runes. Change the aspect from previous builds.
- Added Paladin Holy Power as Text, just like combo points, colored by count number.
- Removed scale from frames. It wasn't working well, use in game scale if you want to scale the layout.
- Fixed LFD Roles.
- Added Group Leader Icon to Party frames.
- Fixed and removed a parasite texture on the Mirror Bars.
- Fixed the display of Corner Indicators in Party / Raid.
- Updated the Class Dispel list for the current Patch.
- Added Ready Check (oUF inbuilt).

### Version 1.6:

- Toc Bump
- Rewrite of the Frames Spawning code.
- Rewriten to work with 4.01 and oUF ### Version 5 (1.5).

### Version 1.55:

- Fixed a bug with the Spark of the BarTimers for Infinite Auras.
- Fixed Localization bug with the new Deadly Poison Tracker.

### Version 1.54:

- Added a Deadly Poison Tracker next to the ComboPoints number for Assassination Rogues. Can be turned off in the config file (cfg.lua).

### Version 1.53:

- Fixed a bug with the scale of the BarTimers.
- Removed the Text Font, using only 1 font now to reduce size and to make it more consistent.
- Changed the Texture (if you want the old texture, get it from the archive or from Shared Media is the Aluminium one).

### Version 1.52:

- BarTimers Bars sorted from top to Bottom by default (added option to invert the sorting).
- Added options to the config file to disable any Buffs/Debuffs on the Party and Target Frames.

### Version 1.51:

- Added an option to display only party in Raid and hide the party interface.

### Version 1.5:

- Added Party/Raid Frame Corner Indicators. Just like Grid CornerIcons. You can configure the buffs/debuffs in the config file.

### Version 1.4:

- Added Party Pets.
- Separated Raid Frames from Party Frames. You still can use Party Frames within the Raid Frames, just turn off Party Frames in the config. The new Party Frames are centralized but can be moved.
- Fixed a bug with BarTimers not disappearing with the interface hidden (alt+z).
- Fixed a bug with BarTimers hidding lag when deselecting a target.
- Fixed a bug with BarTimers proper scaling.

### Version 1.36:

- Added Combat and Rested Status Text to the Infobar.
- Renamed some frames.

### Version 1.35:

- Fixed a bug where Pets wouldn't fade with oUF_BarFader.
- Added Optional (turned off by default) Debuffs to the Focus frame. Go the config file to activate it (set cfg.show_focus_debuffs from false to true).

### Version 1.34:

- Added oUF_BarFader Support.
- Added GetSpellInfo's to the Whitelist Spells so it can work on non-English Clients (thanks to Trollinou for the great help).

### Version 1.33:

- Added raid frames border for unit selected.

### Version 1.32:

- Added frame highlight when mouse hovering.
- Added the dispell icon module. When in a party/raid if you can dispell (magic, curse, poison, disease) a small coloured (by the debuff type) square will appear on your party/raid frames on the bottom right corner.
- Fixed a small colour issue with the BarTimers spark.

### Version 1.31:

- Made Portraits Clickable for Player and Target Unit Frames.
- Added a Spark to the Castbasr (player, target and focus) and for the BarTimers (both can be turned off in the config file).
- Small bug fixes.
- Change the location of the Raid Icons in the Player and Target frames.

### Version 1.3:

- Added LFG Party Roles as text when in the Party.
- Added options in the config file to Toggle Party/Raid/Solo On/Off.
- When in a Party Raid, when a Player Dies, is in Ghost or Disconnects, it will appear as a Dark Gray Box and the Power Bar Color changes accordingly: Dead > Red, Ghost > White, DC > Bright Green.

### Version 1.21:

- Fixed the Target Custom Debuff Filter (Buffs in the BarTimers are not repeated in the Debuff Auras)
- Added Buff Auras for the Pet and a Whitelist entry for it so you can filter the Buffs. Useful to check Mend Pet or any other Important Pet Buff.

### Version 1.2:

- Added some space between between the InfoBar and the Main Frames (can be changed in the config file).
- Streamlined the config file so options are easier to see by section.
- Display aggro border in raid / party frames.
- Fixed status bugs in raid / party.
- Changed the location of Raid Target Icons in Player and Target frames.
- Human Controled units debuffs are no longer discolored if debuff is not from player.
- Increased the size of the debuffs on the player frame.
- Added Range Alpha for raid / party frames.
- More spells added to the Whitelist.

### Version 1.13:

- More spells added to the Whitelist.
- Added entries to the config file to move the Target and Focus Castbars.

### Version 1.12:

- Fixed a bug with the Death Knight Buff Whitelist.

### Version 1.11:

- Fixed a bug where secondary frames would spawn inside the InfoBar when the height was changed.
- Added support for oUF_Swing, oUF_SpellRange, oUF_CombatFeedback and oUF_ReadyCheck.
- The Class Spells Whitelist is using Class arrays to avoid spell name conflicts.
- A lot more Spells added to the Whitelist.

### Version 1.1:

- Added a configuration file (cfg.lua) with all the layout options of oUF_lumen.
- Added Buff/Debuff Bar Timers like ClassTimer (more spells will be added to the White list).
- Fixed some bugs with the Raid Frames (still WIP).
- Added Party Frames display trough the Raid Frames (still WIP).

### Version 1.03:

- Added Raid Frames a la Grid style (still WIP).
- Removed the 3D Portraits on the Player and Frame backgrounds.
- Added an Infobar at the top of player and target frame displaying level, unit classification and status.
- Added a 3D Portrait to the Infobar background.
- Added Raid Icons for Player, Target, Target of Target, Focus and Focus Target Frames.
- Added support for oUF_PowerSpark and oUF_Smooth Update.

### Version 1.02:

- Added a Runebar for Death Knights.
- Combo Points Working with Coloring.
- 3D Portraits on the Player and Target frames background (can be disabled).

### Version 1.01:

- Fixed a bug with Vehicles Swaping.
- Added Frequent Updates to Player PowerBar.

### Version 1.0:

- Easier options to customize the layout.
- Major code clean up.
- Frames more compact.
- Re-written for ouF 1.4.
