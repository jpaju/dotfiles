{ ... }: {
  home.file = {
    "flakes/go".source = ./go;
    "flakes/bun".source = ./bun;
    "flakes/npm".source = ./npm;
    "flakes/rust".source = ./rust;
    "flakes/scala".source = ./scala;
    "flakes/python".source = ./python;
  };
}
