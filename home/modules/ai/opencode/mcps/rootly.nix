{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.rootly = {
        type = "remote";
        url = "https://mcp.rootly.com/mcp";
        enabled = false;
        oauth = false;
        headers.Authorization = "Bearer {env:ROOTLY_API_KEY}";
      };

      permission = {
        "rootly_*" = "ask";
        "rootly_get*" = "allow";
        "rootly_list*" = "allow";
        "rootly_find*" = "allow";
        "rootly_check*" = "allow";
        "rootly_search*" = "allow";
        "rootly_suggest*" = "allow";
      };
    };
  };
}
