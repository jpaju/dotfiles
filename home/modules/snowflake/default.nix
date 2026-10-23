{
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  # Main nixpkgs has a newer Typer whose vendored Click is incompatible with
  # Snowflake CLI. Use stable nixpkgs to keep its Python dependencies compatible.
  snowflakePkgs = inputs.snowflake-nixpkgs.legacyPackages.${system};
in
{
  config = lib.mkIf config.dotfiles.snowflake.enable {
    home.packages = [
      (snowflakePkgs.snowflake-cli.overridePythonAttrs (old: {
        dependencies =
          old.dependencies ++ snowflakePkgs.python3Packages.snowflake-connector-python.optional-dependencies.secure-local-storage;
        doCheck = false; # skip long upstream test suite
      }))
    ];
  };
}
