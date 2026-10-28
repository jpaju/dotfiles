{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../secrets/interface.nix
    inputs.omp.homeManagerModules.default
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.omp = {
      enable = true;

      settings = {
        setupVersion = 2;
        theme.dark = "dark-catppuccin";
        symbolPreset = "nerd";

        modelRoles.default = "openai/gpt-6.1-sol:high";

        tools.approvalMode = "write";

        enabledProviders = [ "opencode" ];
        disabledProviders = [
          "alibaba-coding-plan"
          "alibaba-token-plan"
          "qwen-portal"
          "zai"
          "zhipu-coding-plan"
          "minimax-cn"
          "minimax-code-cn"
          "xiaomi"
          "xiaomi-token-plan-ams"
          "xiaomi-token-plan-cn"
          "xiaomi-token-plan-sgp"
          "siliconflow-cn"
          "qianfan"
          "moonshot"
          "deepseek"
        ];
      };

      package = pkgs.writeShellScriptBin "omp" ''
        export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
        export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
        export GEMINI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
        export GOOGLE_API_KEY="$GEMINI_API_KEY"
        ${config.dotfiles.ai.mcp.secretEnvExports}

        exec ${pkgs.omp}/bin/omp "$@"
      '';
    };

    home.file.".omp/agent/mcp.json".source =
      let
        envReference = name: "\${${name}}";

        headerValue = value: if builtins.isString value then value else envReference value.env;

        headers =
          server:
          lib.mapAttrs (_: headerValue) server.headers
          // lib.optionalAttrs (server.bearerTokenEnv != null) {
            Authorization = "Bearer ${envReference server.bearerTokenEnv}";
          };

        oauth =
          oauthClient:
          {
            inherit (oauthClient) clientId callbackPort;
          }
          // lib.optionalAttrs (oauthClient.scopes != [ ]) {
            scope = lib.concatStringsSep " " oauthClient.scopes;
          };

        toOmpMcpServer =
          _: server:
          {
            type = "http";
            inherit (server) url enabled;
          }
          // lib.optionalAttrs (headers server != { }) { headers = headers server; }
          // lib.optionalAttrs (server.oauth != null) { oauth = oauth server.oauth; };
      in
      (pkgs.formats.json { }).generate "omp-mcp.json" {
        mcpServers = lib.mapAttrs toOmpMcpServer config.dotfiles.ai.mcp.servers;
      };
  };
}
