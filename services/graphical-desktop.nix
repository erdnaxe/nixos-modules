{ pkgs, ... }:

{
  # XFCE + i3 desktop
  services.xserver = {
    enable = true;
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
    firefox
    xournalpp
    mpv
    evince
    pavucontrol
    arandr
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    dejavu_fonts
    powerline-fonts
    font-awesome
    gyre-fonts
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
        font.size = 9;
        colors.primary.background = "#1c1b22";
      };
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      theme = "solarized_alternate";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      # See rofi -dump-xresources
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
    services.screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
      inactiveInterval = 60;
    };
    services.redshift = {
      enable = true;
      latitude = 48.85;
      longitude = 2.35;
    };
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        # exec --no-startup-id feh --bg-scale $HOME/.background-image
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
