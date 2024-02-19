{ pkgs, ... }: {

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

    eza = {
      enable = true;
      icons = true;
      git = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
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
    fd
    fx
    gping
    iperf3
    jqp
    ncdu
    nix-your-shell
    tldr
  ];

  home.file.".jqp.yaml".source = ./.jqp.yaml;
}

