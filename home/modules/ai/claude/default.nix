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

      mcpServers =
        let
          envReference = name: "\${${name}}";

          headerValue = value: if builtins.isString value then value else envReference value.env;

          bearerHeader =
            server:
            lib.optionalAttrs (server.bearerTokenEnv != null) {
              Authorization = "Bearer ${envReference server.bearerTokenEnv}";
            };

          headers = server: lib.mapAttrs (_: headerValue) server.headers // bearerHeader server;

          oauth =
            oauthClient:
            {
              inherit (oauthClient) clientId callbackPort;
            }
            // lib.optionalAttrs (oauthClient.scopes != [ ]) {
              scopes = lib.concatStringsSep " " oauthClient.scopes;
            };

          toClaudeMcpServer =
            _: server:
            {
              type = "http";
              inherit (server) url;
            }
            // lib.optionalAttrs (headers server != { }) { headers = headers server; }
            // lib.optionalAttrs (server.oauth != null) { oauth = oauth server.oauth; };
        in
        lib.mapAttrs toClaudeMcpServer config.dotfiles.ai.mcp.servers;
    };

    programs.fish.shellAbbrs = {
      cc = "claude";
      ccr = "claude --resume";
    };
  };
}
