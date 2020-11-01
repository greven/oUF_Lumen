local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local watchers = ns.watchers

-- ------------------------------------------------------------------------
-- > SpellWatchers: Watch spells (configurable) under the Player Plate
-- ------------------------------------------------------------------------

local function Path(self, ...)
end

local function Enable(self)
  print("Enabled")
end

local function Disable(self)
end

-- oUF:AddElement("SpellWatchers", Path, Enable, Disable)
