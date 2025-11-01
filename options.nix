{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    mqtt.enable = lib.mkEnableOption "MQTT tools";

    k8s.enable = lib.mkEnableOption "Kubernetes tools";

    go.enable = lib.mkEnableOption "Go tools";
    postgres.enable = lib.mkEnableOption "PostgreSQL tools";
    protobuf.enable = lib.mkEnableOption "Protobuf and gRPC tools";
    python.enable = lib.mkEnableOption "Python tools";
    rust.enable = lib.mkEnableOption "Rust tools";
    scala.enable = lib.mkEnableOption "Scala tools";
    terraform.enable = lib.mkEnableOption "Terraform tools";
    typescript.enable = lib.mkEnableOption "TypeScript tools";
  };
}
