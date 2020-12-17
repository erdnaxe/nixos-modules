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
