{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    xdg.configFile."opencode/plugins/tool-redirect.ts".source = ./plugin.ts;
    programs.opencode.settings.policies = lib.mkAfter [
      {
        action = "integration.use";
        resource = "plugin:${config.xdg.configHome}/opencode/plugins/tool-redirect.ts";
        effect = "allow";
      }
    ];
  };
}
