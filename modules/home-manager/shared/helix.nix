{ pkgs, ... }:

{
  home.packages = [
    pkgs.nil # LSP for Nix
    pkgs.lua-language-server # LS for Lua
  ];
  
  programs.helix = {
    enable = true;
    defaultEditor = true;
    
    settings = {
      theme = "gruvbox";
      editor = {
        rulers = [ 80 ];
        
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        
        file-picker = {
          hidden = false;
          git-ignore = false;
        };

        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" "file-modification-indicator"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "|";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        soft-wrap.enable = true;
      };
    };

    languages = {
      language-server = {
        pylsp = {
          command = "pylsp";
          config = {
            pylsp.plugins = {
              flake8 = { enabled = false; };
              autopep8 = { enabled = false; };
              mccabe = { enabled = false; };
              pycodestyle = { enabled = false; };
              pyflakes = { enabled = false; };
              pylint = { enabled = false; };
              yapf = { enabled = false ; };
              ruff = {
                enabled = true;
                formatEnabled = true;
                # ignore = ["F401"];
                lineLength = 80;
              };
            };
          };
        };
      };

      language = [
        {
          name = "python";
          language-servers = [ "pylsp" ];
          file-types = [ "py" ];
        }
      ];
    };
  };
}
