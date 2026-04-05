{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    xdg.configFile."opencode/plugins/builtin-tool-redirect.ts".source = ./plugin.ts;
  };
}
