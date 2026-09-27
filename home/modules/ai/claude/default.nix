{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      package =
        let
          claudeCode = inputs.llm-agents.packages.${system}.claude-code;
          wrappedClaudeCode = pkgs.writeShellScriptBin "claude" ''
            ${config.dotfiles.ai.mcp.secretEnvExports}
            exec ${claudeCode}/bin/claude "$@"
          '';
        in
        # Home Manager uses the package version to select how MCP servers are installed.
        wrappedClaudeCode.overrideAttrs { inherit (claudeCode) version; };

      settings = {
        tui = "fullscreen";

        env.DISABLE_UPDATES = "1";

        permissions.allow = [
          "WebFetchTool"
          "WebSearch"
        ];
      };
    };

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
