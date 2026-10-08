{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.atlassian-doordash = {
        type = "remote";
        url = "https://mcp.atlassian.com/v1/mcp";
        enabled = false;
      };

      mcp.atlassian-wolt = {
        type = "remote";
        url = "https://mcp.atlassian.com/v1/mcp";
        enabled = false;
      };

      permission = {
        "atlassian*" = "ask";
        "atlassian*_get*" = "allow";
        "atlassian*_search*" = "allow";
        "atlassian*_lookup*" = "allow";
        "atlassian*_fetch*" = "allow";
        "atlassian*_atlassianUserInfo" = "allow";

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
