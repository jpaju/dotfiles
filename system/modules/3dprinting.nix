{ config, lib, ... }:
{
  config = lib.mkMerge [
    (lib.mkIf config.dotfiles._3dprinting.slicers.enable {
      homebrew.casks = [
        "ultimaker-cura"
        "orcaslicer"
      ];
    })
    (lib.mkIf config.dotfiles._3dprinting.cad.enable {
      homebrew.casks = [
        "autodesk-fusion"
      ];
    })
  ];
}
