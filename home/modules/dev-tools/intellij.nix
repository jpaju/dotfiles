{ pkgs, ... }: {
  home.file.".ideavimrc".source = let
    rev = "cd495e540dd2736d5e39a686d787048070752fd4";
    file = "helix.idea.vim";
  in pkgs.fetchurl {
    hash = "sha256-ANAPvdvQMacUPCPNsvwCtCD/dWhVW+IWa010WjoZZ40=";
    url = "https://raw.githubusercontent.com/chtenb/helix.vim/${rev}/${file}";
  };
}
