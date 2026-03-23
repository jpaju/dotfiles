{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.atlassian = {
        type = "remote";
        url = "https://mcp.atlassian.com/v1/mcp";
        enabled = false;
      };

      permission = {
        "atlassian_*" = "ask";
        "atlassian_get*" = "allow";
        "atlassian_search*" = "allow";
        "atlassian_lookup*" = "allow";
        "atlassian_fetch*" = "allow";
        "atlassian_atlassianUserInfo" = "allow";
        bash = {
          "jira issue list *" = "allow";
          "jira issue view *" = "allow";
          "jira epic list *" = "allow";
          "jira me *" = "allow";
        };
      };
    };
  };
}
