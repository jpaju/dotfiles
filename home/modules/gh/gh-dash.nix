{ ... }:
{
  programs.fish.shellAbbrs.ghd = "gh dash";

  catppuccin.gh-dash.enable = true;
  programs.gh-dash = {
    enable = true;
    settings = {
      defaults.preview.open = true;
      defaults.preview.width = 80;
      pager.diff = "delta";

      prSections = [
        {
          title = "My PRs";
          filters = "is:pr is:open author:@me";
        }
        {
          title = "All PRs";
          filters = "is:pr is:open";
        }
        {
          title = "Review requested";
          filters = "is:pr is:open review-requested:@me";
        }
      ];
    };
  };
}
