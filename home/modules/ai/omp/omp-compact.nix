{
  config,
  lib,
  pkgs,
  ...
}:
let
  ompCompact = pkgs.fetchFromGitHub {
    owner = "arksdev";
    repo = "omp-compact";
    rev = "v2.5.3";
    hash = "sha256-qlrgKUAaGWR4kLVXpEI4bYQOoBVpTxbJtKyO2dwoGSA=";
  };
in
{
  config = lib.mkIf config.programs.omp.enable {
    programs.omp.settings = {
      extensionRenderers.transcriptPresenters = true;
      extensions = [ "${ompCompact}/.omp-plugin/index.ts" ];
    };
  };
}
