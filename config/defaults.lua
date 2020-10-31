local _, ns = ...

local cfg, m = {}, {}
ns.cfg = cfg
ns.m = m

-- -----------------------------------
-- > MEDIA
-- -----------------------------------

m.fonts = {
  font = "Interface\\AddOns\\oUF_lumen\\media\\font.ttf",
  symbols = "Interface\\AddOns\\oUF_lumen\\media\\symbols.otf",
  symbols_light = "Interface\\AddOns\\oUF_lumen\\media\\symbols_light.otf"
}

m.textures = {
  status_texture = "Interface\\AddOns\\oUF_lumen\\media\\statusbar",
  fill_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture",
  bg_texture = "Interface\\AddOns\\oUF_lumen\\media\\texture_bg",
  border = "Interface\\AddOns\\oUF_lumen\\media\\border",
  white_square = "Interface\\AddOns\\oUF_lumen\\media\\white",
  glow_texture = "Interface\\AddOns\\oUF_lumen\\media\\glow",
  damager_texture = "Interface\\AddOns\\oUF_lumen\\media\\damager",
  healer_texture = "Interface\\AddOns\\oUF_lumen\\media\\healer",
  tank_texture = "Interface\\AddOns\\oUF_lumen\\media\\tank"
}

cfg.roleIconTextures = {
  TANK = m.textures.tank_texture,
  HEALER = m.textures.healer_texture,
  DAMAGER = m.textures.damager_texture
}

cfg.roleIconColor = {
  TANK = {0 / 255, 175 / 255, 255 / 255},
  HEALER = {0 / 255, 255 / 255, 100 / 255},
  DAMAGER = {225 / 255, 0 / 255, 25 / 255}
}

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
  backdrop = {0, 0, 0, 0.9}, -- Backdrop Color (Some frames might not be affected)
  health = {0.2, 0.2, 0.2, 1}, -- Fallback color
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
    margin = 226, -- Margin between Player and Target Frames
    health = {
      margin = 1 -- Spacing between HP and Power Bars
    },
    power = {
      height = 2, -- Height of the Power Bar
      text = {
        hideMax = true
      }
    },
    classPower = {
      height = 2
    }
  },
  secondary = {
    width = 98, -- Width of the ToT, Focus, Pet...
    height = 20, -- Height of the ToT, Focus, Pet...
    margin = 10, -- Margin to other frames
    health = {
      margin = 2 -- Spacing between HP and Power Bars
    },
    power = {
      height = 1.5 -- Height of the Power Bar
    }
  },
  shadow = {
    show = true, -- Use frame drop shadows
    color = {0, 0, 0, 0.7}
  },
  range = {
    insideAlpha = 1,
    outsideAlpha = 0.25
  }
}

-- -----------------------------------
-- > Elements
-- -----------------------------------

cfg.elements = {
  castbar = {
    backdrop = {
      color = {0, 0, 0, 0.9}
    },
    timeToHold = 1.5,
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.1,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3,
      fadeOutDelay = 0.5
    }
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
  },
  mirrorTimers = {
    width = 220,
    height = cfg.frames.main.height + 2
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
    pos = {a1 = "LEFT", a2 = "CENTER", af = "UIParent", x = -322, y = -322},
    health = {
      classColored = false,
      gradientColored = true,
      classColoredText = false,
      reactionColored = false,
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
    altpower = {
      height = 3
    },
    castbar = {
      enable = true,
      pos = {a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = "oUF_LumenPlayer", x = cfg.frames.main.height + 2, y = -135},
      color = {5 / 255, 107 / 255, 246 / 255},
      width = cfg.frames.main.width * 2 + cfg.frames.main.margin - cfg.frames.main.height / 2 + 6,
      height = cfg.frames.main.height,
      latency = {
        show = true,
        color = {1, 0, 0, 0.5}
      }
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = true,
        spellName = true
      },
      barTimers = {
        show = true
      }
    },
    visibility = "[combat][mod] show; [indoors,resting][flying] hide; show",
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.3,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3
    }
  },
  target = {
    show = true,
    width = cfg.frames.main.width,
    height = cfg.frames.main.height,
    pos = {a1 = "BOTTOMLEFT", a2 = "BOTTOMRIGHT", af = "oUF_LumenPlayer", x = cfg.frames.main.margin, y = 0},
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
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
      height = cfg.frames.main.height
    },
    auras = {
      buffs = {
        show = true,
        spellName = false
      },
      debuffs = {
        show = false,
        spellName = false
      },
      barTimers = {
        show = true
      }
    },
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.3,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3
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
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = false,
        spellName = false
      }
    },
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.3,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3
    }
  },
  focus = {
    show = true,
    width = cfg.frames.secondary.width,
    height = cfg.frames.secondary.height,
    pos = {
      a1 = "BOTTOMRIGHT",
      a2 = "TOPRIGHT",
      af = "oUF_LumenPlayer",
      x = 0,
      y = cfg.frames.secondary.margin
    },
    health = {
      classColored = true,
      gradientColored = false,
      classColoredText = false,
      reactionColored = true,
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
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = false,
        spellName = false
      }
    },
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.3,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3
    }
  },
  pet = {
    show = true,
    width = cfg.frames.secondary.width,
    height = cfg.frames.secondary.height,
    pos = {a1 = "BOTTOMLEFT", a2 = "TOPLEFT", af = "oUF_LumenPlayer", x = 0, y = cfg.frames.secondary.margin},
    health = {
      classColored = false,
      gradientColored = false,
      classColoredText = false,
      reactionColored = false,
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = true,
      smooth = true
    },
    auras = {
      buffs = {
        show = true,
        filter = true
      },
      debuffs = {
        show = false,
        spellName = false
      }
    },
    visibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift][channeling] hide; [pet,mod][pet,harm][pet,combat] show; hide",
    fader = {
      fadeInAlpha = 1,
      fadeInDuration = 0.3,
      fadeOutAlpha = 0,
      fadeOutDuration = 0.3
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
      color = {5 / 255, 107 / 255, 246 / 255},
      width = 282,
      height = cfg.frames.main.height
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = false,
        spellName = false
      }
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
      smooth = true
    },
    power = {
      height = cfg.frames.secondary.power.height,
      classColored = false,
      frequentUpdates = false,
      smooth = true
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = false,
        spellName = false
      }
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
      smooth = true
    },
    power = {
      height = 2,
      classColored = true,
      frequentUpdates = false,
      smooth = true
    },
    auras = {
      buffs = {
        show = false,
        spellName = false
      },
      debuffs = {
        show = true,
        spellName = false
      }
    },
    showPortraits = true,
    forceRole = false
  },
  raid = {
    show = true
  },
  nameplate = {
    show = true,
    width = 120,
    height = 6,
    pos = {a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0},
    power = {
      height = 4,
      classColored = false,
      frequentUpdates = true,
      smooth = true
    },
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
    showGlow = true,
    showHighlight = false
  }
}
