local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local config = wezterm.config_builder()

config.automatically_reload_config = true

-- Setup Terminfo
-- https://wezterm.org/config/lua/config/term.html
-- $ tempfile=$(mktemp) \
--  && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
--  && tic -x -o ~/.terminfo $tempfile \
--  && rm $tempfile
config.term = 'wezterm'

config.set_environment_variables = {
  XDG_CONFIG_HOME = os.getenv('HOME') .. '/.config',
  XDG_STATE_HOME = os.getenv('HOME') .. '/.local/share',
  XDG_DATA_HOME = os.getenv('HOME') .. '/.local/state',
  ZDOTDIR = os.getenv('HOME') .. '/.config/zsh',
}

-- Window config
-- config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.quit_when_all_windows_are_closed = false
config.native_macos_fullscreen_mode = true
config.window_decorations = 'RESIZE'
-- config.integrated_title_button_alignment = 'Right'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  font_size = 12.0,
}
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
config.enable_scroll_bar = false
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_duration_ms = 0,
  fade_out_duration_ms = 0,
}
config.default_cursor_style = 'BlinkingBlock'
config.animation_fps = 1
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.initial_cols = 120
config.initial_rows = 40

local cc = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
config.inactive_pane_hsb = { saturation = 1.0, brightness = 1.0, }
-- cc.background = '#24273A' -- c.base
cc.cursor_bg = '#f5a97f'
cc.tab_bar.background = "#040404"
cc.tab_bar.inactive_tab.bg_color = "#0f0f0f"
cc.tab_bar.new_tab.bg_color = "#080808"

config.color_schemes = {
  ['cc'] = cc
}
-- config.color_scheme = 'Catppuccin Macchiato'
config.color_scheme = 'cc'
-- needs some custom colors to disable the background highlighting
-- https://github.com/catppuccin/wezterm

-- Fonts
-- /Applications/Wezterm.app/Contents/Macos/wezterm ls-fonts --list-system
config.font = wezterm.font('Cartograph CF', { weight = 'Light', italic = false })
config.font_size = 12
config.adjust_window_size_when_changing_font_size = false
config.tab_max_width = 13
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- keybinds
-- There are some issues with macos that need addressing:
-- https://github.com/wezterm/wezterm/discussions/6193
-- https://wezterm.org/changelog.html?h=send_composed_key_when_left_alt_is_pressed#20200620-160318-e00b076c
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
-- /Applications/WezTerm.app/Contents/MacOS/wezterm show-keys --lua
-- https://wezterm.org/config/keys.html
-- https://wezterm.org/config/default-keys.html
config.keys = {
  -- for some reason, wezterm.action.DisableDefaultAction doesn't work on this binding. It always shows the command pallot
  { key = 'Space', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey({ key = 'Space', mods = 'SHIFT|CTRL' }) },
  { key = 'h', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey({ key = 'h', mods = 'SHIFT|CTRL' }) },
  { key = 'j', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey({ key = 'j', mods = 'SHIFT|CTRL' }) },
  { key = 'k', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey({ key = 'k', mods = 'SHIFT|CTRL' }) },
  { key = 'l', mods = 'SHIFT|CTRL', action = wezterm.action.SendKey({ key = 'l', mods = 'SHIFT|CTRL' }) },

  { key = 'Enter', mods = 'CMD', action = wezterm.action.ToggleFullScreen },
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnWindow },
  { key = 'n', mods = 'CMD|SHIFT', action = wezterm.action.SpawnWindow }, -- needs to have CWD
  { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'DefaultDomain' }, -- needs to not have CWD
  { key = 't', mods = 'CMD|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' }, -- needs to have CWD
  { key = 'd', mods = 'CMD', action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 50 }, } },
  { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 50 }, } },
  { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = false } },
  { key = 'w', mods = 'CMD|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = '[', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Prev' },
  { key = ']', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Next' },
  { key = 'Enter', mods = 'CMD|SHIFT', action = wezterm.action.TogglePaneZoomState },
  { key = ',', mods = 'CMD', action = wezterm.action.RotatePanes 'CounterClockwise' },
  { key = '.', mods = 'CMD', action = wezterm.action.RotatePanes 'Clockwise' },
  { key = 'k', mods = 'CMD', action = wezterm.action.Multiple {
    wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    wezterm.action.SendKey { key = 'L', mods = 'CTRL' },
  } },
  { key = 'b', mods = 'CTRL', action = wezterm.action.ScrollByPage(-1) },
  { key = 'f', mods = 'CTRL', action = wezterm.action.ScrollByPage(1) },
  { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'p', mods = 'CMD', action = wezterm.action.PaneSelect },
  { key = 'p', mods = 'CMD|SHIFT', action = wezterm.action.PaneSelect { mode = 'SwapWithActive' }, },
  { key = ' ', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette },
  { key = 'a', mods = 'CMD', action = wezterm.action.ActivateCommandPalette },
  { key = 'c', mods = 'CMD|SHIFT', action = wezterm.action.ActivateCopyMode },
  { key = 'u', mods = 'CMD', action = wezterm.action.QuickSelectArgs {
    label = 'open url',
    patterns = { 'https?://\\S+', },
    action = wezterm.action_callback(function(window, pane)
      local url = window:get_selection_text_for_pane(pane)
      wezterm.log_info('opening: ' .. url)
      wezterm.open_with(url)
    end),
  } },
  { key = ',', mods = 'CMD|SHIFT', action = wezterm.action.MoveTabRelative(-1), },
  { key = '.', mods = 'CMD|SHIFT', action = wezterm.action.MoveTabRelative(1), },
  { key = 'z', mods = 'CMD', action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_tab()
    end),
  },
  { key = 'e', mods = 'CMD', action = wezterm.action.EmitEvent 'trigger-vim-with-scrollback' },
  -- map kitty_mod+shift+z detach_window ask -- send a pane to a tab doesn't seem to be possible via lua
  -- manually rename: https://wezterm.org/config/lua/keyassignment/PromptInputLine.html#example-of-interactively-renaming-the-current-tab
}

-- Mouse
config.scroll_to_bottom_on_input = true
config.swallow_mouse_click_on_pane_focus = true
config.mouse_bindings = {
   { event = { Up = { streak = 1, button = 'Left' } }, mods = 'NONE', action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection') },
   { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CMD', action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('ClipboardAndPrimarySelection') },
   { event = { Down = { streak = 1, button = 'Left' } }, mods = 'CMD', action = wezterm.action.Nop },
}

wezterm.on('trigger-vim-with-scrollback', function(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(text)
  f:flush()
  f:close()
  window:perform_action( wezterm.action.SpawnCommandInNewWindow { args = { 'vim', name }, }, pane)
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local name = string.format('%-6s', tab_title(tab):sub(1,7))
    local title = '  ' .. tab.tab_index + 1 .. ': ' .. name .. '  '

    if tab.is_active then
      return {
        { Text = title }
      }
    else
      return {
        { Text = title }
      }
    end
  end
)
config.colors = {
  tab_bar = {
    background = '#181926',
    active_tab = {
      bg_color = '24273a',
      fg_color = 'f5a97f',
    },
    inactive_tab = {
      bg_color = '1e2030',
      fg_color = 'a5adcb',
    },
  }
}

return config
