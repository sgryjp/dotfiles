local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tokyo Night (Goph)"
	else
		return "Tokyo Night Light (Goph)"
	end
end

config.font = wezterm.font("UDEV Gothic 35NF")
config.font_size = 11
config.color_scheme = scheme_for_appearance(get_appearance())

return config
