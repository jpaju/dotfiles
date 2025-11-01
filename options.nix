{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    k8s.enable = lib.mkEnableOption "Kubernetes tools";
    mqtt.enable = lib.mkEnableOption "MQTT tools";
    scala.enable = lib.mkEnableOption "Scala tools";
  };
}
