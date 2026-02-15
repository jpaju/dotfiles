{ pkgs, ... }:
{
  imports = [ ./lazydocker.nix ];

  programs.fish.shellAbbrs = {
    dk = "docker";
    dkb = "docker build";

    dc = "docker compose";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcs = "docker compose stop";
    dce = "docker compose exec -it";
  };

  home.packages = [ pkgs.docker-language-server ];
}
