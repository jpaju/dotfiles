{ ... }: {
  programs.broot = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      icon_theme = "nerdfont";

      imports = [
        "verbs.hjson"
        {
          file = "skins/catppuccin-macchiato.hjson";
          luma = [ "dark" "unknown" ];
        }
      ];

      verbs = [
        {
          invocation = "edit";
          key = "enter";
          shortcut = "e";
          execution = "$EDITOR +{line} {file}";
          apply_to = "text_file";
          leave_broot = false;
        }
        {
          key = "ctrl-t";
          internal = ":toggle_preview";
        }
        {
          key = "ctrl-j";
          internal = "line_down";
        }
        {
          key = "ctrl-k";
          internal = "line_up";
        }
        {
          key = "ctrl-l";
          internal = "focus";
        }
        {
          key = "ctrl-h";
          internal = "back";
        }
      ];
    };
  };
}

