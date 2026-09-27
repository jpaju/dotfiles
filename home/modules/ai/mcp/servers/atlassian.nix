{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    dotfiles.ai.mcp.servers = {
      atlassian-doordash = {
        url = "https://mcp.atlassian.com/v1/mcp";
        enabled = false;
      };

      atlassian-wolt = {
        url = "https://mcp.atlassian.com/v1/mcp";
        enabled = false;
      };
    };
  };
}
