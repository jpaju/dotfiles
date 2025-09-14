{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    kubectx
    argo-rollouts
  ];

  programs.fish.shellAbbrs = {
    k = "kubectl";
    kctx = "kubectx";
  };

  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };

  programs.k9s = {
    enable = true;

    # See: https://k9scli.io/topics/config/
    settings.k9s = {
      liveViewAutoRefresh = false;
      refreshRate = 2;

      ui = {
        enableMouse = true;
        headless = false;
        reactive = false;
        noIcons = false;
      };

      logger = {
        tail = 100;
        buffer = 2000;
        sinceSeconds = -1;
      };
    };
  };

  catppuccin.k9s.enable = true;
}
