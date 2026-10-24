{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.linear = {
        type = "remote";
        url = "https://mcp.linear.app/mcp";
        enabled = false;
      };

      permission = {
        "linear_*" = "ask";
        "linear_get*" = "allow";
        "linear_list*" = "allow";
        "linear_search*" = "allow";
      };
    };
  };
}
