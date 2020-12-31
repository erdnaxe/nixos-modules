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
      window.gtk_theme_variant = "dark";
      bell = {
        duration = 1;
        color = "#ffffff";
      };
      background_opacity = 0.9;
      mouse.url.modifiers = "Control";
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

  services.polybar = {
    enable = true;
    script = "polybar top &";
    config = {
      "bar/top" = {
        width = "100%";
        height = "20";
        radius = 0;
        background = "#222";
        foreground = "#dfdfdf";
        line-size = 2;
        line-color = "#f00";
        padding-left = 1;
        padding-right = 2;

        # font-N = <fontconfig pattern>;<vertical offset>
        font-0 = "Noto Sans Mono:pixelsize=10;1";

        # modules
        module-margin-left = 1;
        module-margin-right = 2;
        modules-left = "xwindow";
        modules-center = "date";
        modules-right = "xkeyboard wlan cpu memory battery alsa";
        tray-position = "right";
        tray-padding = 2;
        bottom = true;
        #scroll-up = "i3wm-wsnext";
        #scroll-down = "i3wm-wsprev";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:30:...%";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        label-layout = "%layout%";
        label-layout-underline = "#e60053";
        label-indicator-padding = 2;
        label-indicator-margin = 1;
        label-indicator-background = "#e60053";
        label-indicator-underline = "#e60053";
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%Y-%m-%d";
        time = "%H:%M";
        label = "%date% %time%";
        format-underline = "#0a6cf5";
      };
      "module/alsa" = {
        type = "internal/alsa";
        format-volume = "<label-volume> <bar-volume>";
        label-volume = "VOL";
        label-volume-foreground = "#dfdfdf";
        label-muted = "VOL muted";
        label-muted-foreground = "#666";
        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = false;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = "#555";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "AC";
        full-at = 96;
        format-charging = "<label-charging>";
        format-charging-underline = "#ffb52a";
        format-discharging = "<label-discharging>";
        format-discharging-underline = "#ffb52a";
        format-full-prefix = "FULL ";
        format-full-underline = "#ffb52a";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        label = "CPU %percentage:2%%";
        format-underline = "#f90000";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        label = "RAM %percentage_used%%";
        format-underline = "#4bffdc";
      };
      "module/wlan" = {
        type = "internal/network";
        interface = "wlp3s0";
        interval = 3;
        label-connected = "%essid%";

        # underline
        format-connected = "<label-connected>";
        format-connected-underline = "#9f78e1";
        format-disconnected = "";
      };
    };
  };

  dconf.settings = {
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "alacritty";
      name = "Open terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Alt>l";
      command = "bash /home/erdnaxe/bin/lock.sh";
      name = "Lock screen";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/gedit/preferences/editor" = {
      insert-spaces = true;
      scheme = "oblivion";
      tabs-size = 4;
    };
    "org/gnome/gnome-system-monitor" = {
      network-in-bits = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.keepassxc.KeePassXC.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Calendar.desktop"
        "skypeforlinux.desktop"
        "element-desktop.desktop"
      ];
    };
    "org/gnome/system/location" = {
      enabled = false;
    };
    "system/locale" = {
      region = "fr_FR.UTF-8";
    };
  };
}
