{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    dotfiles.ai.mcp = {
      secretEnv.CONTEXT7_API_KEY = config.secrets.context7_api_key;

      servers.context7 = {
        url = "https://mcp.context7.com/mcp";
        headers.CONTEXT7_API_KEY.env = "CONTEXT7_API_KEY";
      };
    };
  };
}
