local wezterm = require 'wezterm'

local act = wezterm.action;

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
  enable_kitty_keyboard = true,

  keys = {
    { key = 'F11',        mods = 'NONE',                          action = act.ToggleFullScreen },
    { key = 'Enter',      mods = 'ALT',                           action = act.DisableDefaultAssignment },

    { key = 'P',          mods = 'CMD',                           action = act.ActivateCommandPalette },
    { key = 'P',          mods = 'CTRL|SHIFT',                    action = act.DisableDefaultAssignment },

    { key = 'LeftArrow',  mods = 'SUPER|ALT',                     action = act.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = 'SUPER|ALT',                     action = act.ActivateTabRelative(1) },

    { key = '+',          mods = 'SUPER',                         action = act.IncreaseFontSize },
    { key = '-',          mods = 'SUPER',                         action = act.DecreaseFontSize },

    { key = 'phys:2',     mods = 'ALT',                           action = act.SendString '@' },
    { key = 'phys:3',     mods = 'ALT',                           action = act.SendString '£' },
    { key = 'phys:4',     mods = 'ALT',                           action = act.SendString '$' },
    { key = 'phys:7',     mods = 'ALT',                           action = act.SendString '|' },
    { key = 'phys:8',     mods = 'ALT',                           action = act.SendString '[' },
    { key = 'phys:9',     mods = 'ALT',                           action = act.SendString ']' },
    { key = 'phys:7',     mods = 'SHIFT|ALT',                     action = act.SendString '\\' },
    { key = 'phys:8',     mods = 'SHIFT|ALT',                     action = act.SendString '{' },
    { key = 'phys:9',     mods = 'SHIFT|ALT',                     action = act.SendString '}' },

    -- Alt+Left/Right to jump to backward/forward a word
    { key = 'LeftArrow',  mods = 'OPT',                           action = act.SendKey { key = 'b', mods = 'ALT' } },
    { key = 'RightArrow', mods = 'OPT',                           action = act.SendKey { key = 'f', mods = 'ALT' } },

    -- Cmd+Left/Right to jump to beginning/end of line
    { key = 'LeftArrow',  mods = 'SUPER',                         action = act.SendKey { key = 'a', mods = 'CTRL' } },
    { key = 'RightArrow', mods = 'SUPER',                         action = act.SendKey { key = 'e', mods = 'CTRL' } },

    -- Cmd+backspace to remove whole line
    { key = 'Backspace',  mods = 'SUPER',                         action = act.SendKey { key = 'u', mods = 'CTRL' } },

    -- WezTerm doesn't play nice with Delete key when kitty keyboard protocol is enabled
    -- See: https://github.com/wez/wezterm/issues/4785
    { key = 'Delete',     action = act.SendKey { key = 'Delete' } },
  }
}
