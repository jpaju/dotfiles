{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings.mcp.context7 = {
      type = "remote";
      url = "https://mcp.context7.com/mcp";
      headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
    };
  };
}
