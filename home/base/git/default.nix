{ ... }:
{
  imports = [
    ./delta.nix
    ./lazygit.nix
  ];

  programs.git.enable = true;

  home.file.".gitconfig".source = ./.gitconfig;

  xdg.configFile = {
    "fish/functions/git_default_branch.fish".source = ./git_default_branch.fish;
    "fish/functions/git_wt_rename.fish".source = ./git_wt_rename.fish;
  };

  programs.fish.shellAbbrs = {
    ga = "git add";
    gaa = "git add --all";
    gb = "git branch";
    gacm = "git add --all && git commit --message";
    gcm = "git commit --message";
    gca = "git commit --amend";
    gcl = "git clone";
    gco = "git checkout";
    gdf = "git diff";
    gf = "git fetch";
    glp = "git localprune";
    gi = "git init";
    gl = "git log --graph --all --pretty=log";
    gm = "git merge";
    gpl = "git pull";
    gps = "git push";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase --interactive";
    gra = "git remote add";
    grv = "git remote -v";
    gs = "git status";
    gsw = "git switch";
    gswc = "git switch --create";
    gswm = "git switch (git_default_branch)";
    ggrep = "git log -p -G"; # Maybe try also 'git rev-list --all | xargs git grep' ?
    gwtr = "git_wt_rename";
  };
}
