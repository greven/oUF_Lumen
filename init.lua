local _, ns = ...

local oUF = ns.oUF or oUF
local lum = CreateFrame("Frame", "oUF_lumen") -- Main Frame
local core = CreateFrame("Frame") -- Core methods
local api = CreateFrame("Frame") -- API like methods
local G = {} -- Globals

ns.lum = lum
ns.oUF = oUF
ns.core = core
ns.api = api
ns.G = G

-- -----------------------------------
-- > PLAYER SPECIFIC
-- -----------------------------------

G.playerName = UnitName("player")
G.playerLevel = UnitLevel("player")
G.playerClass = select(2, UnitClass("player"))
G.playerColor = RAID_CLASS_COLORS[G.playerClass]
