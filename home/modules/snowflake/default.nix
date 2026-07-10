{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dotfiles.snowflake.enable {
    home.packages = with pkgs; [
      (snowflake-cli.overridePythonAttrs (old: {
        dependencies =
          old.dependencies ++ python3Packages.snowflake-connector-python.optional-dependencies.secure-local-storage;
        doCheck = false; # skip long upstream test suite
      }))
    ];
  };
}
