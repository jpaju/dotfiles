{ pkgs-master, ... }: {
  programs = {
    git = {
      enable = true;

      delta.enable = true;
      delta.package = pkgs-master.delta;
    };

    lazygit.enable = true;

    fish.shellAbbrs = {
      ga = "git add";
      gaa = "git add --all";
      gap = "git add --patch";
      gb = "git branch";
      gba = "git branch --all";
      gbr = "git branch --remotes";
      gbd = "git branch --delete";
      gacm = "git add --all && git commit --message";
      gcm = "git commit --message";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gcl = "git clone";
      gco = "git checkout";
      gdc = "git diff --cached";
      gdf = "git diff";
      gf = "git fetch";
      gfp = "git fetch --prune";
      glp = "git localprune";
      gi = "git init";
      gl =
        "git log --graph --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold red)%s%C(reset) %C(blue)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      gm = "git merge";
      gmff = "git merge --ff-only";
      gms = "git maintenance start";
      gpl = "git pull";
      gplu = "git pull upstream";
      gps = "git push";
      gpsf = "git push --force-with-lease";
      grb = "git rebase";
      grbm = "git rebase (git_default_branch)";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbi = "git rebase --interactive";
      gr = "git reset";
      grh = "git reset --hard";
      grs = "git reset --soft";
      gra = "git remote add";
      grso = "git remote set-url origin";
      grup = "git remote add upstream";
      grv = "git remote -v";
      gsp = "git stash pop";
      gsu = "git stash --include-untracked --message";
      gs = "git status";
      gsw = "git switch";
      gswc = "git switch --create";
      gswm = "git switch (git_default_branch)";
      ggrep = "git log -p -G"; # Maybe try also 'git rev-list --all | xargs git grep' ?

      lg = "lazygit";
    };
  };

  home.file.".gitconfig".source = ./.gitconfig;
  # home.file.".catppuccin.gitconfig".source = ./.catppuccin.gitconfig;

  xdg.configFile = {
    "lazygit/config.yml".source = ./lazygit-config.yml;

    "fish/functions/git_default_branch.fish".source = ./git_default_branch.fish;
  };

}
