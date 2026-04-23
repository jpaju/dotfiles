{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings.mcp.odin = {
      type = "remote";
      url = "https://cybertron-service-gateway-mcp.doordash.team/observability-mcp/mcp";
      enabled = false;
    };
  };
}
