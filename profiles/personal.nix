{ username, ... }:
{
  imports = [ ./common.nix ];

  home-manager.users.${username} = {
    imports = [ ../home/common.nix ];
  };

  dotfiles = {
    # Utilities
    ai.enable = true;
    communication.enable = true;
    media.enable = true;
    remote-access.enable = true;

    # Technologies
    mqtt.enable = true;
    postgres.enable = true;

    # Programming languages
    elm.enable = true;
    rust.enable = true;
    scala.enable = true;
    terraform.enable = true;
    typescript.enable = true;
  };
}
