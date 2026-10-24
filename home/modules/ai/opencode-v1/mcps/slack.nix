{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.dotfiles.ai.enable && config.dotfiles.ai.work-mcps.enable) {
    programs.opencode.settings = {
      mcp.slack = {
        type = "remote";
        url = "https://mcp.slack.com/mcp";
        enabled = false;
        oauth = {
          clientId = "1601185624273.8899143856786";
          redirectUri = "http://localhost:3118/callback";
          scope = lib.concatStringsSep "," [
            "bookmarks:read"
            "canvases:read"
            "canvases:write"
            "channels:history"
            "channels:read"
            "chat:write"
            "emoji:read"
            "files:read"
            "groups:history"
            "groups:read"
            "groups:write"
            "im:history"
            "im:read"
            "im:write"
            "mpim:history"
            "mpim:read"
            "mpim:write"
            "mpim:write.topic"
            "pins:read"
            "reactions:read"
            "reactions:write"
            "remote_files:read"
            "search:read.files"
            "search:read.im"
            "search:read.mpim"
            "search:read.private"
            "search:read.public"
            "search:read.users"
            "team:read"
            "users:read"
            "users:read.email"
          ];
        };
      };

      permission = {
        "slack_*" = "ask";
        "slack_*get*" = "allow";
        "slack_*list*" = "allow";
        "slack_*read*" = "allow";
        "slack_*search*" = "allow";
      };
    };
  };
}
