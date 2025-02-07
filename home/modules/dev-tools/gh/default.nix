{ pkgs, ... }: {
  programs = {

    gh = {
      enable = true;
      extensions = [ pkgs.gh-markdown-preview ];
    };

    fish.shellAbbrs = {
      ghb = "gh browse";
      ghprc = "gh pr create --web";
      ghprv = "gh pr view --web";
      ghprm = "gh pr merge --squash --delete-branch";
      ghrw = "gh run watch";
      ghprs = "gh_pr_switch";
    };
  };

  xdg.configFile."fish/functions/gh_pr_switch.fish".source = ./gh_pr_switch.fish;

}
