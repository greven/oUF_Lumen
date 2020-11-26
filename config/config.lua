local _, ns = ...

local cfg, m, filters, watchers = ns.cfg, ns.m, ns.filters, ns.watchers

-- ------------------------------------------------------------------------
-- > Your configuration here (will override the defaults.lua settings)
-- ------------------------------------------------------------------------

-- Important: Override each property individually or copy all the defaults

-- Examples
-- cfg.fontsize = 14 -- The Global Font Size
-- cfg.scale = 1.1 -- The elements Scale

-- Compact UI
-- cfg.frames.main.margin = 10
-- cfg.units.player.pos = {a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -213, y = -342}
-- cfg.units.player.power.show = true
-- cfg.units.player.castbar.width = 418
-- cfg.units.player.castbar.pos = {
--   a1 = "TOPLEFT",
--   a2 = "BOTTOMLEFT",
--   af = "oUF_LumenPlayer",
--   x = cfg.frames.main.height + 2,
--   y = -80
-- }
-- cfg.units.target.pos = {
--   a1 = "BOTTOMLEFT",
--   a2 = "BOTTOMRIGHT",
--   af = "oUF_LumenPlayer",
--   x = cfg.frames.main.margin,
--   y = 0
-- }
-- cfg.units.playerplate.show = false

-- Show BarTimers with the normal theme
-- cfg.elements.barTimers.theme = "normal"

-- Disable Name Plates
-- cfg.units.nameplate.show = false

-- AuraBars Filters
-- If you want to add spells not on the AuraBars filters, copy the relevant class filters table and add or remove what you want. Example for Warrior

-- filters.WARRIOR = {
--   buffs = {
--     [184362 or "Enraged"] = true,
--     [184364 or "Enraged Regeneration"] = true,
--     [260708 or "Sweeping Strikes"] = true
--   },
--   debuffs = {}
-- }

-- SpellWatchers

-- watchers.ROGUE = {
--     [259] = { -- Assassination
--         [1] = {spellID = 8676, auraID = 121153, glow = "button"}, -- Ambush / Blindside
--         [2] = {spellID = 79140}, -- Vendetta
--         [3] = {spellID = 5938}, -- Shiv
--         [4] = {spellID = 2094}, -- Blind
--         [5] = {spellID = 31224} -- Cloak of Shadows
--     },
--     [260] = { -- Outlaw
--         [1] = {spellID = 185763, auraID = 195627, glow = "button"}, -- Pistol Shot / Opportunity
--         [2] = {spellID = 315341}, -- Between the Eyes
--         [3] = {spellID = 315508}, -- Roll the Bones
--         [4] = {spellID = 13877}, -- Blade Flurry
--         [5] = {spellID = 13750} -- Adrenaline Rush
--     },
--     [261] = { -- Subtlety
--         [1] = {spellID = 212283}, -- Symbols of Death
--         [2] = {spellID = 185313, glow = "pixel"}, -- Shadow Dance
--         [3] = {spellID = 121471}, -- Shadow Blades
--         [4] = {spellID = 280719}, -- Secret Technique
--         [5] = {spellID = 31224} -- Cloak of Shadows
--     }
-- }

-- ------------------------------------------------------------------------
