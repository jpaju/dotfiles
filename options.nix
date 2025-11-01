{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    k8s.enable = lib.mkEnableOption "Kubernetes tools";
    mqtt.enable = lib.mkEnableOption "MQTT tools";
    python.enable = lib.mkEnableOption "Python tools";
    scala.enable = lib.mkEnableOption "Scala tools";
  };
}
