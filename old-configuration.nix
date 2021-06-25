# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # System python
  my-python-packages = python-packages: with python-packages; [
    pandas requests numpy matplotlib binwalk virtualenv tox ldap ansible
    autopep8 yapf youtube-dl scapy ipykernel jupyterlab jupyterlab_server
    python-language-server websockets isort selenium
  ];
  python-with-my-packages = pkgs.python38.withPackages my-python-packages;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Machine-specific configuration
      ./local-configuration.nix

      # Import modules
      ./modules/base
      ./modules/services/bluetooth.nix
      ./modules/services/graphical-desktop.nix
      ./modules/services/music-player.nix
      ./modules/services/printing.nix
    ];

  # Use the systemd-boot EFI boot loader, add ARM emulation and kernel modules
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  # Use networkmanager to manage network
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    roboto liberation_ttf fira-code fira-code-symbols
    font-awesome lmodern gyre-fonts
  ];

  # Services
  services.flatpak.enable = true;
  services.redshift.enable = true;

  # XDG portal for Flatpak
  xdg.portal.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic tools
    wget utillinux file dmidecode inetutils jq
    clinfo pass tmux nvtop tree nettools
    python-with-my-packages binutils-unwrapped appimage-run
    lm_sensors ripgrep mpc_cli ntfs3g patchelf nix-prefetch-git

    # Archiver
    p7zip unrar

    # Audiovisual
    ffmpeg-full espeak opusTools

    # Graphical applications
    firefox brave thunderbird steam-run wineWowPackages.staging
    winetricks xournalpp apache-directory-studio
    audacity obs-studio meld picard
    vscode gimp keepassxc vlc zoom-us libreoffice-fresh
    inkscape multimc krita blender musescore owncloud-client
    cura handbrake evince qemu gnome3.file-roller
    gource arandr dolphinEmu gnome3.gedit texmaker cutecom
    transmission baobab gparted
    openscad printrun gnome3.gnome-disk-utility pavucontrol

    # Dicts
    aspellDicts.en aspellDicts.fr aspellDicts.en-computers aspellDicts.en-science

    # Development and writing
    hugo black cargo go yarn gcc gdb lua mono nodejs gnumake shellcheck
    upx clang-tools vagrant pandoc graphviz poppler_utils
    (texlive.combine { inherit (texlive) scheme-medium moderncv fontawesome; })

    # CTF
    netcat-gnu killall goaccess volatility sqlmap apktool
    bettercap pngcheck john jd-gui nmap-graphical ghidra-bin
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
  # 51820 is wireguard
  # networking.firewall.allowedTCPPorts = [ 4444 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # For wireguard compatibility
  networking.firewall.checkReversePath = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  # 32-bit libgl for wine
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
}
