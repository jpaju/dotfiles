{
  pkgs,
  sops-nix,
  userhome,
  config,
  lib,
  ...
}:
{
  imports = [ sops-nix.homeManagerModules.sops ];

  config = lib.mkIf config.dotfiles.secrets.enable {
    home.packages = [ pkgs.sops ];

    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "${userhome}/.config/sops/age/keys.txt";

      secrets = {
        copilot_api_key = { };
        anthropic_api_key = { };
        openai_api_key = { };
        google_generative_ai_api_key = { };
        context7_api_key = { };
      };
    };

    # Implement the secrets interface using sops-nix backend
    secrets = with config.sops; {
      anthropic_api_key = secrets.anthropic_api_key.path;
      copilot_api_key = secrets.copilot_api_key.path;
      openai_api_key = secrets.openai_api_key.path;
      google_generative_ai_api_key = secrets.google_generative_ai_api_key.path;
      context7_api_key = secrets.context7_api_key.path;
    };
  };
}
