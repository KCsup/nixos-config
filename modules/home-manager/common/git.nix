{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Josh Fernandez";
    userEmail = "kcsup05@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}
