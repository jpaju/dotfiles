{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    dotfiles.ai.mcp.servers.datadog = {
      url = "https://agent-gateway-service.dashapi.com/v1/mcp/cli-datadog-wolt";
      enabled = false;
    };
  };
}
