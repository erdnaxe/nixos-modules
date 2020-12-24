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

#  programs.firefox = {
#    enable = true;
#    profiles = {
#      myprofile = {
#        settings = {
#          "general.smoothScroll" = true;
#        };
#      };
#    };
#  };

  programs.git = {
    enable = true;
    userName  = "Alexandre Iooss";
    userEmail = "erdnaxe@crans.org";
    signing.key = "6C79278F3FCDCC02";
  };

  programs.htop = {
    enable = true;
    hideThreads = true;
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
        height = "24";
        radius = 0;
        background = "#222";
        foreground = "#dfdfdf";
        line-size = 3;
        line-color = "#f00";
        modules-center = "date";
        modules-right = "wlan";
        tray-position = "right";
        tray-padding = 2;
        bottom = true;
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%Y-%m-%d";
        time = "%H:%M";
        label = "%date% %time%";
      };
      "module/wlan" = {
        type = "internal/network";
        interface = "wlp3s0";
        interval = 3;
        format-connected = "<ramp-signal> <label-connected>";
        format-connected-underline = "#9f78e1";
        label-connected = "%essid%";
        format-disconnected = "";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = "#555";
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
