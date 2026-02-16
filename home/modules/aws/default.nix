{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.aws.enable {
    programs.granted.enable = true;

    home.packages = with pkgs; [
      aws-vault
      awscli2
    ];
  };
}
