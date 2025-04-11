{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl # Comment to keep newlines :D
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

    skins = {
      catppuccin-macchiato = let
        theme = "catppuccin-macchiato";
        rev = "4432383da214face855a873d61d2aa914084ffa2";
      in pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/k9s/${rev}/dist/${theme}.yaml";
        hash = "sha256-OR23zFdI/aQBL4cdqN/cnawEASRGw0voBP93QLzivfE=";
      };
    };

  };
}
