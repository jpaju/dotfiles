{ ... }:
{
  imports = [ ./common.nix ];

  dotfiles = {
    # Utilities
    _1password.enable = true;
    _3dprinting.enable = true;
    ai.enable = true;
    communication.enable = true;
    karabiner.enable = true;
    media.enable = true;
    remote-access.enable = true;
    secrets.enable = true;
    terminal.enable = true;

    # Technologies
    docker.enable = true;
    github.enable = true;
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
