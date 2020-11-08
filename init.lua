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

-- Hearthstone spells
G.hearthstones = {
  8690, -- Hearthstone
  39937, -- There's No Place Like Home
  94719, -- The Innkeeper's Daughter
  136508, -- Dark Portal
  75136, -- Ethereal Portal
  166747, -- Brewfest Reveler's Hearthstone
  308742, -- Eternal Traveler's Hearthstone
  286331, -- Fire Eater's Hearthstone
  278244, -- Greatfather Winter's Hearthstone
  278559, -- Headless Horseman's Hearthstone
  298068, -- Holographic Digitalization Hearthstone
  285362, -- Lunar Elder's Hearthstone
  340200, -- Necrolord Hearthstone
  326064, -- Ardenweald Hearthstone
  286031, -- Noble Gardener's Hearthstone
  285424, -- Peddlefeet's Lovely Hearthstone
  342122 -- Venthyr Sinstone
}
