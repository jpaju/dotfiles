{ ... }:
{
  imports = [
    ./communication.nix
    ./kafka.nix
    ./kotlin.nix
    ./media.nix
    ./mongodb.nix
    ./remote-access.nix
    ./work-vpn.nix
  ];
}
