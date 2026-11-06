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

  # Rex doesn't watch its config, so reload it on rebuild.
  # Fails on missing CLI or invalid config
  # Installs Rex agent skill and hooks for all detected agents
  home.activation.setupRex =
    let
      rexCLI = "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        if [ ! -x "${rexCLI}" ]; then
          echo "Rex CLI not found at ${rexCLI}, update its path in home/base/multiplexers/rex/default.nix" >&2
          exit 1
        fi

        if ! rexConfigCheck=$("${rexCLI}" config check); then
          echo "$rexConfigCheck" >&2
          exit 1
        fi

        run --quiet "${rexCLI}" --autostart=false config reload || [ $? -eq 4 ]
        run --quiet "${rexCLI}" --autostart=false skill setup
      ''
    );

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
