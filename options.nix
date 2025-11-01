{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    k8s.enable = lib.mkEnableOption "Kubernetes tools";
    scala.enable = lib.mkEnableOption "Scala tools";
  };
}
