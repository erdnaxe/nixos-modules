{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];
  home-manager.users.erdnaxe = {
    programs.git = {
      enable = true;
      userName = "Alexandre Iooss";
      userEmail = "erdnaxe@crans.org";
      signing.key = "6C79278F3FCDCC02";
    };
    programs.htop = {
      enable = true;
      settings = {
        hide_threads = true;
        hide_userland_threads = true;
        show_program_path = false;
        tree_view = true;
      };
    };
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set nocompatible
        set backspace=indent,eol,start
        filetype indent plugin on
        syntax on
        set wildmenu
        set showcmd
        set hlsearch
        set ignorecase
        set smartcase
        set autoindent
        set nostartofline
        set mouse=a
        set number
      '';
      plugins = with pkgs.vimPlugins; [ vim-lastplace vim-nix ];
    };
  };
}
