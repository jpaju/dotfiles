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
    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };

    programs.opencode = {
      enable = true;

      package = pkgs.writeShellScriptBin "opencode" ''
        export OPENCODE_DISABLE_LSP_DOWNLOAD=true

        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export CONTEXT7_API_KEY="$(cat ${config.secrets.context7_api_key})"

        exec ${llm-agents.opencode}/bin/opencode "$@"
      '';

      settings = {
        theme = "catppuccin";

        share = "disabled";
        autoupdate = false;

        mcp.context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
        };

        plugin = [
          "@franlol/opencode-md-table-formatter@latest"
          "@mohak34/opencode-notifier@latest"
        ];

        permission = {
          edit = "ask";
          webfetch = "allow";
          bash = {
            "*" = "ask";
            "ls" = "allow";
            "wc" = "allow";
            "cat" = "allow";
            "pwd" = "allow";
            "echo" = "allow";
            "head" = "allow";
            "tail" = "allow";
            "grep" = "allow";
            "rg" = "allow";
          }
          // {
            "git status" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git blame *" = "allow";
          }
          // {
            "gh issue view *" = "allow";
            "gh search *" = "allow";
            "gh repo view *" = "allow";
            "gh pr list *" = "allow";
            "gh pr view *" = "allow";
            "gh pr diff *" = "allow";
            "gh pr checks *" = "allow";
          };
        };
      };

      rules = ''
        # Important rules

        - When reporting information to me be extremely concise. Sacrifice grammar for the sake of concision
        - Don't speculate, if something important is unclear or left out you must ask for clarification
        - Don't be agreeable, act as my honest advisor and mirror
        - Always do one step at a time, verify previous step works before proceeding to next one
        - Don't trust assumptions before verifying them

        # Coding
        - Check up-to-date documentation from context7
        - Don’t comment the code, unless explicitly asked

        # Tool usage
        - Use sub agents for research, searching, investigation and exploring the codebase
        - Never prefix bash commands with cd, for example cd <path> && <actual-cmd>

        # Writing style
        - Only capitalize the first word of a title/heading. Instead of "This Is Very Important Title", write "This is very important title" 
      '';
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
