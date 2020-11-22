local _, ns = ...

local debuffs = {}
ns.debuffs = debuffs

-- ------------------------------------------------------------------------
-- > DEBUFFS BLACKLIST
-- ------------------------------------------------------------------------

debuffs.list = {
    player = {
        [45181 or "Cheated Death"] = true,
        [57723 or "Exhaustion"] = true,
        [264689 or "Fatigued"] = true,
        [95809 or "Insanity"] = true,
        [57724 or "Sated"] = true,
        [80354 or "Temporal Displacement"] = true
    },
    party = {
        [57723 or "Exhaustion"] = true,
        [264689 or "Fatigued"] = true,
        [95809 or "Insanity"] = true,
        [57724 or "Sated"] = true,
        [80354 or "Temporal Displacement"] = true
    },
    nameplate = {}
}
