{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    mqtt.enable = lib.mkEnableOption "MQTT tools";

    k8s.enable = lib.mkEnableOption "Kubernetes tools";

    go.enable = lib.mkEnableOption "Go tools";
    python.enable = lib.mkEnableOption "Python tools";
    scala.enable = lib.mkEnableOption "Scala tools";
    typescript.enable = lib.mkEnableOption "TypeScript tools";
  };
}
