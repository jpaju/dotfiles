{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.mcp.servers.javadoc = {
      url = "https://www.javadocs.dev/mcp";
      enabled = false;
    };
  };
}
