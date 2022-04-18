{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
{
  imports = [ <home-manager/nixos> ];
  home-manager.users.erdnaxe = {
    home.packages = with pkgs; [
      # Language servers for NeoVim and VSCode
      ccls
      cmake-language-server
      rust-analyzer
      nodePackages.pyright
      nodePackages.typescript-language-server
    ];
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
      package = unstable.neovim-unwrapped;
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
        set cc=80
        set clipboard=unnamedplus
        set ttyfast
        set termguicolors
        colorscheme codedark

        lua require'lspconfig'.ccls.setup{}
        lua require'lspconfig'.cmake.setup{}
        lua require'lspconfig'.rust_analyzer.setup{}
        lua require'lspconfig'.pyright.setup{}
        lua require'lspconfig'.tsserver.setup{}
      '';
      plugins = with unstable.vimPlugins; [
        vim-better-whitespace
        vim-lastplace
        vim-nix
        vim-code-dark
        nvim-lspconfig
      ];
    };
  };
}
