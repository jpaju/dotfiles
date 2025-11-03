{ homeStateVersion, ... }:
{
  home.stateVersion = homeStateVersion;

  imports = [
    ./base
    ./modules
  ];
}
