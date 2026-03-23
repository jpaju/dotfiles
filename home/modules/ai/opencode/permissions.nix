{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings.permission = {
      edit = "ask";
      webfetch = "allow";
      bash = {
        "*" = "ask";
        "ls *" = "allow";
        "wc *" = "allow";
        "pwd" = "allow";
        "head *" = "allow";
        "tail *" = "allow";
        "grep *" = "allow";
        "rg *" = "allow";
        "jq *" = "allow";
        "sort *" = "allow";
        "sed *" = "allow";
        "awk *" = "allow";
        "date *" = "allow";
      }
      // {
        "git bisect bad *" = "allow";
        "git bisect good *" = "allow";
        "git blame *" = "allow";
        "git branch --all" = "allow";
        "git branch --list" = "allow";
        "git branch --remotes" = "allow";
        "git branch --show-current" = "allow";
        "git branch -a" = "allow";
        "git branch -r" = "allow";
        "git branch -v" = "allow";
        "git diff *" = "allow";
        "git log *" = "allow";
        "git merge-base *" = "allow";
        "git show *" = "allow";
        "git stash list *" = "allow";
        "git status *" = "allow";
      }
      // {
        "gh issue view *" = "allow";
        "gh search *" = "allow";
        "gh repo view *" = "allow";
        "gh pr list *" = "allow";
        "gh pr view *" = "allow";
        "gh pr diff *" = "allow";
        "gh pr checks *" = "allow";
        "gh run view *" = "allow";
        "gh run list *" = "allow";
        "gh run watch *" = "allow";
        "gh-discussion-search *" = "allow";
      };
    };
  };
}
