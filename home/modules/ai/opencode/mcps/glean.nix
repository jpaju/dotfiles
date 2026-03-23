{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.glean = {
        type = "remote";
        url = "https://doordash-be.glean.com/mcp/default";
        enabled = false;
      };
    };
  };
}
