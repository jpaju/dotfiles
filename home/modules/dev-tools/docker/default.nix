{  lib, ... }: {
  programs.fish.shellAbbrs = {
    dk = "docker";
    dkb = "docker build";

    dc = "docker compose";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcs = "docker compose stop";
    dce = "docker compose exec -it";

    ld = "lazydocker";
  };

  programs.lazydocker = { enable = true; };

  xdg.configFile."lazydocker/config.yml".source = lib.mkForce ./lazydocker-config.yaml;
}
