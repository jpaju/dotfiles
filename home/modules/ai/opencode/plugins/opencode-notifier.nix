{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings = {
      plugin = [
        "@mohak34/opencode-notifier@latest"
      ];
    };

    xdg.configFile."opencode/opencode-notifier.json".text = builtins.toJSON {
      events = {
        complete.sound = false;
        complete.notification = false;
        error.sound = false;
        error.notification = false;
      };
    };
  };
}
