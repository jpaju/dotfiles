{ config, lib, ... }:
let
  cfg = config.dotfiles.ai.mcp;

  exportSecret = name: path: ''export ${name}="$(cat ${path})"'';
in
{
  imports = [
    ../../secrets/interface.nix
    ./servers
  ];

  options.dotfiles.ai.mcp = {
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

  config = lib.mkIf config.dotfiles.ai.enable {
    programs.mcp.enable = true;
  };
}
