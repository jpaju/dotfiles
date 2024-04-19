{ pkgs, ... }: {
  programs.jq.enable = true;

  home.packages = [ pkgs.jqp ];
  home.file.".jqp.yaml".source = ./.jqp.yaml;
}
