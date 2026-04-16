{
  config,
  lib,
  gws,
  ...
}:
{
  config = lib.mkIf config.dotfiles.google.enable {
    home.packages = [ gws ];
  };
}
