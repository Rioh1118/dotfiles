local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- 起動したら tmux の main セッションにアタッチ（無ければ作る）。
-- tmux サーバーが新しく起動したときは continuum が前回の状態を復元する。
config.default_prog = { "/bin/zsh", "-l", "-c", "exec tmux new-session -A -s main" }

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.window_background_opacity = 0.88
config.macos_window_background_blur = 10

config.keys = {
	-- JIS 配列: Opt+¥ でバックスラッシュ
	{ key = "¥", mods = "OPT", action = act.SendKey({ key = "\\" }) },
	-- tmux を通さない素の zsh ウィンドウ（tmux が壊れたとき用）
	{ key = "n", mods = "CMD|SHIFT", action = act.SpawnCommandInNewWindow({ args = { "/bin/zsh", "-l" } }) },
}

return config
