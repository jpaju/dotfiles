{ ... }:
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

  xdg.configFile."fish/functions/gh_pr_switch.fish".source = ./gh_pr_switch.fish;
}
