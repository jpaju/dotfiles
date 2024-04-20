local wezterm = require 'wezterm'

return {
  default_prog = { '/etc/profiles/per-user/jaakkopaju/bin/fish' },

  scrollback_lines = 5000,

  -- Font
  font_size = 13.0,
  font = wezterm.font 'FiraCode Nerd Font',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

  -- Apperance
  color_scheme = 'Snazzy',
  underline_position = '-2pt',
  underline_thickness = '1pt',

  -- MacOS compatibility
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,

  -- Keyboard
  use_ime = true,
  use_dead_keys = false,
  enable_kitty_keyboard = false,

  keys = {
    { key = 'F11',        mods = 'NONE',            action = wezterm.action.ToggleFullScreen },
    { key = 'Enter',      mods = 'ALT',             action = wezterm.action.DisableDefaultAssignment },

    { key = 'P',          mods = 'CMD',             action = wezterm.action.ActivateCommandPalette },

    { key = 'LeftArrow',  mods = 'SUPER|ALT',       action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER|ALT',       action = wezterm.action.ActivateTabRelative(1) },
    { key = 'LeftArrow',  mods = 'SHIFT|SUPER|ALT', action = wezterm.action.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'SHIFT|SUPER|ALT', action = wezterm.action.MoveTabRelative(1) },

    { key = '+',          mods = 'SUPER',           action = wezterm.action.IncreaseFontSize },
    { key = '-',          mods = 'SUPER',           action = wezterm.action.DecreaseFontSize },

    { key = 'phys:2',     mods = 'ALT',             action = wezterm.action.SendString '@' },
    { key = 'phys:3',     mods = 'ALT',             action = wezterm.action.SendString '£' },
    { key = 'phys:4',     mods = 'ALT',             action = wezterm.action.SendString '$' },
    { key = 'phys:7',     mods = 'ALT',             action = wezterm.action.SendString '|' },
    { key = 'phys:8',     mods = 'ALT',             action = wezterm.action.SendString '[' },
    { key = 'phys:9',     mods = 'ALT',             action = wezterm.action.SendString ']' },
    { key = 'phys:7',     mods = 'SHIFT|ALT',       action = wezterm.action.SendString '\\' },
    { key = 'phys:8',     mods = 'SHIFT|ALT',       action = wezterm.action.SendString '{' },
    { key = 'phys:9',     mods = 'SHIFT|ALT',       action = wezterm.action.SendString '}' },

    -- Make Alt-Left/Right jump back/forward a word
    { key = 'LeftArrow',  mods = 'SUPER',           action = wezterm.action.SendString '\x01' },
    { key = 'RightArrow', mods = 'SUPER',           action = wezterm.action.SendString '\x05' },

    -- Make Alt-Left/Right jump back/forward a word
    { key = "LeftArrow",  mods = "ALT",             action = wezterm.action.SendString '\x1bb' },
    { key = "RightArrow", mods = "ALT",             action = wezterm.action.SendString '\x1bf' },

    -- Make Cmd/Alt+backspace to remove whole line/one word
    { key = 'Backspace',  mods = 'SUPER',           action = wezterm.action.SendString '\x15' },
  }
}
