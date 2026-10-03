{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [ ../../secrets/interface.nix ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.codex = {
      enable = true;
      mutableSettings = true;

      package =
        let
          wrappedCodex = pkgs.writeShellScriptBin "codex" ''
            export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
            ${config.dotfiles.ai.mcp.secretEnvExports}
            exec ${inputs.llm-agents.packages.${system}.codex}/bin/codex "$@"
          '';
        in
        # Home Manager uses the package version to select the config format.
        wrappedCodex.overrideAttrs { inherit (inputs.llm-agents.packages.${system}.codex) version; };

      settings = {
        model_provider = "openai-api-key";
        check_for_update_on_startup = false;

        model_providers.openai-api-key = {
          name = "OpenAI API key";
          base_url = "https://api.openai.com/v1";
          env_key = "OPENAI_API_KEY";
          wire_api = "responses";
          requires_openai_auth = false;
        };

        shell_environment_policy.ignore_default_excludes = false;

        mcp_servers =
          let
            isEnvReference = value: !builtins.isString value;

            literalHeaders = server: lib.filterAttrs (_: value: !isEnvReference value) server.headers;

            envHeaders = server: lib.mapAttrs (_: value: value.env) (lib.filterAttrs (_: isEnvReference) server.headers);

            oauth = oauthClient: {
              client_id = oauthClient.clientId;
              callback_port = oauthClient.callbackPort;
            };

            toCodexMcpServer =
              _: server:
              {
                inherit (server) url;
              }
              // lib.optionalAttrs (literalHeaders server != { }) { http_headers = literalHeaders server; }
              // lib.optionalAttrs (envHeaders server != { }) { env_http_headers = envHeaders server; }
              // lib.optionalAttrs (server.bearerTokenEnv != null) {
                bearer_token_env_var = server.bearerTokenEnv;
              }
              // lib.optionalAttrs (server.oauth != null) { oauth = oauth server.oauth; }
              // lib.optionalAttrs (server.oauth != null && server.oauth.scopes != [ ]) {
                inherit (server.oauth) scopes;
              };
          in
          lib.mapAttrs toCodexMcpServer config.dotfiles.ai.mcp.servers;
      };
    };

    programs.fish.shellAbbrs.cx = "codex";
  };
}
