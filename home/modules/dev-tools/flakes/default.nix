{ ... }:
{
  home.file = {
    "flakes/kotlin".source = ./kotlin;
    "flakes/rust".source = ./rust;
  };
}
