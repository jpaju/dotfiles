{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [
    ../../secrets/interface.nix
    ./permissions.nix
    ./plugins
    ./skills.nix
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode = {
      enable = true;
      mutableSettings = true;

      context = ./system-prompt.md;
      commands = ./commands;

      settings = {
        share = "disabled";
        autoupdate = false;
        default_agent = "plan";
        websearch.provider = "exa";
        policies = [
          {
            action = "integration.use";
            resource = "plugin:*";
            effect = "deny";
          }
        ];
      };

      cli = {
        theme.name = "catppuccin";
        animations = true;
        session = {
          scrollbar = true;
          verbosity = "medium";
          grouping = "none";
        };
        tabs = {
          mode = "on";
          scope = "cwd";
          layout = "horizontal";
        };
        attention = {
          notifications = false;
          sound = false;
        };
      };

      package =
        let
          version = inputs.llm-agents.packages.${system}.opencode2.version;
          wrapper = pkgs.writeShellScriptBin "opencode" ''
            export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
            export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
            export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
            ${config.dotfiles.ai.mcp.secretEnvExports}

            exec ${inputs.llm-agents.packages.${system}.opencode2}/bin/opencode2 "$@"
          '';
        in
        # Home Manager needs the version to recognize v2 CLI configuration support
        wrapper // { version = version; };
    };

    programs.fish.shellAbbrs = {
      oc = "opencode";
      occ = "opencode --continue";
    };

    programs.opencode.settings.mcp =
      let
        envReference = name: "{env:${name}}";

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
            inherit (oauthClient) clientId;
            redirectUri = "http://localhost:${toString oauthClient.callbackPort}/callback";
          }
          // lib.optionalAttrs (oauthClient.scopes != [ ]) {
            scope = lib.concatStringsSep "," oauthClient.scopes;
          };

        toOpencodeMcpServer =
          _: server:
          {
            type = "remote";
            inherit (server) url enabled;
          }
          // lib.optionalAttrs (headers server != { }) { headers = headers server; }
          // lib.optionalAttrs (server.oauth != null) { oauth = oauth server.oauth; }
          // lib.optionalAttrs (server.bearerTokenEnv != null) { oauth = false; };
      in
      lib.mapAttrs toOpencodeMcpServer config.dotfiles.ai.mcp.servers;
  };
}
