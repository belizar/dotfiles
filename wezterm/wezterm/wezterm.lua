local wezterm = require("wezterm")

return {
	-- Cambiar el color scheme completo
	color_scheme = "Catppuccin Mocha", -- o "GitHub Dark", "Tomorrow Night", etc.

	-- O personalizar colores específicos
	colors = {
		background = "#1e1e2e", -- Cambiar este color
		foreground = "#cdd6f4",

		-- Colores del cursor
		cursor_bg = "#f5e0dc",
		cursor_fg = "#1e1e2e",

		-- Colores ANSI
		ansi = {
			"#45475a", -- black
			"#f38ba8", -- red
			"#a6e3a1", -- green
			"#f9e2af", -- yellow
			"#89b4fa", -- blue
			"#cba6f7", -- magenta
			"#94e2d5", -- cyan
			"#bac2de", -- white
		},

		brights = {
			"#585b70", -- bright black
			"#f38ba8", -- bright red
			"#a6e3a1", -- bright green
			"#f9e2af", -- bright yellow
			"#89b4fa", -- bright blue
			"#cba6f7", -- bright magenta
			"#94e2d5", -- bright cyan
			"#a6adc8", -- bright white
		},
	},

	-- Otras configuraciones útiles
	font_size = 14,
	window_background_opacity = 0.95,
	text_background_opacity = 1.0,
}
