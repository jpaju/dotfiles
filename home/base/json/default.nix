{ pkgs, ... }:
{
  programs.jq.enable = true;

  home.packages = with pkgs; [
    fx
    jqp
  ];

  home.file.".jqp.yaml".source = ./.jqp.yaml;
}
