{ ... }:
{
  imports = [ ./common.nix ];

  dotfiles = {
    # Utilities
    _1password.enable = true;
    ai.enable = true;
    karabiner.enable = true;
    secrets.enable = true;
    terminal.enable = true;
    wolt-tools.enable = true;

    # Technologies
    aws.enable = true;
    docker.enable = true;
    github.enable = true;
    k8s.enable = true;
    kafka.enable = true;
    mongodb.enable = true;
    postgres.enable = true;
    protobuf.enable = true;

    # Programming languages
    go.enable = true;
    kotlin.enable = true;
    python.enable = true;
    scala.enable = true;
    terraform.enable = true;
    typescript.enable = true;
  };
}
