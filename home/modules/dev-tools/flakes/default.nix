{ ... }:
{
  home.file = {
    "flakes/bun".source = ./bun;
    "flakes/go".source = ./go;
    "flakes/kotlin".source = ./kotlin;
    "flakes/npm".source = ./npm;
    "flakes/python".source = ./python;
    "flakes/rust".source = ./rust;
  };
}
