# Custom packages passed to Home Manager as localPkgs.
{ pkgs, ... }:
{
  kotlin-lsp = pkgs.callPackage ./kotlin-lsp { };
  leaf = pkgs.callPackage ./leaf { };
}
