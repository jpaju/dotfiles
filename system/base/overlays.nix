{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyFinal: pyPrev: {
          # Upstream test suite fails when built as root: a permission-check
          # test (test_log_debug_config_file_parent_dir_permissions) expects
          # a PermissionError that root never hits. Tests run in
          # installCheckPhase (pyproject build), gated by doInstallCheck,
          # not doCheck.
          snowflake-connector-python = pyPrev.snowflake-connector-python.overrideAttrs (old: {
            doCheck = false;
            doInstallCheck = false;

            # setup.py adds boto3/botocore to install_requires unless this is
            # set, which disagrees with nixpkgs's default.nix (which only
            # lists them under optional-dependencies.boto) and trips
            # pythonRuntimeDepsCheckHook.
            SNOWFLAKE_NO_BOTO = "1";
          });
        })
      ];
    })
  ];
}
