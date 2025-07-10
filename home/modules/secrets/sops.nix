{ pkgs, sops-nix, userhome, config, ... }: {
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

  # Implement the secrets interface using sops-nix backend
  secrets = {
    anthropic_api_key = config.sops.secrets.anthropic_api_key.path;
    copilot_api_key = config.sops.secrets.copilot_api_key.path;
  };
}
