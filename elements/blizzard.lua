local _, ns = ...

local cfg = ns.cfg

-- ------------------------------------------------------------------------
-- > Blizzard UI Related
-- ------------------------------------------------------------------------

-- Hide Blizzard Compact Raid Frames
if cfg.hideBlizzardRaidFrames then
  CompactRaidFrameManager:UnregisterAllEvents()
  CompactRaidFrameManager:Hide()
  CompactRaidFrameContainer:UnregisterAllEvents()
  CompactRaidFrameContainer:Hide()
  CompactRaidFrameContainer:Hide()
end
