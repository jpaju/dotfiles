{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    dotfiles.ai.mcp.servers.javadoc = {
      url = "https://www.javadocs.dev/mcp";
      enabled = false;
    };
  };
}
