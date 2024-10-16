{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [ p.matlab ]))
    ];
  };
  
  # programs.vim = {
  #   enable = true;
  #   plugins = with pkgs.vimPlugins; [ vim-airline ];
  #   settings = { ignorecase = true; };
  #   extraConfig = ''
  #     set mouse=a
  #   '';
  # };
}
