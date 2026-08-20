{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings.mcp.datadog = {
      type = "remote";
      url = "https://agent-gateway-service.dashapi.com/v1/mcp/cli-datadog-wolt";
      enabled = false;
    };
  };
}
