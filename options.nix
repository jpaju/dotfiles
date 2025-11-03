{ lib, ... }:
{
  options.dotfiles = {
    # Utilities
    ai.enable = lib.mkEnableOption "AI coding tools";
    communication.enable = lib.mkEnableOption "Communication apps";
    karabiner.enable = lib.mkEnableOption "Karabiner-Elements";
    media.enable = lib.mkEnableOption "Media apps";
    remote-access.enable = lib.mkEnableOption "Remote access tools";
    secrets.enable = lib.mkEnableOption "Secrets management (sops-nix)";
    terminal.enable = lib.mkEnableOption "Terminals";
    work-vpn.enable = lib.mkEnableOption "Work VPN";

    # Technologies
    aws.enable = lib.mkEnableOption "AWS tools";
    docker.enable = lib.mkEnableOption "Docker and container tools";
    github.enable = lib.mkEnableOption "GitHub CLI tools";
    k8s.enable = lib.mkEnableOption "Kubernetes tools";
    kafka.enable = lib.mkEnableOption "Kafka tools";
    mongodb.enable = lib.mkEnableOption "MongoDB tools";
    mqtt.enable = lib.mkEnableOption "MQTT tools";
    postgres.enable = lib.mkEnableOption "PostgreSQL tools";
    protobuf.enable = lib.mkEnableOption "Protobuf and gRPC tools";

    # Programming languages
    elm.enable = lib.mkEnableOption "Elm tools";
    go.enable = lib.mkEnableOption "Go tools";
    kotlin.enable = lib.mkEnableOption "Kotlin tools";
    python.enable = lib.mkEnableOption "Python tools";
    rust.enable = lib.mkEnableOption "Rust tools";
    scala.enable = lib.mkEnableOption "Scala tools";
    terraform.enable = lib.mkEnableOption "Terraform tools";
    typescript.enable = lib.mkEnableOption "TypeScript tools";
  };
}
