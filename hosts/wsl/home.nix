{ pkgs, user, ...}:

{
  home.packages = [
    pkgs.docker
  ];

  programs.zsh = {
    shellAliases = {
      win-home = "cd /mnt/c/Users/${user}";
    };

    initExtra = ''
      export COLORTERM=truecolor
    '';
  };
}
