# Based on:
# - https://github.com/britter/nix-configuration/blob/main/packages/kotlin-lsp/default.nix
# - https://britter.dev/blog/2025/11/15/kotlin-lsp-nixvim/
# - https://britter.dev/blog/2026/03/20/kotlin-lsp-nixvim-pt2/
{
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "263.4702.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}-aarch64.sit";
    hash = "sha256-tCzSMSy80GfxSWTahlsryuzECGZixSh2ufPFtP8bq/g=";
    extension = "zip";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/kotlin-lsp
    cp -r bin build.txt jbr kotlin-lsp.sh lib license modules plugins product-info.json $out/share/kotlin-lsp

    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

    runHook postInstall
  '';
})
