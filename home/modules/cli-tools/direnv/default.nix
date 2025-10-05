{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # Copied from https://github.com/direnv/direnv/wiki/Python#uv
      layout_uv() {
          if [[ -d ".venv" ]]; then
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
              log_status "No virtual environment exists. Executing \`uv venv\` to create one."
              uv venv
              VIRTUAL_ENV="$(pwd)/.venv"
          fi

          if [ -d ".venv/bin" ]; then
              PATH_add .venv/bin
          elif [ -d ".venv/Scripts" ]; then
              PATH_add .venv/Scripts
          fi
          export UV_ACTIVE=1  # or VENV_ACTIVE=1
          export VIRTUAL_ENV
      }'';
  };

  programs.fish.shellAbbrs = {
    de = "direnv";
    dea = "direnv allow";
    deb = "direnv block";
    des = "direnv status";
  };

  xdg.configFile = {
    "fish/functions/add-nix-direnv.fish".source = ./add-nix-direnv.fish;
    "fish/functions/gitignore-flake.fish".source = ./gitignore-flake.fish;
    "fish/completions/add-nix-direnv.fish".source = ./add-nix-direnv-completions.fish;
  };
}
