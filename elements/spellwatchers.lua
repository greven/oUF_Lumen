local _, ns = ...

local lum, core, api, cfg, m, G, oUF = ns.lum, ns.core, ns.api, ns.cfg, ns.m, ns.G, ns.oUF
local watchers = ns.watchers

-- ------------------------------------------------------------------------
-- > SpellWatchers: Watch class spells
-- ------------------------------------------------------------------------

local function Path(self, ...)
  --[[ Override: SpellWatchers.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
  return (self.SpellWatchers.Override or Update)(self, ...)
end

local function Update(self, event)
  print("SpellWatchers - Update")
end

local function Enable(self)
  print("Enabled")

  self:RegisterEvent("SPELL_UPDATE_COOLDOWN", Path, true)
end

local function Disable(self)
end

oUF:AddElement("SpellWatchers", Update, Enable, Disable)
