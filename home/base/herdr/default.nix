{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;

      terminal = {
        default_shell = lib.getExe pkgs.fish;
        shell_mode = "auto";
      };

      theme.name = "catppuccin";

      ui = {
        show_agent_labels_on_pane_borders = true;
        status_indicators = "symbols";
        toast.delivery = "terminal";
        sound.enabled = true;
      };

      keys = {
        prefix = "ctrl+g";
        focus_pane_left = "alt+h";
        focus_pane_down = "alt+j";
        focus_pane_up = "alt+k";
        focus_pane_right = "alt+l";
        zoom = "prefix+f";
        command = [
          {
            key = "prefix+space";
            type = "popup";
            command = "exec ${lib.getExe pkgs.fish}";
            description = "open floating shell";
            width = "80%";
            height = "80%";
          }
        ];
      };
    };
  };

  xdg.configFile."herdr/local-plugins/popup-tools" = {
    source = ./plugins/popup-tools;
    onChange =
      let
        herdrCLI = lib.getExe pkgs.herdr;
        pluginPath = "${config.xdg.configHome}/herdr/local-plugins/popup-tools";
      in
      "${herdrCLI} plugin link ${pluginPath}";
  };

  programs.fish.shellAbbrs.hrd = "herdr";
}
