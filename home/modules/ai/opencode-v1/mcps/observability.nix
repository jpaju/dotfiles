{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings.mcp.observability = {
      type = "remote";
      url = "https://agent-gateway-service-mcp-proxy.usw2.workloads.dash-compute.doordash.red:8443/v1/mcp/observability-mcp-mcp-server";
      enabled = false;
    };
  };
}
