{ pkgs, ... }:

{
  # Hardware acceleration
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true; # wine
    extraPackages = [ pkgs.intel-compute-runtime ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
      };
    };
  };
  programs.sway.enable = true;

  # Enable helpful DBus services.
  services.udisks2.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.upower.enable = true;
  #services.gnome.glib-networking.enable = true;
  services.gvfs.enable = true;
  #services.tumbler.enable = true;

  # Graphical apps
  environment.systemPackages = with pkgs; [
    gnome.gnome-themes-extra
    gnome.adwaita-icon-theme

    desktop-file-utils
    shared-mime-info # for update-mime-database

    xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    networkmanagerapplet

    firefox-wayland
    xournalpp
    mpv
    evince
    pavucontrol
    wdisplays
    dmenu-wayland
    xfce.thunar

    # Theme
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
  ];

  fonts.fonts = with pkgs; [
    dejavu_fonts
    powerline-fonts
    font-awesome
    gyre-fonts
  ];

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = { }; # TODO
    };
    # Required for file chooser
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    # SDL_VIDEODRIVER=wayland
    # ECORE_EVAS_ENGINE=wayland_egl
    # QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # QT_WAYLAND_FORCE_DPI=physical
    # QT_QPA_PLATFORM=wayland
  };

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
        font.size = 9;
        colors.primary.background = "#1c1b22";
      };
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      theme = "solarized_alternate";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      extraConfig = {
        modi = "window,run,drun,emoji,combi";
        combi-modi = "window,drun,emoji";
        show-icons = true;
      };
    };
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          theme = "native";
          icons = "awesome5";
          blocks = [
            { block = "disk_space"; }
            { block = "memory"; format_mem = "{mem_used_percents}"; format_swap = "{swap_used_percents}"; }
            { block = "cpu"; format = "{barchart} {frequency}"; }
            { block = "music"; buttons = [ "play" "next" ]; }
            { block = "sound"; }
            { block = "battery"; format = "{percentage} {time}"; driver = "upower"; device = "DisplayDevice"; }
            { block = "networkmanager"; }
            { block = "time"; format = "%Y/%m/%d %R"; interval = 20; }
          ];
        };
      };
    };
    services.gammastep = {
      enable = true;
      latitude = 48.85;
      longitude = 2.35;
    };
    #services.swayidle = {
    #  enable = true;
    #  events = [
    #    { event = "before-sleep"; command = "swaylock"; }
    #  ];
    #};
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "rofi -show combi";
        window.hideEdgeBorders = "smart";
        floating.criteria = [
          { title = "Steam - Update News"; }
          { app_id = "pavucontrol"; }
          { title = "Firefox — Sharing Indicator"; }
        ];
        bars = [
          {
            fonts = {
              names = [ "DejaVu Sans Mono for Powerline" "Font Awesome 5 Free" ];
              size = 10.0;
            };
            position = "top";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
            trayOutput = "primary";
            colors = {
              background = "#1c1b22";
              statusline = "#929298";
              focusedWorkspace = { border = "#42414d"; background = "#42414d"; text = "#ffffff"; };
              activeWorkspace = { border = "#1c1b22"; background = "#1c1b22"; text = "#929298"; };
              inactiveWorkspace = { border = "#1c1b22"; background = "#1c1b22"; text = "#929298"; };
            };
          }
        ];
        colors = {
          focused = { background = "#42414d"; border = "#42414d"; childBorder = "#42414d"; indicator = "#2e9ef4"; text = "#ffffff"; };
          focusedInactive = { background = "#1c1b22"; border = "#1c1b22"; childBorder = "#1c1b22"; indicator = "#292d2e"; text = "#929298"; };
          unfocused = { background = "#1c1b22"; border = "#1c1b22"; childBorder = "#1c1b22"; indicator = "#292d2e"; text = "#929298"; };
        };
        keybindings = pkgs.lib.mkOptionDefault {
          "Mod4+l" = "exec ${pkgs.swaylock}/bin/swaylock -i ~/.bg.png";
          "Mod4+p" = "exec passmenu";
          "--locked XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5";
          "--locked XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5";
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
          "--locked XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "--locked XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -";
          "Mod4+ampersand" = "workspace 1";
          "Mod4+eacute" = "workspace 2";
          "Mod4+quotedbl" = "workspace 3";
          "Mod4+apostrophe" = "workspace 4";
          "Mod4+parenleft" = "workspace 5";
          "Mod4+egrave" = "workspace 6";
          "Mod4+minus" = "workspace 7";
          "Mod4+underscore" = "workspace 8";
          "Mod4+ccedilla" = "workspace 9";
          "Mod4+agrave" = "workspace 10";
          "Mod4+Shift+ampersand" = "move container to workspace 1";
          "Mod4+Shift+eacute" = "move container to workspace 2";
          "Mod4+Shift+quotedbl" = "move container to workspace 3";
          "Mod4+Shift+apostrophe" = "move container to workspace 4";
          "Mod4+Shift+parenleft" = "move container to workspace 5";
          "Mod4+Shift+egrave" = "move container to workspace 6";
          "Mod4+Shift+minus" = "move container to workspace 7";
          "Mod4+Shift+underscore" = "move container to workspace 8";
          "Mod4+Shift+ccedilla" = "move container to workspace 9";
          "Mod4+Shift+agrave" = "move container to workspace 10";
        };
        input = {
          "*" = { xkb_layout = "fr"; };
          "type:touchpad" = {
            "tap" = "enabled";
            "natural_scroll" = "enabled";
          };
        };
        output = { "*" = { bg = "~/.bg.png fill"; }; };
      };
      extraConfig = ''
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
        #exec ${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store
        exec ${pkgs.mako}/bin/mako --default-timeout 10
        exec ${pkgs.swayidle}/bin/swayidle -w before-sleep '${pkgs.swaylock}/bin/swaylock -i ~/.bg.png'
      '';
    };
  };
}
