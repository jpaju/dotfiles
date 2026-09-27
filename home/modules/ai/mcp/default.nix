{ config, lib, ... }:
let
  cfg = config.dotfiles.ai.mcp;

  exportSecret = name: path: ''export ${name}="$(cat ${path})"'';

  envReference = lib.types.submodule {
    options.env = lib.mkOption {
      type = lib.types.str;
      description = "Name of the environment variable holding the value";
    };
  };

  oauth = lib.types.submodule {
    options = {
      clientId = lib.mkOption {
        type = lib.types.str;
        description = "Pre-registered OAuth client ID";
      };

      callbackPort = lib.mkOption {
        type = lib.types.port;
        description = "Local port for the OAuth redirect callback";
      };

      scopes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "OAuth scopes to request";
      };
    };
  };

  server = lib.types.submodule {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
        description = "HTTP endpoint of the remote MCP server";
      };

      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the server is enabled by default";
      };

      headers = lib.mkOption {
        type = lib.types.attrsOf (lib.types.either lib.types.str envReference);
        default = { };
        example = lib.literalExpression ''
          { CONTEXT7_API_KEY = { env = "CONTEXT7_API_KEY"; }; }
        '';
        description = ''
          HTTP headers sent to the server.
          Each value is either a literal string or a reference to an environment variable.
        '';
      };

      bearerTokenEnv = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "ROOTLY_API_KEY";
        description = "Name of the environment variable holding a bearer token for the Authorization header";
      };

      oauth = lib.mkOption {
        type = lib.types.nullOr oauth;
        default = null;
        description = "Pre-registered OAuth client, for servers that don't support dynamic client registration";
      };
    };
  };
in
{
  imports = [
    ../../secrets/interface.nix
    ./servers
  ];

  options.dotfiles.ai.mcp = {
    servers = lib.mkOption {
      type = lib.types.attrsOf server;
      default = { };
      description = ''
        Remote MCP servers shared by all AI harnesses.
        Each harness module renders these into its own config format.
      '';
    };

    secretEnv = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        { CONTEXT7_API_KEY = config.secrets.context7_api_key; }
      '';
      description = ''
        Each MCP server module adds the secrets it needs to this option.
        All AI harnesses then pick up secrets automatically from the option.
        They are in format env var name -> secret file path.
      '';
    };

    secretEnvExports = lib.mkOption {
      type = lib.types.lines;
      readOnly = true;
      default = lib.concatLines (lib.mapAttrsToList exportSecret cfg.secretEnv);
      example = ''
        export CONTEXT7_API_KEY="$(cat /path/to/context7_api_key)"
      '';
      description = ''
        Derived from secretEnv, maps each secret to the exact shell export line.
        Each AI harness package includes these lines in its wrapper script.
      '';
    };
  };
}
