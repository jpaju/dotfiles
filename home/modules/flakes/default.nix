{ ... }: {
  home.file = {
    "flakes/rust".source = ./rust;
    "flakes/typescript".source = ./typescript;
    "flakes/python".source = ./python;
  };
}
