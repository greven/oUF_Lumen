local _, ns = ...

local cfg, oUF = {}, ns.oUF
ns.cfg = cfg

-- ------------------------------------------------------------------------
-- > CONFIGURATION
-- ------------------------------------------------------------------------

  -- -----------------------------------
  -- > COLORS
  -- -----------------------------------

  oUF.colors.power = {
    ["ENERGY"] = {255/255, 255/255, 225/255},
    ["FOCUS"] = {255/255, 192/255, 0/255},
    ["MANA"] = {1/255, 121/255, 228/255},
    ["RAGE"] = {255/255, 26/255, 48/255},
    ["FURY"] = {255/255, 50/255, 50/255},
    ["MAELSTROM"] = {0/255, 200/255, 255/255},
    ["INSANITY"] = {149/255, 97/255, 219/255},
    ["LUNAR_POWER"] = {134/255, 143/255, 254/255},
    ["RUNIC_POWER"] = {134/255, 239/255, 254/255},
    ["RUNES"] = {0/255, 200/255, 255/255},
    ["FUEL"] = {0, 0.55, 0.5},
    ["AMMOSLOT"] = {1, 0.60, 0},
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
    [5] = {132/255, 181/255, 26/255},
    [6] = {132/255, 181/255, 26/255},
    [7] = {132/255, 181/255, 26/255},
    [8] = {132/255, 181/255, 26/255},
  }

  oUF.colors.smooth = {1, 0, 0, 1, 1, 0, 0, 1, 0} -- Red -> Yellow -> White

  cfg.colors = {
    backdrop = {r = 0, g = 0, b = 0, a = 1}, -- Backdrop Color (Some frames might not be affected)
    health = {0.1, 0.1, 0.1, 0.85}, -- The Color to use if cfg.useClassColors and cfg.useReactionColor are set to false
  }

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
        text = {
          hideMax = true
        },
      },
    },
    secondary = {
      width = 101, -- Width of the ToT, Focus, Pet...
      height = 20, -- Height of the ToT, Focus, Pet...
      margin = 8, -- Margin to other frames
      health = {
        margin = 2 -- Spacing between HP and Power Bars
      },
      power = {
        height = 1, -- Height of the Power Bar
      },
    },
    shadow = {
      show = true, -- Use frame drop shadows
      opacity = 0.7,
    },
    range = {
      insideAlpha = 1,
      outsideAlpha = .25,
    }
  }

  -- -----------------------------------
  -- > UNITS
  -- -----------------------------------

  cfg.units = {
    player = {
      show = true,
      width = cfg.frames.main.width,
      height = cfg.frames.main.height,
      pos = { a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -213, y = -310 },
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
        frequentUpdates =Ttrue,
        smooth = true,
      },
      altpower = {
        height = 3
      },
      castbar = {
        enable = true,
        color = {5/255, 107/255, 246/255},
        width = cfg.frames.main.width * 2,
        height = cfg.frames.main.height,
        latency = {
          show = true,
          color = {1, 0, 0, 0.5},
        },
      }
    },
    target = {
      show = true,
      width = cfg.frames.main.width,
      height = cfg.frames.main.height,
      pos = { a1 = "BOTTOMLEFT", a2 = "BOTTOMRIGHT", af = "oUF_LumenPlayer", x = cfg.frames.secondary.margin, y = 0 },
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
      castbar = {
        enable = true,
        color = {235/255, 25/255, 25/255},
        width = cfg.frames.main.width * 2,
        height = cfg.frames.main.height + 4,
      }
    },
    targettarget = {
      show = true,
      width = cfg.frames.secondary.width,
      height = cfg.frames.secondary.height,
      pos = { a1 = "BOTTOMRIGHT", a2 = "TOPRIGHT", af = "oUF_LumenTarget", x = 0, y = cfg.frames.secondary.margin },
      health = {
        classColored = true,
        gradientColored = false,
        classColoredText = false,
        reactionColored = true,
        frequentUpdates = false,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
      },
    },
    focus = {
      show = true,
      width = cfg.frames.secondary.width,
      height = cfg.frames.secondary.height,
      pos = { a1 = "BOTTOMRIGHT", a2 = "TOPRIGHT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin },
      health = {
        classColored = true,
        gradientColored = false,
        classColoredText = false,
        reactionColored =Ttrue,
        frequentUpdates = false,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
      },
      castbar = {
        enable = true,
        color = {123/255, 66/255, 200/255},
        width = cfg.frames.main.width,
        height = cfg.frames.main.height,
      }
    },
    pet = {
      show = true,
      width = cfg.frames.secondary.width,
      height = cfg.frames.secondary.height,
      pos = { a1 = "BOTTOMLEFT", a2 = "TOPLEFT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin },
      health = {
        classColored = false,
        gradientColored = true,
        classColoredText = false,
        reactionColored = false,
        frequentUpdates = true,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
      },
      buffs = {
        filter = true
      }
    },
    boss = {
      show = true,
      width = 225,
      height = 28,
      pos = { a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 800, y = 200 },
      health = {
        gradientColored = false,
        reactionColored = true,
        frequentUpdates = false,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
        text = {
          show = false
        },
      },
      castbar = {
        enable = true,
        color = {5/255, 107/255, 246/255},
      }
    },
    arena = {
      show = true,
      width = 250,
      height = 32,
      pos = { a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 700, y = 200 },
      health = {
        classColored = true,
        gradientColored = false,
        classColoredText = false,
        reactionColored = true,
        frequentUpdates = false,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
      },
    },
    party = {
      show = true,
      width = 132,
      height = 18,
      pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -800, y = 0 },
      health = {
        classColored = false,
        gradientColored = false,
        reactionColored = false,
        invertedColors = true,
        classColoredText = true,
        frequentUpdates = true,
        smooth = true,
      },
      power = {
        height = cfg.frames.secondary.power.height,
        classColored = false,
        frequentUpdates = false,
        smooth = true,
      },
    },
  }

  cfg.elements = {
    castbar = {
      backdrop = {
        color = {r = 0, g = 0, b = 0, a = 0.85},
      }
    },
    experiencebar = {
      show = true,
      height = 3,
      width = Minimap:GetWidth() + 4,
      pos = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "Minimap", x = -2, y = 14 },
    },
    altpowerbar = {
      show = true
    },
  }

  -- -----------------------------------
  -- > BLIZZARD UI RELATED
  -- -----------------------------------

  cfg.blizzard = {
    raidFrames = {
      show = false
    }
  }
