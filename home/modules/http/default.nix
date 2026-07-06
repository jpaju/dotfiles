{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.http.enable {
    home.packages = with pkgs; [
      httpie
      posting
    ];
  };
}
