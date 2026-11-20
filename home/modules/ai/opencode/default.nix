{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../secrets/interface.nix
    ./permissions.nix
    ./plugins
  ];

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode = {
      enable = true;
      mutableSettings = true;

      context = lib.concatStringsSep "\n" [
        (builtins.readFile ../system-prompt.md)
        (builtins.readFile ./opencode-system-prompt.md)
      ];
      commands = config.dotfiles.ai.commands;

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
          wrappedOpencode = pkgs.writeShellScriptBin "opencode" ''
            export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
            export OPENAI_API_KEY="$(cat ${config.secrets.openai_api_key})"
            export GOOGLE_GENERATIVE_AI_API_KEY="$(cat ${config.secrets.google_generative_ai_api_key})"
            ${config.dotfiles.ai.mcp.secretEnvExports}

            exec ${pkgs.opencode}/bin/opencode "$@"
          '';
        in
        # Home Manager needs the version to recognize v2 CLI configuration support
        wrappedOpencode.overrideAttrs { inherit (pkgs.opencode) version; };
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
