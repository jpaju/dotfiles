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

      # TODO Currently doesn't work as Codex needs writable config file to store trusted folders/repos
      # See issue to add mutableSettings: https://github.com/nix-community/home-manager/issues/9397
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

        # TODO Workaround immutable Home Manager config until mutable settings are supported
        projects =
          let
            workProjects = [
              "datamill"
              "devops"
              "ma-warehouse-api"
              "merchant-app-bff"
              "merchant-foundations-utils"
              "monteur"
              "offer-commissions-service"
              "offer-listing-service"
              "offering-platform-bootstrap"
              "offering-platform-worktrees"
              "offering-platform"
              "offering-service"
              "picker-api"
              "playground"
              "product-catalog"
              "restaurant-api"
              "sre"
              "steiger"
              "wolt-aws-dev"
              "wolt-aws"
              "wolt-load-test"
              "wolt-protocol"
            ];
            trustedProjects = [
              "${config.home.homeDirectory}/dotfiles"
            ]
            ++ map (project: "${config.home.homeDirectory}/work/${project}") workProjects;
          in
          lib.genAttrs trustedProjects (_: {
            trust_level = "trusted";
          });

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
