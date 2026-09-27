{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.mcp.servers.slack = {
      url = "https://mcp.slack.com/mcp";
      enabled = false;
      oauth = {
        clientId = "1601185624273.8899143856786";
        callbackPort = 3118;
      };
    };
  };
}
