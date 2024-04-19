{
  fishPlugin = pkgs: name: {
    inherit name;
    src = pkgs.fishPlugins.${name}.src;
  };

  fishGithubPlugin = pkgs:
    { name, owner, rev, sha256 }: {
      name = name;
      src = pkgs.fetchFromGitHub {
        inherit owner;
        repo = name;
        rev = rev;
        sha256 = sha256;
      };
    };
}
