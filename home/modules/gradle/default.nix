{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.gradle.enable {
    programs.fish.shellAbbrs = {
      gw = "./gradlew";
      gwf = "./gradlew ktlintFormat";
      gwta = "./gradlew test";
      gwt = {
        expansion = ''./gradlew test --tests "%*"'';
        setCursor = "%";
      };
    };

    programs.fish.interactiveShellInit = ''
      complete -c ./gradlew -w gradle
    '';
  };
}
