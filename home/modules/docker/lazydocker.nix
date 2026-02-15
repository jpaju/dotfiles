{ ... }:
{
  programs.fish.shellAbbrs.ld = "lazydocker";

  programs.lazydocker.enable = true;
  programs.lazydocker.settings = {
    gui = {
      scrollHeight = 20;
      returnImmediately = true;
      expandFocusedSidePanel = true;
      containerStatusHealthStyle = "icon";

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
      };
    };

    logs = {
      timestamps = true;
      since = "120m";
    };
  };
}
