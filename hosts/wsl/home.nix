{ pkgs, user, ...}:

{
  programs.zsh = {
    shellAliases = {
      win-home = "cd /mnt/c/Users/${user}";
    };
  };
}
