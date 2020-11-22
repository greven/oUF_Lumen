local _, ns = ...

local core = ns.core -- Core methods
local api = CreateFrame("Frame") -- API like methods
local lum = CreateFrame("Frame", "oUF_lumen") -- Main Frame
local oUF = ns.oUF or oUF
local G = {} -- Globals

ns.api = api
ns.lum = lum
ns.oUF = oUF
ns.G = G

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

-- UI Scale (credits: NDui)
G.ScreenWidth, G.ScreenHeight = GetPhysicalScreenSize()
local function GetBestScale()
    local scale = max(.4, min(1.15, 768 / G.ScreenHeight))
    return core:Round(scale, 2)
end

local pixel = 1
local scale = GetBestScale()
local ratio = 768 / G.ScreenHeight
G.mult = (pixel / scale) - ((pixel - ratio) / scale)
