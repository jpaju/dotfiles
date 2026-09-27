{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    dotfiles.ai.mcp.servers.linear = {
      url = "https://mcp.linear.app/mcp";
      enabled = false;
    };
  };
}
