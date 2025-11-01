{ username, userhome, ... }:
{
  users.users.${username}.home = userhome;

  /*
    Apparently temporary fix when nix-darwin is doing some migrations
    For more information, see:
      - https://github.com/nix-darwin/nix-darwin/pull/1017
      - https://github.com/nix-darwin/nix-darwin/pull/1341
      - https://github.com/nix-darwin/nix-darwin/issues/96
  */
  system.primaryUser = username;
}
