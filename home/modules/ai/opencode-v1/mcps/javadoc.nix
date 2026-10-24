{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings.mcp.javadoc = {
      type = "remote";
      url = "https://www.javadocs.dev/mcp";
      enabled = false;
    };
  };
}
