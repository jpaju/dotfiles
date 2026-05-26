{
  config,
  lib,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.dotfiles.google.enable {
    home.packages = [ inputs.gws.packages.${system}.default ];
  };
}
