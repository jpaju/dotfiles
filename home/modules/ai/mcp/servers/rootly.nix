{ config, lib, ... }:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    dotfiles.ai.mcp = {
      secretEnv.ROOTLY_API_KEY = config.secrets.rootly_api_key;

      servers.rootly = {
        url = "https://mcp.rootly.com/mcp";
        enabled = false;
        bearerTokenEnv = "ROOTLY_API_KEY";
      };
    };
  };
}
