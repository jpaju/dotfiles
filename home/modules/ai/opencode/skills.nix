{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.dotfiles.ai.enable {
    programs.opencode.skills = {
      development-principles = ./skills/development-principles;
      handoff = ./skills/handoff;
      nix = ./skills/nix;
      sqlite = ./skills/sqlite;
      tdd = ./skills/tdd;
    }
    // lib.optionalAttrs config.dotfiles.github.enable {
      github-interaction = ./skills/github-interaction;
      pr-description = ./skills/pr-description;
    }
    // lib.optionalAttrs config.dotfiles.google.enable {
      google-workspace = ./skills/google-workspace;
    }
    // lib.optionalAttrs config.dotfiles.home-automation.enable {
      esphome = ./skills/esphome;
      home-assistant = ./skills/home-assistant;
    }
    // lib.optionalAttrs config.dotfiles.k8s.enable {
      kubernetes = ./skills/kubernetes;
    }
    // lib.optionalAttrs config.dotfiles.snowflake.enable {
      snowflake = ./skills/snowflake;
    }
    // lib.optionalAttrs config.dotfiles.wolt-tools.enable {
      jira-interaction = ./skills/jira-interaction;
      ticket-writing = ./skills/ticket-writing;
    };
  };
}
