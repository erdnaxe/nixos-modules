{ pkgs, ... }:

{
  # XFCE + i3 desktop
  services.xserver = {
    enable = true;
    libinput.enable = true;  # touchpad and wacom support
    displayManager.lightdm.enable = true;
    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
    windowManager.i3.enable = true;
  };

  # Graphical apps
  environment.systemPackages = with pkgs; [
    firefox xournalpp vlc evince pavucontrol
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    dejavu_fonts powerline-fonts font-awesome gyre-fonts
  ];

  # Sound with Pipewire
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  # More graphical tools in home-manager
  home-manager.users.erdnaxe = {
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
        font.size = 9;
      };
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override {
        plugins = [ pkgs.rofi-emoji ];
      };
      theme = "solarized_alternate";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      # See rofi -dump-xresources
      extraConfig = {
        modi = "window,run,drun,emoji,ssh,emoji,combi";
        combi-modi = "window,drun,emoji,ssh,emoji";
        show-icons = true;
      };
    };
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          theme = "solarized-dark";
          icons = "awesome5";
          blocks = [
            { block = "disk_space"; info_type = "available"; interval = 20; path = "/"; alias = "/"; unit = "GB"; warning = 20.0; alert = 10.0; }
            { block = "memory"; display_type = "memory"; format_mem = "{mem_used_percents}"; format_swap = "{swap_used_percents}"; }
            { block = "cpu"; interval = 1; format = "{barchart} {frequency}"; }
            { block = "music"; }
            { block = "sound"; }
            { block = "backlight"; }
            { block = "battery"; format = "{percentage} {time}"; driver = "upower"; device = "DisplayDevice"; }
            { block = "time"; format = "%Y/%m/%d %R"; interval = 20; }
          ];
        };
      };
    };
    services.picom = {
      enable = true;
      vSync = true; # Fix screen tearing
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
            fonts = {
              names = ["DejaVu Sans Mono for Powerline" "Font Awesome 5 Free"];
              size = 10.0;
            };
            position = "top";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
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
        keybindings = pkgs.lib.mkOptionDefault {
          "Control+Mod1+l" = "exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 50 10";
          "Mod4+p" = "exec passmenu";
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        };
      };
    };
  };
}
