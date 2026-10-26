{ pkgs, ... }:
{
  imports = [
    ./helix
    ./mitos
  ];

  # TODO Share helper scripts ownership instead of installing them through Helix

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "$EDITOR";
  };

  home.packages = with pkgs; [
    actions-languageserver # GitHub actions
    simple-completion-language-server # Snippets
    typos-lsp # Spellchecking
    fish-lsp # Fish
    bash-language-server # Bash
    marksman # Markdown
    mpls # Markdown preview
    nixd # Nix
    nixfmt # Nix
    taplo # TOML
    vscode-langservers-extracted # JSON, HTML, CSS, SCSS
    yaml-language-server # YAML
    prettier # JS, TS, HTML, CSS, YAML, Markdown
    lua-language-server # Lua
    zizmor # GitHub actions static analysis
  ];
}
