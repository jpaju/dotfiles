{
  config,
  lib,
  pkgs,
  nix-ai-tools,
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

        exec ${nix-ai-tools.opencode}/bin/opencode "$@"
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

        permission = {
          edit = "ask";
          webfetch = "allow";
          bash = {
            "*" = "ask";
            "ls" = "allow";
            "pwd" = "allow";
            "echo" = "allow";
            "head" = "allow";
            "tail" = "allow";
            "wc" = "allow";
            "cat" = "allow";
            "grep" = "allow";
            "rg" = "allow";
            "git status" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git blame *" = "allow";
            "gh pr list *" = "allow";
            "gh pr view *" = "allow";
            "gh pr diff *" = "allow";
            "gh pr checks *" = "allow";
          };
        };
      };

      rules = ''
        # Important rules

        - Be extremely concise. Sacrifice grammar for the sake of concision
        - Never speculate, if something is unclear or left out you must ask for clarification
        - One step at a time, always verify previous step works before proceeding to next one
        - Stop being agreeable and act as my brutally honest, advisor and mirror
        - Don’t comment the code, unless explicitly asked
        - Never prefix bash commands with cd, for example cd <path> & <actual-cmd>

        # Writing style
        - Only capitalize the first word of a title/heading. Instead of "This Is Very Important Title", write "This is very important title" 
      '';
    };
  };
}
