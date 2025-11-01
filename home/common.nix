{ pkgs, ... }:
{
  home.stateVersion = "23.11";

  home.packages = [ pkgs._1password-cli ];

  imports = [
    ./modules/karabiner
    ./modules/secrets
    ./modules/terminal
  ];
}
