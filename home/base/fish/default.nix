{ pkgs, config, ... }:
{
  imports = [ ./plugins.nix ];

  home.shell.enableFishIntegration = true;
  programs.nix-your-shell.enable = true;
  catppuccin.fish.enable = true;

  programs.fish = {
    enable = true;

    shellAbbrs = {
      reload = "exec fish";
      rl = "exec fish";
      utcnow = "date -u +%Y-%m-%dT%H:%M:%SZ";
    };

    # Load homebrew environment if on mac
    shellInit = ''
      ${if pkgs.stdenv.isDarwin then "eval (/opt/homebrew/bin/brew shellenv fish)" else ""}

      # Make sure nix-daemon is running
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      end
    '';

    interactiveShellInit = ''
      # Load function descriptions to show them in auto-completion
      # This is a workaround until the following issue is resolved: https://github.com/fish-shell/fish-shell/issues/328
      # Stole from this comment: https://github.com/fish-shell/fish-shell/issues/1915#issuecomment-72315918
      for i in (functions);functions $i > /dev/null;end

      bind \cf 'fg 1&> /dev/null'
    '';
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";

    configFile."fish/functions" = {
      source = ./functions;
      recursive = true;
    };
  };
}
