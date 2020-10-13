local _, ns = ...

local cfg, oUF = {}, ns.oUF
ns.cfg = cfg

-- ------------------------------------------------------------------------
-- > CONFIGURATION
-- ------------------------------------------------------------------------

-- Healing specs
cfg.healingSpecs = {
  "Restoration",
  "Mistweaver",
  "Holy",
  "Discipline"
}

-- -----------------------------------
-- > COLORS
-- -----------------------------------

cfg.colors = {
  backdrop = {r = 0, g = 0, b = 0, a = 1}, -- Backdrop Color (Some frames might not be affected)
  health = {0.3, 0.3, 0.3, 1}, -- Fallback color
  inverted = {0.1, 0.1, 0.1, 1} -- Inverted Color
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
    width = 208, -- Width of the Player and Target Frames
    height = 26, -- Height of the Player and Target Frames
    health = {
      margin = 2 -- Spacing between HP and Power Bars
    },
    power = {
      height = 1, -- Height of the Power Bar
      text = {
        hideMax = true
      }
    }
  },
  secondary = {
    width = 102, -- Width of the ToT, Focus, Pet...
    height = 20, -- Height of the ToT, Focus, Pet...
    margin = 10, -- Margin to other frames
    health = {
      margin = 2 -- Spacing between HP and Power Bars
    },
    power = {
      height = 1 -- Height of the Power Bar
    }
  },
  shadow = {
    show = true, -- Use frame drop shadows
    opacity = 0.7
  },
  range = {
    insideAlpha = 1,
    outsideAlpha = 0.25
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
    pos = {a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -213, y = -310},
    health = {
      classColored = true,
      gradientColored = true,
      classColoredText = false,
      reactionColored = false,
      frequentUpdates = true,
      smooth = true
    },
    power = {
      height = cfg.frames.main.power.height,
      classColored = false,
      frequentUpdates = true,
      smooth = true
    },
    -- visibility = "[combat][mod][@target,exists][vehicleui][group] show; hide",
    name = {
      show = true
    },
    altpower = {
      height = 2
    },
    castbar = {
      enable = true,
      pos = {a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "oUF_LumenPlayer", x = cfg.frames.main.height, y = -102},
      color = {5 / 255, 107 / 255, 246 / 255},
      width = cfg.frames.main.width * 2 + 2,
      height = 25,
      latency = {
        show = true,
        color = {1, 0, 0, 0.4}
      }
    },
    auras = {
      debuffs = {
        show = true
      },
      barTimers = {
        show = true
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
    pos = {a1 = "BOTTOMLEFT", a2 = "BOTTOMRIGHT", af = "oUF_LumenPlayer", x = cfg.frames.secondary.margin, y = 0},
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
      frequentUpdates = true,
      smooth = true
    },
    power = {
      height = cfg.frames.main.power.height,
      classColored = false,
      frequentUpdates = true,
      smooth = true
    },
    name = {
      show = true
    },
    castbar = {
      enable = true,
      color = {235 / 255, 25 / 255, 25 / 255},
      width = cfg.frames.main.width * 1.75,
      height = cfg.frames.main.height + 4
    },
    auras = {
      buffs = {
        show = true
      },
      barTimers = {
        show = true
      }
    }
  },
  targettarget = {
    show = true,
    width = cfg.frames.secondary.width,
    height = cfg.frames.secondary.height,
    pos = {a1 = "BOTTOMRIGHT", a2 = "TOPRIGHT", af = "oUF_LumenTarget", x = 0, y = cfg.frames.secondary.margin},
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
      frequentUpdates = false,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    }
  },
  focus = {
    show = true,
    width = cfg.frames.secondary.width,
    height = cfg.frames.secondary.height,
    pos = {a1 = "BOTTOMRIGHT", a2 = "TOPRIGHT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin},
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
      frequentUpdates = false,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    },
    castbar = {
      enable = true,
      color = {123 / 255, 66 / 255, 200 / 255},
      width = 282,
      height = cfg.frames.main.height
    }
  },
  pet = {
    show = true,
    width = cfg.frames.secondary.width,
    height = cfg.frames.secondary.height,
    pos = {a1 = "BOTTOMLEFT", a2 = "TOPLEFT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin},
    health = {
      classColored = false,
      gradientColored = true,
      classColoredText = false,
      reactionColored = false,
      frequentUpdates = true,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    },
    buffs = {
      filter = true
    }
  },
  boss = {
    show = true,
    width = 200,
    height = 28,
    pos = {a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 700, y = 200},
    health = {
      gradientColored = false,
      reactionColored = true,
      frequentUpdates = false,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true,
      text = {
        show = false
      }
    },
    castbar = {
      enable = true,
      color = {5 / 255, 107 / 255, 246 / 255}
    }
  },
  arena = {
    show = true,
    width = 250,
    height = 32,
    pos = {a1 = "RIGHT", a2 = "CENTER", af = "UIParent", x = 700, y = 200},
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
      frequentUpdates = false,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    }
  },
  party = {
    show = true,
    width = 164,
    height = 40,
    pos = {a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -550, y = -102},
    health = {
      classColored = true,
      gradientColored = false,
      reactionColored = false,
      invertedColors = true,
      classColoredText = false,
      frequentUpdates = true,
      smooth = true
    },
    power = {
      height = 1.5,
      classColored = true,
      frequentUpdates = false,
      smooth = true
    },
    showPortraits = true,
    forceRole = true
  },
  raid = {
    show = true
  },
  nameplate = {
    show = true,
    width = 120,
    height = 10,
    pos = {a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0},
    classpower = true,
    debuffs = true,
    castbar = {
      enable = true,
      color = {5 / 255, 107 / 255, 246 / 255},
      height = 2
    },
    selectedColor = {255 / 255, 25 / 255, 25 / 255, 0.8},
    glowColor = {50 / 255, 240 / 255, 210 / 255, 0.7},
    showTargetArrow = false,
    showGlow = false,
    showHighlight = true
  }
}

cfg.elements = {
  castbar = {
    backdrop = {
      color = {r = 0, g = 0, b = 0, a = 0.85}
    },
    timeToHold = 2
  },
  experiencebar = {
    show = true,
    height = 3,
    width = Minimap:GetWidth() + 4,
    pos = {a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "Minimap", x = -2, y = -12}
  },
  artifactpowerbar = {
    show = true,
    height = 3,
    width = Minimap:GetWidth() + 4,
    pos = {a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "Minimap", x = -2, y = -24}
  },
  altpowerbar = {
    show = true
  }
}
