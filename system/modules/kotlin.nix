{ config, lib, ... }:
{
  config = lib.mkIf config.dotfiles.kotlin.enable {
    homebrew.brews = [ "JetBrains/utils/kotlin-lsp" ];
  };
}
