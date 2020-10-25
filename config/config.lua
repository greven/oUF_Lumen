local _, ns = ...

local cfg, filters, oUF = ns.cfg, ns.filters, ns.oUF

-- ------------------------------------------------------------------------
-- > Your configuration here (will override the defaults.lua settings)
-- ------------------------------------------------------------------------

-- Important: Override each property individually or copy all the defaults

-- Examples
-- cfg.fontsize = 14 -- The Global Font Size
-- cfg.scale = 1.1 -- The elements Scale

-- Compact UI
-- cfg.frames.main.margin = 10
-- cfg.units.player.pos = {a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -213, y = -320}
-- cfg.units.player.castbar.width = 418
-- cfg.units.player.castbar.pos = {
--   a1 = "TOPLEFT",
--   a2 = "BOTTOMLEFT",
--   af = "oUF_LumenPlayer",
--   x = cfg.frames.main.height + 2,
--   y = -101
-- }
-- cfg.units.target.pos = {
--   a1 = "BOTTOMLEFT",
--   a2 = "BOTTOMRIGHT",
--   af = "oUF_LumenPlayer",
--   x = cfg.frames.main.margin,
--   y = 0
-- }
-- cfg.units.focus.pos = {
--   a1 = "BOTTOMLEFT",
--   a2 = "TOPLEFT",
--   af = "oUF_LumenPlayer",
--   x = 0,
--   y = cfg.frames.secondary.margin
-- }
-- cfg.units.pet.width = cfg.frames.secondary.width
-- cfg.units.pet.pos = {a1 = "BOTTOMLEFT", a2 = "TOPLEFT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin},

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

-- ------------------------------------------------------------------------
