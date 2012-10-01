
-- ------------------------------------------------------------------------
-- > Colors
-- ------------------------------------------------------------------------

	local addon, ns = ...
	local colors = CreateFrame("Frame")

	-- General Colors
	colors.TEXT = {

		Red		= {250,20,0},
		Green	= {155,255,0},
		Blue	= {0,150,250},
		Yellow 	= {255,188,8},
	}	

	-- Indicators Colors
	colors.INDICATORS = {
	
			Green = {174/255,255/255,0/255},
			Red = {235/255,15/255,15/255},
			Blue = {0/255,186/255,255/255},
			Purple = {255/255,0/255,125/255},
			Orange = {255/255,162/255,0/255},
			White = {255/255,255/255,255/255},
		}

	ns.colors = colors -- Don't change this !!