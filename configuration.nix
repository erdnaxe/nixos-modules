# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # System python
  my-python-packages = python-packages: with python-packages; [
    pandas requests numpy matplotlib binwalk ROPGadget virtualenv tox ldap ansible
  ];
  python-with-my-packages = pkgs.python38.withPackages my-python-packages;
in
{
  imports =
    [
      <nixos-hardware-erdnaxe/dell/g3/3779>

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use networkmanager to manage network
  networking.hostName = "ventus";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Disable some Gnome defaults
  services.dleyna-renderer.enable = false;
  services.dleyna-server.enable = false;
  services.gnome3.tracker-miners.enable = false;
  services.gnome3.tracker.enable = false;
  services.gnome3.gnome-remote-desktop.enable = false;
  services.gnome3.gnome-user-share.enable = false;
  services.gnome3.rygel.enable = false;
  services.avahi.enable = false;
  services.geoclue2.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # wheel for sudo
  # video for brightnessctl
  users.users.erdnaxe = {
    isNormalUser = true;
    home = "/home/erdnaxe";
    description = "Alexandre";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "vboxusers" "adbusers" "wireshark" "networkmanager" ];
  };

  # Allow non-free software such as VSCode
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic tools
    wget vim
    pciutils file
    vulkan-tools mesa-demos clinfo
    screen tmux git htop nvtop tree wget rsync gcc boost gdb lua mono nodejs
    podman-compose pandoc zip unzip openssl gnumake nettools
    python-with-my-packages
    binutils-unwrapped espeak

    # Applications
    firefox thunderbird element-desktop steam-run wineWowPackages.staging
    wineWowPackages.fonts winetricks discord
    audacity obs-studio obs-v4l2sink meld gitg chromium skypeforlinux
    alacritty vscode gimp keepassxc vlc zoom-us tdesktop libreoffice-fresh
    inkscape multimc krita blender musescore nextcloud-client pavucontrol

    # CTF
    socat netcat-gnu killall testdisk goaccess volatility sqlmap apktool
    bettercap

    # Android
    android-udev-rules abootimg

    # Gnome 3
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor

    # NTFS support
    ntfs3g

    # Run on GPU
    nvidia-offload cudaPackages.cudatoolkit_10_1
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.adb.enable = true;
  programs.wireshark.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  services.flatpak.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  # Oh my Zsh!
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "sudo" "adb" ];
    theme = "agnoster";
  };

  # 32-bit libgl for wine
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  # Extra codec
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
}
