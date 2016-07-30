local _, ns = ...

local cfg, oUF = {}, ns.oUF
ns.cfg = cfg

-- ------------------------------------------------------------------------
-- > CONFIGURATION
-- ------------------------------------------------------------------------

  -- -----------------------------------
  -- > GENERAL
  -- -----------------------------------

  cfg.fontsize = 14 -- The Global Font Size
  cfg.scale = 1 -- The Frames Scale

  -- -----------------------------------
  -- > FRAMES
  -- -----------------------------------

  cfg.frames = {
    main = {
      -- width = 170, -- Width of the Player and Target Frames
      width = 209, -- Width of the Player and Target Frames
      height = 26, -- Height of the Player and Target Frames
      health = {
        margin = 2 -- Spacing between HP and Power Bars
      },
      power = {
        height = 2, -- Height of the Power Bar
      },
    },
    secondary = {
      width = 82, -- Width of the ToT, Focus, Pet (...) Frames
      height = 16, -- Height of the ToT, Focus, Pet (...) Frames
    },
    shadow = {
      show = true, -- Use frame drop shadows
      opacity = 0.7,
    },

  }

  -- -----------------------------------
  -- > COLORS
  -- -----------------------------------

  oUF.colors.power = {
    ["MANA"] = {1/255, 121/255, 228/255},
    ["RAGE"] = {255/255, 26/255, 48/255},
    ["FOCUS"] = {255/255, 192/255, 0/255},
    ["ENERGY"] = {40/255, 177/255, 255/255},
    ["MAELSTROM"] = {0/255, 200/255, 255/255},
    ["INSANITY"] = {147/255, 67/255, 255/255},
    ["HAPPINESS"] = {0.00, 1.00, 1.00},
    ["AMMOSLOT"] = {0.80, 0.60, 0.00},
    ["FUEL"] = {0.0, 0.55, 0.5},
    ['POWER_TYPE_STEAM'] = {0.55, 0.57, 0.61},
    ['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17},
    ['POWER_TYPE_HEAT'] = {0.55, 0.57, 0.61},
    ['POWER_TYPE_OOZE'] = {0.76, 1, 0},
    ['POWER_TYPE_BLOOD_POWER'] = {0.7, 0, 1},
  }

  oUF.colors.reaction = {
    [1] = {182/255, 34/255, 32/255},
    [2] = {182/255, 34/255, 32/255},
    [3] = {182/255, 92/255, 32/255},
    [4] = {220/225, 180/255, 52/255},
    [5] = {143/255, 194/255, 32/255},
    [6] = {143/255, 194/255, 32/255},
    [7] = {143/255, 194/255, 32/255},
    [8] = {143/255, 194/255, 32/255},
  }

  oUF.colors.happiness = {
    [1] = {182/225, 34/255, 32/255},
    [2] = {220/225, 180/225, 52/225},
    [3] = {143/255, 194/255, 32/255},
  }

  oUF.colors.smooth = {1, 0, 0, 1, 1, 0, 1, 1, 1} -- R -> Y -> W
  oUF.colors.smoothG = {1, 0, 0, 1, 1, 0, 0, 1, 0} -- R -> Y -> G

  cfg.colors = {
    backdrop = {r = 0, g = 0, b = 0, a = 1}, -- Backdrop Color (Some frames might not be affected)
    health = {0.3, 0.3, 0.3, 1}, -- The Color to use if cfg.useClassColors and cfg.useReactionColor are set to false
  }

  -- -----------------------------------
  -- > UNITS
  -- -----------------------------------

  cfg.units = {
    player = {
      show = true,
      width = cfg.frames.main.width,
      height = cfg.frames.main.height,
      -- pos = { a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = -150, y = -220 },
      pos = { a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -213, y = -325 },
      health = {
        classColored = true,
        gradientColored = true,
        classColoredText = false,
        reactionColored = false,
        frequentUpdates = true,
        smooth = true,
      },
      power = {
        height = cfg.frames.main.power.height,
        classColored = false,
        frequentUpdates = true,
        smooth = true,
      },
      castbar = {
        color = {5/255,107/255,246/255},
        width = cfg.frames.main.width,
        height = cfg.frames.main.height,
      }
    },
    target = {
      show = true,
      width = cfg.frames.main.width,
      height = cfg.frames.main.height,
      -- pos = { a1 = "TOPLEFT", a2 = "TOPRIGHT", af = "oUF_LumenPlayer", x = 300, y = 0 },
      pos = { a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 213, y = -325 },
      health = {
        classColored = true,
        gradientColored = false,
        classColoredText = false,
        reactionColored = true,
        frequentUpdates = true,
        smooth = true,
      },
      power = {
        height = cfg.frames.main.power.height,
        classColored = false,
        frequentUpdates = true,
        smooth = true,
      },
    },
  }

  cfg.elements = {
    castbar = {
      backdrop = {
        color = {r = 0, g = 0, b = 0, a = 0.85},
      }
    }
  }

  -- -----------------------------------
  -- > BLIZZARD UI RELATED
  -- -----------------------------------

  cfg.blizzard = {
    raidFrames = {
      show = false
    }
  }
