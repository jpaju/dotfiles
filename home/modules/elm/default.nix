{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.elm.enable {
    home.packages = with pkgs; [
      elmPackages.elm-language-server
    ];
  };
}
