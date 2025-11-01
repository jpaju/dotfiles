{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.aws.enable {
    home.packages = with pkgs; [
      aws-iam-authenticator
      aws-vault
      awscli2
    ];
  };
}
