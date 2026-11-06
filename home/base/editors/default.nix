{ pkgs, ... }:
{
  imports = [
    ./helix
    ./mitos
  ];

  xdg.configFile = {
    "fish/functions/open_popup.fish".source = ./functions/open_popup.fish;
    "fish/functions/yazi_picker.fish".source = ./functions/yazi_picker.fish;
    "fish/functions/broot_picker.fish".source = ./functions/broot_picker.fish;
    "fish/functions/open_paths_in_editor.fish".source = ./functions/open_paths_in_editor.fish;
    "broot/editor-picker.hjson".source = ./functions/broot-picker.hjson;
  };

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
