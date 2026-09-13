{ lib, pkgs, ... }:
let
  buildDependencies = [
    pkgs.cargo
    pkgs.git
    pkgs.rustc
    pkgs.stdenv.cc
  ];
  herdrCLI = lib.getExe pkgs.herdr;
  jqCLI = lib.getExe pkgs.jq;
  tomlFormat = pkgs.formats.toml { };
in
{
  xdg.configFile."herdr/plugins/config/herdr.pane-name/config.toml" = {
    source = tomlFormat.generate "herdr-pane-name-config.toml" {
      max_length = 32;
      show_args = false;
      icons = true;
      prefixes = true;
      ignored_programs = [
        "opencode"
        ".opencode-wrapp"
      ];
    };
    onChange = ''
      ${herdrCLI} plugin action invoke herdr.pane-name.reset >/dev/null 2>&1 || true
      ${herdrCLI} plugin action invoke herdr.pane-name.sync >/dev/null 2>&1 || true
    '';
  };

  home.activation.installHerdrPaneName = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${herdrCLI} plugin list --plugin herdr.pane-name --json \
      | ${jqCLI} -e '.result.plugins | length > 0' >/dev/null; then
      export PATH=${lib.makeBinPath buildDependencies}:$PATH
      run ${herdrCLI} plugin install go-min/herdr-pane-name --yes
      run ${herdrCLI} plugin action invoke herdr.pane-name.sync
    fi
  '';
}
