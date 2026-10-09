{
  inputs,
  username,
  userhome,
  system,
  homeStateVersion,
  fishUtils,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../options.nix
    ../system
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    extraSpecialArgs = {
      localPkgs = import ../packages { inherit pkgs; };

      inherit
        system
        inputs
        homeStateVersion
        userhome
        fishUtils
        ;
    };

    users.${username} = {
      imports = [
        ../options.nix
        ../home
      ];

      # Copy app creates to stable paths instead of nix store symlinks
      # This helps with pinning apps to dock and discovering from spotlight
      # https://nix-community.github.io/home-manager/options.xhtml#opt-targets.darwin.copyApps.enable
      targets.darwin = {
        linkApps.enable = false;
        copyApps.enable = true;
      };

      # Expose dotfiles options from system nix-darwin/nixOS to home-manager
      dotfiles = config.dotfiles;
    };
  };
}
