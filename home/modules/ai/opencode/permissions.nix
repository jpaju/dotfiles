{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.settings = {

      # Explore denies unlisted tools by default, so skill loading needs an explicit opt-in.
      agent.explore.permission.skill = "allow";

      permission = {
        edit = "allow";
        webfetch = "allow";
        websearch = "allow";

        read = {
          "*.jks" = "deny";
          "*.key" = "deny";
          "*.p12" = "deny";
          "*.pem" = "deny";
          "*.pfx" = "deny";
          "*_dsa" = "deny";
          "*_ecdsa" = "deny";
          "*_ed25519" = "deny";
          "*_rsa" = "deny";
        }
        // {
          "~/.config/sops/age/*" = "deny";
          "~/.gradle/gradle.properties" = "deny";
          "~/.gnupg/private-keys-v1.d/*" = "deny";
          "~/.local/share/atuin/*" = "deny";
          "~/.local/share/fish/fish_history" = "deny";
          "~/.sbt/.credentials" = "deny";
          "~/.ssh/id_*" = "deny";
        };

        bash = {
          "*" = "ask";
          "ls *" = "allow";
          "wc *" = "allow";
          "nl *" = "allow";
          "man *" = "allow";
          "pwd" = "allow";
          "cat" = "allow";
          "echo *" = "allow";
          "diff *" = "allow";
          "printf *" = "allow";
          "date *" = "allow";
          "stat *" = "allow";
          "type *" = "allow";
          "file *" = "allow";
          "which *" = "allow";
          "strings *" = "allow";
          "readlink *" = "allow";
          "hostname *" = "allow";
          "command -v *" = "allow";
        }
        // {
          "head *" = "allow";
          "tail *" = "allow";
          "less *" = "allow";
          "sort *" = "allow";
          "uniq *" = "allow";
          "grep *" = "allow";
          "pgrep *" = "allow";
          "rg *" = "allow";
          "jq *" = "allow";
          "yq *" = "allow";
          "tr *" = "allow";
          "sed *" = "allow";
          "awk *" = "allow";
        }
        // {
          "nix --version" = "allow";
          "nix fmt *" = "allow";
          "nix help *" = "allow";
          "nix search *" = "allow";
          "nix log *" = "allow";
          "nix flake check --no-build" = "allow";
          "nix flake info *" = "allow";
          "nix flake show *" = "allow";
          "nix flake metadata *" = "allow";
          "nix derivation show *" = "allow";
          "nix profile list *" = "allow";
          "nix profile history *" = "allow";
          "nix store ls *" = "allow";
          "nix store cat *" = "allow";
          "nix store info *" = "allow";
          "nix config show *" = "allow";
        }
        // {
          "brew config *" = "allow";
          "brew formulae *" = "allow";
          "brew desc *" = "allow";
          "brew doctor *" = "allow";
          "brew info *" = "allow";
          "brew leaves *" = "allow";
          "brew log *" = "allow";
          "brew list *" = "allow";
          "brew ls *" = "allow";
          "brew options *" = "allow";
          "brew outdated *" = "allow";
          "brew search *" = "allow";
          "brew tap-info *" = "allow";
          "brew uses *" = "allow";
          "brew which-formula *" = "allow";
        }
        // {
          "git bisect bad *" = "allow";
          "git bisect good *" = "allow";
          "git blame *" = "allow";
          "git branch" = "allow";
          "git branch --all *" = "allow";
          "git branch --list *" = "allow";
          "git branch --remotes" = "allow";
          "git branch --show-current" = "allow";
          "git branch -a" = "allow";
          "git branch -r" = "allow";
          "git branch -v" = "allow";
          "git branch -vv" = "allow";
          "git cat-file *" = "allow";
          "git check-ignore *" = "allow";
          "git config --get *" = "allow";
          "git cherry *" = "allow";
          "git grep *" = "allow";
          "git diff *" = "allow";
          "git log *" = "allow";
          "git merge-base *" = "allow";
          "git show *" = "allow";
          "git show-ref *" = "allow";
          "git stash list *" = "allow";
          "git stash show *" = "allow";
          "git status *" = "allow";
          "git range-diff *" = "allow";
          "git reflog show *" = "allow";
          "git remote -v" = "allow";
          "git remote show *" = "allow";
          "git rev-list *" = "allow";
          "git rev-parse *" = "allow";
          "git ls-files *" = "allow";
          "git ls-tree *" = "allow";
          "git ls-remote *" = "allow";
          "git hash-object *" = "allow";
          "git --version" = "allow";
        }
        // {
          "gh help *" = "allow";
          "gh api user" = "allow";
          "gh auth status" = "allow";
          "gh issue list *" = "allow";
          "gh issue status *" = "allow";
          "gh issue view *" = "allow";
          "gh label list *" = "allow";
          "gh org list *" = "allow";
          "gh pr checks *" = "allow";
          "gh pr diff *" = "allow";
          "gh pr list *" = "allow";
          "gh pr status *" = "allow";
          "gh pr view *" = "allow";
          "gh release list *" = "allow";
          "gh release view *" = "allow";
          "gh repo list *" = "allow";
          "gh repo view *" = "allow";
          "gh run list *" = "allow";
          "gh run view *" = "allow";
          "gh run watch *" = "allow";
          "gh search *" = "allow";
          "gh version *" = "allow";
          "gh workflow list *" = "allow";
          "gh workflow view *" = "allow";
          "gh-branch-info *" = "allow";
          "gh-discussion-search *" = "allow";
          "gh-pr-inline-comments *" = "allow";
          "gh-read-file *" = "allow";
          "gh-ref-sha *" = "allow";
          "gh-repo-tree *" = "allow";
        }
        // {
          "docker container ls *" = "allow";
          "docker image ls *" = "allow";
          "docker images *" = "allow";
          "docker info *" = "allow";
          "docker ps *" = "allow";
          "docker search *" = "allow";
          "docker version *" = "allow";
        }
        // {
          "kubectl get *" = "allow";
          "kubectl describe *" = "allow";
          "kubectl events *" = "allow";
          "kubectl explain *" = "allow";
          "kubectl version *" = "allow";
          "kubectl rollout status *" = "allow";
          "kubectl rollout history *" = "allow";
          "kubectl auth can-i *" = "allow";
          "kubectl config current-context *" = "allow";
          "kubectl config get-contexts *" = "allow";
        }
        // {
          "./gradlew compileKotlin" = "allow";
          "./gradlew compileTestKotlin" = "allow";
          "./gradlew test" = "allow";
          "./gradlew test --tests *" = "allow";
          "./gradlew detekt" = "allow";
          "./gradlew ktlintCheck" = "allow";
          "./gradlew ktlintFormat" = "allow";
        }
        // {
          "gws schema *" = "allow";
          "gws gmail +triage" = "allow";
          "gws docs documents get *" = "allow";
          "gws calendar +agenda" = "allow";
          "gws calendar events list *" = "allow";
          "gws people people searchDirectoryPeople *" = "allow";
          "gws meet conferenceRecords list *" = "allow";
          "gws meet conferenceRecords participants list *" = "allow";
        }
        // {
          "snow sql --query *" = "allow";
          "snow sql -q *" = "allow";
        }
        // {
          "nm *" = "allow";
          "objdump *" = "allow";
          "shasum *" = "allow";
        };
      };
    };
  };
}
