{ pkgs, ... }:
{
  home.packages = [ pkgs.terraform ];

  programs.fish.shellAbbrs = {
    tf = "terraform";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfi = "terraform init";
    tfv = "terraform validate";
  };
}
