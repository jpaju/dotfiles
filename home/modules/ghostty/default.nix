{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terminal.enable {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      enableFishIntegration = true;

      settings = {
        command = "${pkgs.fish}/bin/fish";
        font-family = "FiraCode Nerd Font Mono";

        # Configure opt key to be alt, but hard code some characters
        macos-option-as-alt = true;
        keybind = [
          "alt+2=text:@"
          "alt+3=text:£"
          "alt+4=text:$"
          "alt+7=text:|"
          "alt+8=text:["
          "alt+9=text:]"
          "shift+alt+slash=text:\\"
          "shift+alt+8=text:{"
          "shift+alt+9=text:}"
          "alt+right_bracket=text:~"

          "cmd+opt+left=previous_tab"
          "cmd+opt+right=next_tab"
        ];
      };
    };

    catppuccin.ghostty.enable = true;
  };
}
