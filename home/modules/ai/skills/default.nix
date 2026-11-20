{ config, lib, ... }:
let
  cfg = config.dotfiles.ai;

  installSkill = name: path: lib.nameValuePair ".agents/skills/${name}" { source = path; };
in
{
  options.dotfiles.ai.skills = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = ''
      Agent skills shared by all AI harnesses, in format skill name -> skill directory.
      Each directory follows the Agent Skills format with a SKILL.md at its root.
    '';
  };

  config = lib.mkIf cfg.enable {
    dotfiles.ai.skills = {
      development-principles = ./development-principles;
      git = ./git;
      handoff = ./handoff;
      nix = ./nix;
      sqlite = ./sqlite;
      tdd = ./tdd;
    }
    // lib.optionalAttrs config.dotfiles.github.enable {
      github-interaction = ./github-interaction;
      pr-description = ./pr-description;
    }
    // lib.optionalAttrs config.dotfiles.google.enable {
      google-workspace = ./google-workspace;
    }
    // lib.optionalAttrs config.dotfiles.home-automation.enable {
      esphome = ./esphome;
      home-assistant = ./home-assistant;
    }
    // lib.optionalAttrs config.dotfiles.k8s.enable {
      kubernetes = ./kubernetes;
    }
    // lib.optionalAttrs config.dotfiles.snowflake.enable {
      snowflake = ./snowflake;
    }
    // lib.optionalAttrs config.dotfiles.wolt-tools.enable {
      jira-interaction = ./jira-interaction;
      ticket-writing = ./ticket-writing;
    };

    # ~/.agents/skills is read by OpenCode, Codex and omp. Skills are linked one by one so other tools can add their own
    home.file = lib.mapAttrs' installSkill cfg.skills;
  };
}
