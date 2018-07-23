local _, ns = ...

local cfg, oUF = {}, ns.oUF
ns.cfg = cfg

-- ------------------------------------------------------------------------
-- > CONFIGURATION
-- ------------------------------------------------------------------------

-- -----------------------------------
-- > COLORS
-- -----------------------------------

cfg.colors = {
  backdrop = {r = 0, g = 0, b = 0, a = 1}, -- Backdrop Color (Some frames might not be affected)
  health = {0.1, 0.1, 0.1, 0.85}, -- Fallback color
}

-- -----------------------------------
-- > GENERAL
-- -----------------------------------

cfg.fontsize = 14 -- The Global Font Size
cfg.scale = 1 -- The elements Scale

-- -----------------------------------
-- > FRAMES
-- -----------------------------------

cfg.frames = {
  main = {
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
    outsideAlpha = 0.25,
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
    name = {
      show = true
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
        show = false,
        color = {1, 0, 0, 0.5},
      }
    },
    fader = {
      enable = false,
      alpha = 0.3
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
    name = {
      show = true
    },
    castbar = {
      enable = true,
      color = {235/255, 25/255, 25/255},
      width = cfg.frames.main.width * 1.75,
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
    width = 200,
    height = 28,
    pos = { a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 675, y = 50 },
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
    width = 134,
    height = 22,
    pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -525, y = -100 },
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

  raid = {
    show = true
  },

  nameplate = {
    show = true,
    width = 120,
    height = 10,
    pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 },
    debuffs = true,
    castbar = {
      enable = true,
      color = {5/255, 107/255, 246/255},
      height = 3,
    }
  }
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
    pos = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "Minimap", x = -2, y = -12 },
  },

  arcanepowerbar = {
    show = true,
    height = 3,
    width = Minimap:GetWidth() + 4,
    pos = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "Minimap", x = -2, y = -24 },
  },

  altpowerbar = {
    show = true
  },
}
