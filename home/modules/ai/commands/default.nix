{ config, lib, ... }:
let
  cfg = config.dotfiles.ai;

  installCommand = name: path: lib.nameValuePair ".agents/commands/${name}.md" { source = path; };
in
{
  options.dotfiles.ai.commands = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = "Custom slash commands shared by all AI harnesses, in format command name -> markdown file";
  };

  config = lib.mkIf cfg.enable {
    dotfiles.ai.commands = {
      draft-issue-report = ./draft-issue-report.md;
      investigate-issue = ./investigate-issue.md;
    };

    # Commands are linked one by one so other tools can add their own
    home.file = lib.mapAttrs' installCommand cfg.commands;
  };
}
