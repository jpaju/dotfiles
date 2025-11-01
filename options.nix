{ lib, ... }:
{
  options.dotfiles = {
    kafka.enable = lib.mkEnableOption "Kafka tools";
    scala.enable = lib.mkEnableOption "Scala tools";
  };
}
