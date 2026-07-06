{ ... }:
{
  imports = [ ./common.nix ];

  dotfiles = {
    browsers = [
      "firefox"
      "google-chrome"
      "zen"
    ];

    # Utilities
    _1password.enable = true;
    ai.enable = true;
    communication.enable = true;
    google.enable = true;
    homelab.enable = true;
    karabiner.enable = true;
    media.enable = true;
    network-tools.enable = true;
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
    java.enable = true;
    python.enable = true;
    rust.enable = true;
    scala.enable = true;
    terraform.enable = true;
    typescript.enable = true;

    # 3D printing
    _3dprinting.slicers.enable = true;
    _3dprinting.cad.enable = true;
  };
}
