{ self, pkgs, system, username, ... }: {
  users.users.jaakkopaju.home = "/Users/${username}";

  nixpkgs.hostPlatform = system;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root ${username}" ];
  };

  nix.package = pkgs.nix;

  environment = {
    shells = [ pkgs.fish pkgs.zsh ];
    loginShell = pkgs.fish;
    systemPackages = [ pkgs.cowsay ];
  };

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    taps = [ "dashlane/tap" "pbkit/homebrew-tap" ];
    brews = [ "dashlane-cli" "clang-format" "pbkit" ];
    casks = let
      devTools = [ "dash" "docker" "jetbrains-toolbox" "postman" "visual-studio-code" ];
      terminal = [ "font-fira-code-nerd-font" "iterm2" ]; # TODO Handle fonts with nix-darwin
      windowManagement = [ "alt-tab" "monitorcontrol" "rectangle" ];
      productivity = [ "arc" "firefox" "google-chrome" "karabiner-elements" "notion" "numi" "signal" "spotify" ];
      misc = [ "aldente" "appcleaner" "bartender" "menubarx" "stats" ];
    in devTools ++ terminal ++ windowManagement ++ productivity ++ misc;
  };

  # Configure shells that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  services.nix-daemon.enable = true;
}
