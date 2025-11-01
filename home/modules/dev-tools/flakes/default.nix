{ ... }:
{
  home.file = {
    "flakes/bun".source = ./bun;
    "flakes/go".source = ./go;
    "flakes/kotlin".source = ./kotlin;
    "flakes/npm".source = ./npm;
    "flakes/rust".source = ./rust;
  };
}
