{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    dotfiles.ai.mcp.servers.glean = {
      url = "https://doordash-be.glean.com/mcp/default";
      enabled = false;
    };
  };
}
