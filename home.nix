{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.dimensions = {
        lines = 30;
        columns = 140;
      };
      bell = {
        duration = 1;
        color = "#ffffff";
      };
      mouse.url.modifiers = "Control";
      font.size = 9;
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };

  programs.git = {
    enable = true;
    userName  = "Alexandre Iooss";
    userEmail = "erdnaxe@crans.org";
    signing.key = "6C79278F3FCDCC02";
  };

  programs.htop = {
    enable = true;
    hideThreads = true;
    hideUserlandThreads = true;
    showProgramPath = false;
    treeView = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #vimDiffAlias = true;
    extraConfig = ''
      set nocompatible
      set backspace=indent,eol,start
    '';
    plugins = with pkgs.vimPlugins; [
      vim-lastplace
      vim-nix
    ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = with pkgs; [ rofi-emoji ];
    };
    theme = "solarized_alternate";
    pass.enable = true;
    # See rofi -dump-xresources
    extraConfig = ''
      rofi.modi: window,run,drun,emoji,ssh,emoji,combi
      rofi.combi-modi: window,drun,emoji,ssh,emoji
      rofi.show-icons: true
    '';
  };

  # Notification deamon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x5-30+50";
        transparency = 10;
        font = "Noto Sans Mono 11";
        padding = 8;
        horizontal_padding = 8;
        idle_threshold = 120;
        icon_position = "left";
      };
    };
  };

  # Fix screen tearing
  services.picom = {
    enable = true;
    vSync = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi -show combi";
      window.hideEdgeBorders = "smart";
      floating.criteria = [
        { title = "Steam - Update News"; }
        { class = "Pavucontrol"; }
      ];
      bars = [
        {
          fonts = ["Noto Sans Mono" "FontAwesome 10"];
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
          trayOutput = "primary";
          colors = {
            separator = "#666666";
            background = "#222222";
            statusline = "#dddddd";
            focusedWorkspace = {
              border = "#0088cc";
              background = "#0088cc";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#333333";
              text = "#888888";
            };
          };
        }
      ];
    };
  };
}
