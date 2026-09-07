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

        external_directory = lib.optionalAttrs config.dotfiles.gradle.enable {
          "~/.gradle/caches/modules-2/files-2.1/**" = "allow";
        };

        bash = {
          "*" = "ask";
        }
        // {
          # Shell and commands
          "man *" = "allow";
          "pwd" = "allow";
          "type *" = "allow";
          "test *" = "allow";
          "which *" = "allow";
          "command -v *" = "allow";
        }
        // {
          # System and processes
          "date" = "allow";
          "uname *" = "allow";
          "whoami" = "allow";
          "id *" = "allow";
          "uptime" = "allow";
          "ps *" = "allow";
          "pgrep *" = "allow";
          "sw_vers *" = "allow";
          "hostname" = "allow";
        }
        // {
          # Viewing and comparison
          "cat *" = "allow";
          "nl *" = "allow";
          "head *" = "allow";
          "tail *" = "allow";
          "less *" = "allow";
          "diff *" = "allow";
          "delta" = "allow";
          "delta -- *" = "allow";
          "cmp *" = "allow";
        }
        // {
          # Filesystem and paths
          "ls *" = "allow";
          "mdls *" = "allow";
          "stat *" = "allow";
          "file *" = "allow";
          "readlink *" = "allow";
          "basename *" = "allow";
          "dirname *" = "allow";
          "realpath *" = "allow";
          "du *" = "allow";
          "df *" = "allow";
        }
        // {
          # Text processing
          "echo *" = "allow";
          "printf *" = "allow";
          "wc *" = "allow";
          "cut *" = "allow";
          "col *" = "allow";
          "comm *" = "allow";
          "paste *" = "allow";
          "join *" = "allow";
          "fold *" = "allow";
          "rev *" = "allow";
          "expand *" = "allow";
          "unexpand *" = "allow";
          "column *" = "allow";
          "seq *" = "allow";
          "sort *" = "allow";
          "uniq *" = "allow";
          "tr *" = "allow";
          "sed *" = "allow";
          "awk *" = "allow";
        }
        // {
          # Search
          "fd" = "allow";
          "fd -- *" = "allow";
          "grep *" = "allow";
          "rg *" = "allow";
        }
        // {
          # Structured data
          "jq *" = "allow";
          "yq *" = "allow";
          "xmllint --version" = "allow";
          "xmllint -- *" = "allow";
          "xmllint --format -- *" = "allow";
          "xmllint --noout -- *" = "allow";
        }
        // {
          # Binary, archive etc.
          "strings *" = "allow";
          "nm *" = "allow";
          "od *" = "allow";
          "objdump *" = "allow";
          "hexdump *" = "allow";
          "cksum *" = "allow";
          "shasum *" = "allow";
          "unzip -l *" = "allow";
          "unzip -p *" = "allow";
          "unzip -t *" = "allow";
        }
        // {
          # MacOS specific
          "defaults domains" = "allow";
          "defaults find *" = "allow";
          "defaults help" = "allow";
          "defaults read *" = "allow";
          "defaults read-type *" = "allow";
          "plutil -p *" = "allow";
          "log show *" = "allow";
        }
        // {
          "nix --version" = "allow";
          "nix eval --read-only --no-write-lock-file -- *" = "allow";
          "nixfmt *" = "allow";
          "nix fmt *" = "allow";
          "nix help *" = "allow";
          "nix search *" = "allow";
          "nix log *" = "allow";
          "nix flake check --no-build" = "allow";
          "nix flake info *" = "allow";
          "nix flake show *" = "allow";
          "nix flake metadata *" = "allow";
          "nix derivation show *" = "allow";
          "nix path-info --read-only --no-write-lock-file -- *" = "allow";
          "nix profile list *" = "allow";
          "nix profile history *" = "allow";
          "nix registry list *" = "allow";
          "nix store diff-closures -- *" = "allow";
          "nix store ls *" = "allow";
          "nix store cat *" = "allow";
          "nix store info *" = "allow";
          "nix config show *" = "allow";
          "nix why-depends --read-only --no-write-lock-file -- *" = "allow";
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
          "git blame *" = "allow";
          "git branch" = "allow";
          "git branch --all" = "allow";
          "git branch --contains *" = "allow";
          "git branch --list" = "allow";
          "git branch --list -- *" = "allow";
          "git branch --remotes" = "allow";
          "git branch --show-current" = "allow";
          "git branch -a" = "allow";
          "git branch -r" = "allow";
          "git branch -v" = "allow";
          "git branch -vv" = "allow";
          "git cat-file *" = "allow";
          "git check-ignore *" = "allow";
          "git config --get *" = "allow";
          "git config get *" = "allow";
          "git config list *" = "allow";
          "git cherry *" = "allow";
          "git count-objects *" = "allow";
          "git describe *" = "allow";
          "git for-each-ref *" = "allow";
          "git fsck" = "allow";
          "git grep *" = "allow";
          "git diff *" = "allow";
          "git log *" = "allow";
          "git merge-base *" = "allow";
          "git show *" = "allow";
          "git show-ref *" = "allow";
          "git shortlog *" = "allow";
          "git stash list *" = "allow";
          "git stash show *" = "allow";
          "git status *" = "allow";
          "git submodule status *" = "allow";
          "git tag --list *" = "allow";
          "git tag --contains *" = "allow";
          "git range-diff *" = "allow";
          "git reflog show *" = "allow";
          "git remote -v" = "allow";
          "git remote show *" = "allow";
          "git remote get-url *" = "allow";
          "git rev-list *" = "allow";
          "git rev-parse *" = "allow";
          "git ls-files *" = "allow";
          "git ls-tree *" = "allow";
          "git ls-remote *" = "allow";
          "git hash-object -- *" = "allow";
          "git verify-commit *" = "allow";
          "git verify-tag *" = "allow";
          "git worktree list *" = "allow";
          "git --version" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.github.enable {
          "gh --version" = "allow";
          "gh alias list *" = "allow";
          "gh api user" = "allow";
          "gh auth status" = "allow";
          "gh cache list *" = "allow";
          "gh config get *" = "allow";
          "gh extension list *" = "allow";
          "gh extension search *" = "allow";
          "gh gist list *" = "allow";
          "gh gist view *" = "allow";
          "gh help *" = "allow";
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
          "gh ruleset list *" = "allow";
          "gh ruleset view *" = "allow";
          "gh run list *" = "allow";
          "gh run view *" = "allow";
          "gh run watch *" = "allow";
          "gh search *" = "allow";
          "gh stack view *" = "allow";
          "gh status *" = "allow";
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
        // lib.optionalAttrs config.dotfiles.docker.enable {
          "docker compose config" = "allow";
          "docker compose logs *" = "allow";
          "docker compose ps *" = "allow";
          "docker container ls *" = "allow";
          "docker context ls *" = "allow";
          "docker diff *" = "allow";
          "docker history *" = "allow";
          "docker image ls *" = "allow";
          "docker images *" = "allow";
          "docker info *" = "allow";
          "docker inspect *" = "allow";
          "docker logs *" = "allow";
          "docker network ls *" = "allow";
          "docker port *" = "allow";
          "docker ps *" = "allow";
          "docker search *" = "allow";
          "docker stats --no-stream *" = "allow";
          "docker system df *" = "allow";
          "docker top *" = "allow";
          "docker version *" = "allow";
          "docker volume ls *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.k8s.enable {
          "kubectl api-resources *" = "allow";
          "kubectl api-versions *" = "allow";
          "kubectl cluster-info" = "allow";
          "kubectl config view" = "allow";
          "kubectl get *" = "allow";
          "kubectl describe *" = "allow";
          "kubectl events *" = "allow";
          "kubectl explain *" = "allow";
          "kubectl logs *" = "allow";
          "kubectl top *" = "allow";
          "kubectl version *" = "allow";
          "kubectl rollout status *" = "allow";
          "kubectl rollout history *" = "allow";
          "kubectl auth can-i *" = "allow";
          "kubectl config current-context *" = "allow";
          "kubectl config get-contexts *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.terraform.enable {
          "terraform fmt *" = "allow";
          "terraform validate *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.gradle.enable {
          "./gradlew --version" = "allow";
          "./gradlew compileKotlin" = "allow";
          "./gradlew compileTestKotlin" = "allow";
          "./gradlew dependencies" = "allow";
          "./gradlew test" = "allow";
          "./gradlew test --tests *" = "allow";
          "./gradlew detekt" = "allow";
          "./gradlew help" = "allow";
          "./gradlew ktlintCheck" = "allow";
          "./gradlew ktlintFormat" = "allow";
          "./gradlew projects" = "allow";
          "./gradlew tasks" = "allow";
          "./gradlew tasks --all" = "allow";
        }
        // {
          # Java
          "java -version" = "allow";
          "jar tf *" = "allow";
          "jar -tf *" = "allow";
          "javap *" = "allow";
          "jps *" = "allow";
        }
        // {
          "az account show *" = "allow";
          "az functionapp list *" = "allow";
          "az functionapp show *" = "allow";
          "az monitor metrics list *" = "allow";
          "az monitor metrics list-definitions *" = "allow";
          "az monitor log-analytics workspace show *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.google.enable {
          "gws schema *" = "allow";
          "gws gmail +triage" = "allow";
          "gws docs documents get *" = "allow";
          "gws calendar +agenda" = "allow";
          "gws calendar events list *" = "allow";
          "gws people people searchDirectoryPeople *" = "allow";
          "gws meet conferenceRecords list *" = "allow";
          "gws meet conferenceRecords participants list *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.home-assistant.enable {
          "hass-cli --help" = "allow";
          "hass-cli --version" = "allow";
          "hass-cli -o json area list *" = "allow";
          "hass-cli -o json config release *" = "allow";
          "hass-cli -o json device list *" = "allow";
          "hass-cli -o json device list-by-area *" = "allow";
          "hass-cli -o json entity list *" = "allow";
          "hass-cli -o json integration info *" = "allow";
          "hass-cli -o json integration list *" = "allow";
          "hass-cli -o json service list *" = "allow";
          "hass-cli -o json state get *" = "allow";
          "hass-cli -o json state history *" = "allow";
          "hass-cli -o json state list *" = "allow";
          "hass-cli -o json system health *" = "allow";
        }
        // lib.optionalAttrs config.dotfiles.snowflake.enable {
          "snow sql --query *" = "allow";
          "snow sql -q *" = "allow";
        };
      };
    };
  };
}
