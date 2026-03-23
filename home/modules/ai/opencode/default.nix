{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}:
{
  imports = [ ../../secrets/interface.nix ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode = {
      enable = true;

      rules = ./rules.md;
      skills = ./skills;
      commands = ./commands;

      settings = {
        share = "disabled";
        autoupdate = false;
        theme = "catppuccin";

        default_agent = "plan";
        small_model = "anthropic/claude-haiku-4-5";
        agent.explore.model = "anthropic/claude-haiku-4-5";

        mcp.context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };

        mcp.datadog = {
          type = "remote";
          url = "https://mcp.datadoghq.eu/api/unstable/mcp-server/mcp";
          enabled = false;
        };

        mcp.atlassian = {
          type = "remote";
          url = "https://mcp.atlassian.com/v1/mcp";
          enabled = false;
        };

        mcp.glean = {
          type = "remote";
          url = "https://doordash-be.glean.com/mcp/default";
          enabled = false;
        };

        plugin = [
          "@franlol/opencode-md-table-formatter@latest"
          "@mohak34/opencode-notifier@latest"
        ];

        permission = {
          edit = "ask";
          webfetch = "allow";
          "atlassian_*" = "ask";
          "atlassian_get*" = "allow";
          "atlassian_search*" = "allow";
          "atlassian_lookup*" = "allow";
          "atlassian_fetch*" = "allow";
          "atlassian_atlassianUserInfo" = "allow";
          bash = {
            "*" = "ask";
            "ls *" = "allow";
            "wc *" = "allow";
            "pwd" = "allow";
            "head *" = "allow";
            "tail *" = "allow";
            "grep *" = "allow";
            "rg *" = "allow";
            "jq *" = "allow";
            "sort *" = "allow";
            "sed *" = "allow";
            "awk *" = "allow";
            "date *" = "allow";
          }
          // {
            "git status" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git blame *" = "allow";
            "git branch -v" = "allow";
            "git branch -r" = "allow";
            "git branch -a" = "allow";
            "git branch --all" = "allow";
            "git branch --list" = "allow";
            "git branch --remotes" = "allow";
            "git branch --show-current" = "allow";
            "git merge-base *" = "allow";
          }
          // {
            "gh issue view *" = "allow";
            "gh search *" = "allow";
            "gh repo view *" = "allow";
            "gh pr list *" = "allow";
            "gh pr view *" = "allow";
            "gh pr diff *" = "allow";
            "gh pr checks *" = "allow";
            "gh run view *" = "allow";
            "gh run list *" = "allow";
            "gh run watch *" = "allow";
            "gh-discussion-search *" = "allow";
          }
          // {
            "jira issue list *" = "allow";
            "jira issue view" = "allow";
            "jira issue list" = "allow";
            "jira epic list" = "allow";
            "jira me" = "allow";
          };
        };
      };

      package = pkgs.writeShellScriptBin "opencode" ''
        export OPENCODE_DISABLE_LSP_DOWNLOAD=true

        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export CONTEXT7_API_KEY="$(cat ${config.secrets.context7_api_key})"

        exec ${llm-agents.opencode}/bin/opencode "$@"
      '';
    };

    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };

    xdg.configFile."opencode/opencode-notifier.json".text = builtins.toJSON {
      events = {
        complete.sound = false;
        complete.notification = false;
        error.sound = false;
        error.notification = false;
      };
    };
  };
}
