{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.datadog = {
        type = "remote";
        url = "https://mcp.datadoghq.eu/api/unstable/mcp-server/mcp";
        enabled = false;
      };
    };
  };
}
