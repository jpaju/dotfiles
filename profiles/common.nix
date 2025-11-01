{
  username,
  userhome,
  system,
  nix-darwin,
  home-manager,
  sops-nix,
  helix,
  catppuccin,
  fishUtils,
  config,
  ...
}:
{
  imports = [
    home-manager.darwinModules.home-manager
    ../options.nix
    ../system/modules
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit
        userhome
        system
        nix-darwin
        sops-nix
        helix
        catppuccin
        fishUtils
        ;
    };

    users.${username} = {
      imports = [
        ../options.nix
        ../home/modules
      ];

      # Expose dotfiles options from system nix-darwin/nixOS to home-manager
      dotfiles = config.dotfiles;
    };
  };
}
