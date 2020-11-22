local _, ns = ...

local oUF = ns.oUF or oUF

-- -----------------------------------
-- > COLORS
-- -----------------------------------

oUF.colors.power = {
    ["MANA"] = {1 / 255, 125 / 255, 235 / 255},
    ["RAGE"] = {255 / 255, 26 / 255, 48 / 255},
    ["FOCUS"] = {255 / 255, 128 / 255, 64 / 255},
    ["ENERGY"] = {250 / 255, 220 / 255, 0 / 255},
    ["COMBO_POINTS"] = {255 / 255, 26 / 255, 48 / 255},
    ["RUNES"] = {0 / 255, 200 / 255, 255 / 255},
    ["RUNIC_POWER"] = {134 / 255, 239 / 255, 254 / 255},
    ["SOUL_SHARDS"] = {162 / 255, 92 / 255, 255 / 255},
    ["LUNAR_POWER"] = {144 / 255, 112 / 255, 254 / 255},
    ["HOLY_POWER"] = {255 / 255, 255 / 255, 125 / 255},
    ["MAELSTROM"] = {0 / 255, 200 / 255, 255 / 255},
    ["CHI"] = {0, 204 / 255, 153 / 255},
    ["INSANITY"] = {137 / 255, 76 / 255, 219 / 255},
    ["ARCANE_CHARGES"] = {125 / 255, 75 / 255, 250 / 255},
    ["FURY"] = {255 / 255, 50 / 255, 50 / 255},
    ["PAIN"] = {255 / 255, 156 / 255, 0 / 255},
    ["AMMOSLOT"] = {1, 0.60, 0},
    ["FUEL"] = {0, 0.55, 0.5}
}

-- We need to override power color's index based too
oUF.colors.power[0] = oUF.colors.power["MANA"]
oUF.colors.power[1] = oUF.colors.power["RAGE"]
oUF.colors.power[2] = oUF.colors.power["FOCUS"]
oUF.colors.power[3] = oUF.colors.power["ENERGY"]
oUF.colors.power[4] = oUF.colors.power["COMBO_POINTS"]
oUF.colors.power[5] = oUF.colors.power["RUNES"]
oUF.colors.power[6] = oUF.colors.power["RUNIC_POWER"]
oUF.colors.power[7] = oUF.colors.power["SOUL_SHARDS"]
oUF.colors.power[8] = oUF.colors.power["LUNAR_POWER"]
oUF.colors.power[9] = oUF.colors.power["HOLY_POWER"]
oUF.colors.power[11] = oUF.colors.power["MAELSTROM"]
oUF.colors.power[12] = oUF.colors.power["CHI"]
oUF.colors.power[13] = oUF.colors.power["INSANITY"]
oUF.colors.power[16] = oUF.colors.power["ARCANE_CHARGES"]
oUF.colors.power[17] = oUF.colors.power["FURY"]
oUF.colors.power[18] = oUF.colors.power["PAIN"]

oUF.colors.runes = {
    [1] = {225 / 255, 75 / 255, 75 / 255}, -- Blood
    [2] = {50 / 255, 160 / 255, 250 / 255}, -- Frost
    [3] = {100 / 255, 225 / 255, 125 / 255} -- Unholy
}

oUF.colors.reaction = {
    [1] = {182 / 255, 34 / 255, 32 / 255}, -- Hated / Enemy
    [2] = {182 / 255, 34 / 255, 32 / 255},
    [3] = {182 / 255, 92 / 255, 32 / 255},
    [4] = {220 / 225, 180 / 255, 52 / 255},
    [5] = {132 / 255, 181 / 255, 26 / 255},
    [6] = {132 / 255, 181 / 255, 26 / 255},
    [7] = {132 / 255, 181 / 255, 26 / 255},
    [8] = {132 / 255, 181 / 255, 26 / 255},
    [9] = {0 / 255, 110 / 255, 255 / 255} -- Paragon (Reputation)
}

oUF.colors.smooth = {1, 0, 0, 1, 1, 0, 0, 1, 0} -- Red -> Yellow -> Green

-- Last Class Power element color
oUF.colors.power.max = {
    ["COMBO_POINTS"] = {161 / 255, 92 / 255, 255 / 255},
    ["SOUL_SHARDS"] = {255 / 255, 26 / 255, 48 / 255},
    ["LUNAR_POWER"] = {161 / 255, 92 / 255, 255 / 255},
    ["HOLY_POWER"] = {255 / 255, 26 / 255, 48 / 255},
    ["CHI"] = {0 / 255, 143 / 255, 247 / 255},
    ["ARCANE_CHARGES"] = {5 / 255, 96 / 255, 250 / 255}
}

oUF.colors.debuff.Curse = {0.6, 0.2, 1.0}
oUF.colors.debuff.Disease = {0.6, 0.4, 0.0}
oUF.colors.debuff.Magic = {0.2, 0.5, 1.0}
oUF.colors.debuff.Poison = {0.2, 0.8, 0.2}
oUF.colors.debuff.none = {1.0, 0.1, 0.2} -- Physical, etc.
