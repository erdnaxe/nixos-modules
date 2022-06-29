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
    programs.bottom = {
      enable = true;
      settings.flags = {
        basic = true;
        hide_avg_cpu = true;
        tree = true;
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
        set cc=80
        set clipboard=unnamedplus
        set ttyfast
        set termguicolors
        colorscheme codedark

        lua << EOF
        -- Configure LSP
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
        local lspconfig = require'lspconfig'
        lspconfig.ccls.setup{capabilities=capabilities}
        lspconfig.cmake.setup{capabilities=capabilities}
        lspconfig.rust_analyzer.setup{capabilities=capabilities}
        lspconfig.pyright.setup{capabilities=capabilities}
        lspconfig.tsserver.setup{capabilities=capabilities}

        -- Configure autocompletion
        local luasnip = require'luasnip'
        local cmp = require'cmp'
        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          },
          sources = {{ name = 'nvim_lsp' }, { name = 'luasnip' }},
        }
        EOF
      '';
      plugins = with pkgs.vimPlugins; [
        vim-better-whitespace
        vim-lastplace
        vim-nix
        vim-code-dark
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        luasnip
      ];
    };
  };
}
