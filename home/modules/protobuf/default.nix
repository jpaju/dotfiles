{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.protobuf.enable {
    home.packages = with pkgs; [
      protobuf
      protols
      evans # gRPC TUI
      grpcurl # gRPC CLI
    ];
  };
}
