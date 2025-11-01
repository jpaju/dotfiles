{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.terraform.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
    ];

    programs.fish.shellAbbrs = {
      tf = "terraform";
      tfp = "terraform plan";
      tfa = "terraform apply";
      tfi = "terraform init";
      tfv = "terraform validate";
    };
  };
}
