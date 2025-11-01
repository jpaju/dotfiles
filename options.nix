{ lib, ... }:
{
  options.dotfiles = {
    # Utilities
    communication.enable = lib.mkEnableOption "Communication apps";
    media.enable = lib.mkEnableOption "Media apps";
    remote-access.enable = lib.mkEnableOption "Remote access tools";
    work-vpn.enable = lib.mkEnableOption "Work VPN";

    # Technologies
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
