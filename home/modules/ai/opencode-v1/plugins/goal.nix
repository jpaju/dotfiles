{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings.plugin = [ "@prevalentware/opencode-goal-plugin" ];
    programs.opencode.tui.plugin = [ "@prevalentware/opencode-goal-plugin" ];
  };
}
