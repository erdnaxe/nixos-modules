# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # System python
  my-python-packages = python-packages: with python-packages; [
    pandas requests numpy matplotlib binwalk ROPGadget virtualenv tox ldap ansible
    autopep8 yapf youtube-dl scapy ipykernel jupyterlab jupyterlab_server
    python-language-server websockets isort
  ];
  python-with-my-packages = pkgs.python38.withPackages my-python-packages;
in
{
  imports =
    [
      <nixos-hardware/dell/g3/3779>
      <home-manager/nixos>

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "armv6l-linux" "aarch64-linux" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Use networkmanager to manage network
  networking.hostName = "ventus";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.hosts = {
    "127.0.0.1" = [ "rss-bridge.localhost" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    roboto
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    lmodern
    gyre-fonts
  ];

  # Services
  services.flatpak.enable = true;
  services.blueman.enable = true;
  # services.openssh.enable = true;
  services.xserver = {
    enable = true;
    layout = "fr";  # fr azerty keyboard
    libinput.enable = true;  # touchpad support
    displayManager.lightdm.enable = true;
    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ i3status-rust ];
    };
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint gutenprintBin
    ];
  };
  services.system-config-printer.enable = true;
  services.redshift.enable = true;
  location.latitude = 48.85;
  location.longitude = 2.35;
  services.fwupd.enable = true;

  environment.variables = { EDITOR = "vim"; };

  # Enable sound.
  sound.enable = true;

  # XDG portal for Flatpak
  xdg.portal.enable = true;

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

  # By default, Home Manager uses a private pkgs instance that is configured
  # via the home-manager.users.<name>.nixpkgs options.
  # To instead use the global pkgs that is configured via the system
  home-manager.useGlobalPkgs = true;

  # Import home configuration
  home-manager.users.erdnaxe = import ./home.nix;

  # Allow non-free software such as VSCode
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic tools
    wget utillinux pciutils file mosh dmidecode inetutils jq vulkan-tools
    clinfo pass playerctl screen tmux nvtop tree wget rsync nettools
    python-with-my-packages scrot binutils-unwrapped appimage-run
    lm_sensors ripgrep mpc ntfs3g patchelf nix-prefetch-git

    # Archiver
    zip unzip p7zip

    # Audiovisual
    ffmpeg-full espeak opus-tools

    # Graphical applications
    firefox thunderbird element-desktop steam-run wine
    winetricks discord xournalpp apache-directory-studio
    audacity obs-studio meld skypeforlinux picard
    vscode gimp keepassxc vlc zoom-us tdesktop libreoffice-fresh
    inkscape multimc krita blender musescore owncloud-client
    cura handbrake evince xlockmore puredata qemu gnome3.file-roller
    gource arandr dolphinEmu gnome3.gedit texmaker cutecom
    transmission baobab gparted mesa-demos i3lock pulseeffects rubberband

    # Dicts
    aspellDicts.en aspellDicts.fr aspellDicts.en-computers aspellDicts.en-science

    # Development and writing
    hugo black cargo go_1_16 yarn gcc gdb lua mono nodejs gnumake shellcheck
    upx clang-tools vagrant pandoc graphviz poppler_utils
    (texlive.combine { inherit (texlive) scheme-medium moderncv fontawesome; })

    # CTF
    socat netcat-gnu killall testdisk goaccess volatility sqlmap apktool
    bettercap pngcheck john jd-gui radare2 nmap-graphical ghidra-bin
    inspectrum wireshark-qt gnuradio wabt

    # Android
    android-udev-rules abootimg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.adb.enable = true;
  programs.wireshark.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  virtualisation.podman.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Open ports in the firewall.
  # 4444: OBS remote
  # 5004: RTP pulseaudio incoming
  networking.firewall.allowedTCPPorts = [ 4444 ];
  networking.firewall.allowedUDPPorts = [ 5004 ];
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
    daemon.config = {
      resample-method = "src-sinc-best-quality";
      default-sample-rate = 96000;
    };
  };
  hardware.bluetooth.enable = true;
}
