{ ... }:
{
  home.file = {
    "flakes/go".source = ./go;
    "flakes/kotlin".source = ./kotlin;
    "flakes/rust".source = ./rust;
  };
}
