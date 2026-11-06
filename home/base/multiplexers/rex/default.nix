{
  config,
  lib,
  pkgs,
  ...
}:
{
  # NOTE (6.11.2026) No native edit scrollback in editor in Rex
  # NOTE Catppuccin theme needs to imported manually: Import Theme > ~/.config/ghostty/themes/catppuccin-macchiato

  targets.darwin.defaults."com.superlogical.rex" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    "Workspace.paneDensity" = "compact";
    "Workspace.animationStyle" = "snappy";
    "Workspace.inactivePaneFadeMode" = "none";
    "Workspace.terminalFontName" = "FiraCode Nerd Font Mono";
    "Workspace.terminalFontPointSize" = 13.0;
    "Workspace.terminalSmoothScrolling" = true;
    "Workspace.terminalStartupCommand" = "${config.home.profileDirectory}/bin/fish";
  };

  xdg.configFile."rex/init.lua".source = ./init.lua;
  # Makes the rex CLI available when fish is installed with Nix: https://www.superlogical.com/rex/docs/automate/cli#nix
  programs.fish.interactiveShellInit = ''
    if set -q REX_BIN_DIR
      fish_add_path --path --prepend --move $REX_BIN_DIR
    end
  '';

  xdg.configFile."fish/completions/rex.fish".text = ''
    command -q rex; and rex completion fish | source
  '';
}
