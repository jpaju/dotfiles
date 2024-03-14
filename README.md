# Dotfiles

This is my personal dotfiles repository. The files are managed with [nix-darwin]() and [home-manager]().

## Fresh install

1. Make sure username is `jaakkopaju`
2. Change hostname to `Jaakkos-MacBook-Pro` for personal use, or `Wolt-MacBook-Pro` for work use
3. Install [Nix](https://nixos.org)
4. Install [homebrew](https://brew.sh)
5. Clone dotfiles repo to `~/.dotfiles
   ```bash
   nix run nixpkgs#git clone https://github.com/jpaju/dotfiles.git ~/dotfiles
   ```
6. Install nix-darwin
   ```bash
   nix run nix-darwin -- switch --flake ~/dotfiles
   ```
7. Configure sops-nix to manage secrets by configuring the private key.
   The private key must be placed in `~/.config/sops/age/keys.txt` file .
   If nix has already installed packages, the secret can be configured with Dashlane CLI (dcli) by running the
   following command:

   ```bash
   mkdir -p ~/.config/sops/age/
   dcli read "dl://sops-nix age private key/password" >> ~/.config/sops/age/keys.txt
   ```

8. Configure iTerm2

   - [Load preferences from custom URL](https://iterm2.com/documentation-preferences-general.html): `~/.config/iterm2/com.googlecode.iterm2.plist`
   - Set up fish [shell integration](https://iterm2.com/documentation-shell-integration.html)
