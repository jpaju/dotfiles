{ pkgs, ... }:
{
  programs.gh.enable = true;

  programs.fish.shellAbbrs = {
    ghb = "gh browse";
    ghprc = "gh pr create --web";
    ghprv = "gh pr view --web";
    ghprm = "gh pr merge --squash --delete-branch";
    ghrw = "gh run watch";
    ghprs = "gh_pr_switch";

    ghd = "gh dash";
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      defaults.preview.open = true;
      defaults.preview.width = 80;
      pager.diff = "delta";
    };
  };
  catppuccin.gh-dash.enable = true;

  # GH CLI doesn't have support for discussions as of yet. For more information see
  #  - https://github.com/cli/cli/discussions/4212
  #  - https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions
  home.packages = [
    (pkgs.writeShellScriptBin "gh-discussion-search" (builtins.readFile ./gh-discussion-search.sh))
  ];

  xdg.configFile."fish/functions/gh_pr_switch.fish".source = ./gh_pr_switch.fish;
}
