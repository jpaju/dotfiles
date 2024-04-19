{ pkgs, ... }: {

  imports = [ ./fzf ./eza ];

  programs = {
    atuin = {
      enable = true;
      enableFishIntegration = true;
      flags = [ "--disable-up-arrow" ];
    };

    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    jq.enable = true;

    ripgrep.enable = true;

    yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  home.packages = with pkgs; [

    curlie
    fx
    gping
    gum
    iperf3
    jqp
    ncdu
    nix-your-shell
    tldr

  ];

  home.file.".jqp.yaml".source = ./.jqp.yaml;
}

