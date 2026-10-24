{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  helixLanguages = builtins.fromTOML (builtins.readFile ../helix/languages.toml);
  languages = lib.recursiveUpdate helixLanguages {
    language-server.scls.environment.SNIPPETS_PATH = "${config.xdg.configHome}/helix/snippets";
    language = map (
      language:
      language
      // lib.optionalAttrs (language ? language-servers) {
        language-servers = map (
          server: if server == "eslint" then "vscode-eslint-language-server" else server
        ) language.language-servers;
      }
      // lib.optionalAttrs (language.name == "css") {
        formatter = language.formatter // {
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
    ) helixLanguages.language;
  };
in
{
  home.packages = [ inputs.mitos.packages.${system}.default ];

  xdg.configFile = {
    "mitos/config.toml".source = ./config.toml;
    "mitos/languages.toml".source = tomlFormat.generate "mitos-languages.toml" languages;
    "mitos/ignore".source = ../helix/ignore;
  };
}
