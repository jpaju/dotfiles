{ pkgs, config, ... }: {
  imports = [ ../../secrets/interface.nix ];

  programs.opencode = {
    enable = true;

    package = pkgs.writeShellScriptBin "opencode" ''
      export ANTHROPIC_API_KEY="$(cat ${config.secrets.anthropic_api_key})"
      exec ${pkgs.opencode}/bin/opencode "$@"
    '';

    settings = {
      autoshare = false;
      autoupdate = true;
      theme = "tokyonight";
    };
  };

  programs.fish.shellAbbrs.oc = "opencode";
}
