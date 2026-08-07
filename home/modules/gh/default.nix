{ pkgs, ... }:
{
  imports = [
    ./gh-dash.nix
    ./tuicr
  ];

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-stack ];
  };

  programs.fish.shellAbbrs = {
    ghb = "gh browse";
    ghprc = "gh pr create --web";
    ghprv = "gh pr view --web";
    ghprm = "gh pr merge --squash --delete-branch";
    ghrw = "gh run watch";
    ghprs = "gh_pr_switch";
  };

  # GH CLI doesn't have support for discussions as of yet. For more information see
  #  - https://github.com/cli/cli/discussions/4212
  #  - https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions
  home.packages = [
    (pkgs.writeShellScriptBin "gh-branch-info" (builtins.readFile ./agent-tools/gh-branch-info.sh))
    (pkgs.writeShellScriptBin "gh-discussion-search" (builtins.readFile ./agent-tools/gh-discussion-search.sh))
    (pkgs.writeShellScriptBin "gh-pr-inline-comments" (builtins.readFile ./agent-tools/gh-pr-inline-comments.sh))
    (pkgs.writeShellScriptBin "gh-read-file" (builtins.readFile ./agent-tools/gh-read-file.sh))
    (pkgs.writeShellScriptBin "gh-ref-sha" (builtins.readFile ./agent-tools/gh-ref-sha.sh))
    (pkgs.writeShellScriptBin "gh-repo-tree" (builtins.readFile ./agent-tools/gh-repo-tree.sh))
  ];

  xdg.configFile = {
    "fish/functions/gh_pr_switch.fish".source = ./fish/gh_pr_switch.fish;
    "fish/functions/gh_browse.fish".source = ./fish/gh_browse.fish;
    "fish/completions/gh.fish".source = ./fish/gh-completions.fish;
  };
}
