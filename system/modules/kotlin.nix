{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.kotlin.enable {
    homebrew.casks = [ "kotlin-lsp" ];
  };
}
