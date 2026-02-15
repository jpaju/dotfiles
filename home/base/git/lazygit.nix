{ ... }:
{
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    promptToReturnFromSubprocess = false;

    git = {
      overrideGpg = true;
      merging.args = "--ff-only";
      mainBranches = [
        "master"
        "main"
      ];

      pagers = [
        {
          pager = "delta --dark --paging=never";
          colorArg = "always";
          useExternalDiffGitConfig = false;
        }
      ];
    };

    gui = {
      filterMode = "fuzzy";
      scrollHeight = 20;
      showFileIcons = true;
      showNumstatInFilesView = true;
      showDivergenceFromBaseBranch = "arrowAndNumber";
      nerdFontsVersion = "3";
      expandFocusedSidePanel = true;
      expandedSidePanelWeight = 3;
      switchTabsWithPanelJumpKeys = true;

      # Uses Go's time format syntax: https://pkg.go.dev/time#Time.Format
      timeFormat = "02.01.2006";
      shortTimeFormat = "15:04";

      spinner = {
        rate = 50;
        frames = [
          "⣾"
          "⣽"
          "⣻"
          "⢿"
          "⡿"
          "⣟"
          "⣯"
          "⣷"
        ];
      };

      authorColors."*" = "#b7bdf8";

      # Catppuccin Macchiato Maroon
      theme = {
        activeBorderColor = [
          "#ee99a0"
          "bold"
        ];
        inactiveBorderColor = [
          "#a5adcb"
        ];
        optionsTextColor = [
          "#8aadf4"
        ];
        selectedLineBgColor = [
          "#363a4f"
        ];
        cherryPickedCommitBgColor = [
          "#494d64"
        ];
        cherryPickedCommitFgColor = [
          "#ee99a0"
        ];
        unstagedChangesColor = [
          "#ed8796"
        ];
        defaultFgColor = [
          "#cad3f5"
        ];
        searchingActiveBorderColor = [
          "#eed49f"
        ];
      };
    };

    customCommands = [
      {
        # Ideally we could use either of these to not to conflict with the default Push keybind, but currently these are not supported
        # - key: "<c-P>"
        # - key: "<a-p>"
        key = "P";
        command = "git {{.Form.GitCmd}} {{.SelectedRemote.Name}} {{.SelectedLocalCommit.Sha}}:refs/heads/{{.CheckedOutBranch.Name}}";
        context = "commits";
        loadingText = "Pushing commit...";
        description = "Push a specific commit (and any preceding)";
        output = "log";
        prompts = [
          {
            type = "menu";
            title = "How to push?";
            key = "GitCmd";
            options = [
              { value = "push"; }
              { value = "push --force-with-lease"; }
            ];
          }
        ];
      }
    ];
  };
}
