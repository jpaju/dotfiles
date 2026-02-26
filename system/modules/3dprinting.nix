{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles._3dprinting.enable {
    homebrew.casks = [
      "ultimaker-cura"
    ];
  };
}
