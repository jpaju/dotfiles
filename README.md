# Dotfiles

This is my personal dotfiles repository. The files are managed with [nix-darwin]() and [home-manager]().

## Fresh install

1. Make sure username is `jaakkopaju`
2. Change hostname to `Jaakkos-MacBook-Pro` for personal use, or `Wolt-MacBook-Pro` for work use
3. Install [Determinate Nix](https://determinate.systems/nix/)
4. Clone dotfiles repo to `~/.dotfiles
   ```bash
   nix run nixpkgs#git clone https://github.com/jpaju/dotfiles.git ~/dotfiles
   ```
5. Install nix-darwin

   ```bash
   sudo nix run nix-darwin -- switch --flake ~/dotfiles \
     --option extra-substituters "https://nix-community.cachix.org https://helix.cachix.org" \
     --option extra-trusted-public-keys "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
   ```

6. Configure sops-nix to manage secrets by configuring the private key.
   The private key must be placed in `~/.config/sops/age/keys.txt` file .
   If nix has already installed packages, the secret can be configured with 1password CLI by running the following command:

   ```bash
   mkdir -p ~/.config/sops/age/
   op item get "sops-nix age private key" --fields password --reveal >> ~/.config/sops/age/keys.txt
   ```

## Manual steps

### Spotlight indexing

Exclude these folders from spotlight indexing, see [instructions](https://support.apple.com/en-gb/guide/mac-help/mchl1bb43b84/mac)

- `~/.cache`
- `~/.cargo`
- `~/.claude`
- `~/.gradle`
- `~/.ivy2`
- `~/.npm`
- `~/.pyenv`
- `~/.sbt`
- `~/Dev`
- `~/cache`
- `~/dotfiles`
- `~/go`
- `~/tldr`
- `~/work`

### System Settings

- Display scaling: set preferred resolution
- Wallpaper: choose desktop background
- Desktop widgets: add and arrange widgets on desktop
- iCloud Drive: enable in Finder sidebar
- Dock icons: pin and order apps in the Dock <!-- TODO: configure via nix-darwin `system.defaults.dock` -->

### Apps

Most apps just need to be opened once to grant required permissions. Items with extra notes are listed below.

- Raycast
  - Configure settings
  - Install extensions
- Karabiner Elements
- Rectangle
  - TODO: figure out settings import/export ([reference](https://github.com/rxhanson/rectangle#import--export-json-config))
- AlDente
  - Configure menu bar icon
  - Configure hover behavior
- Calendar
  - Add Google account
  - Add Work account
- Calendr
- 1Password
  - Install browser extensions
  - Enable CLI integration
- Zen
  - Set as default browser
- Notion
- Logi Options+
  - Restore settings from backup
- AltTab
- Stats
  - TODO: figure out settings import/export ([issue](https://github.com/exelban/stats/issues/801), [example script](https://github.com/jody-frankowski/dotfiles/blob/179956774ca939b974dd839d17b202b09ecc9578/install.sh#L151))
- MenubarX
- VS Code
  - Sign in and enable Settings Sync
