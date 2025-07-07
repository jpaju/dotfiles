{ pkgs, sops-nix, userhome, ... }: {
  imports = [ sops-nix.homeManagerModules.sops ];

  home.packages = [ pkgs.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${userhome}/.config/sops/age/keys.txt";

    secrets = {
      copilot_api_key = { };
      anthropic_api_key = { };
    };
  };
}
