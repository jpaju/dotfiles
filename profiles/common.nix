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

      # Expose dotfiles options from system nix-darwin/nixOS to home-manager
      dotfiles = config.dotfiles;
    };
  };
}
