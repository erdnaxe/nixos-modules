# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # System python
  my-python-packages = python-packages: with python-packages; [
    pandas requests numpy matplotlib binwalk ROPGadget virtualenv tox ldap ansible
    autopep8 yapf youtube-dl scapy ipykernel jupyterlab jupyterlab_server
    python-language-server websockets isort selenium
  ];
  python-with-my-packages = pkgs.python38.withPackages my-python-packages;
  openseeface = import ./custom_pkg/openseeface.nix;
in
{
  imports =
    [
      <home-manager/nixos>

      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Machine-specific configuration
      ./local-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader, add ARM emulation and kernel modules
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "armv6l-linux" "aarch64-linux" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  # Use networkmanager to manage network
  networking.networkmanager.enable = true;
  networking.useDHCP = false;

  # Select internationalisation properties.
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    roboto liberation_ttf fira-code fira-code-symbols
    font-awesome lmodern gyre-fonts
  ];

  # Services
  services.flatpak.enable = true;
  services.blueman.enable = true;
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
    windowManager.i3.enable = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin ];
  };
  services.system-config-printer.enable = true;
  services.redshift.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Real-time scheduling for Pipewire
  security.rtkit.enable = true;

  # Approximative geographic location for redshift
  location.latitude = 48.85;
  location.longitude = 2.35;

  # Enable sound.
  sound.enable = true;

  # XDG portal for Flatpak
  xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # wheel for sudo
  users = {
    mutableUsers = false;
    users.root.hashedPassword = "*";
    users.erdnaxe = {
      uid = 1000;
      passwordFile = "/etc/nixos/erdnaxe_password.secret";
      isNormalUser = true;
      home = "/home/erdnaxe";
      description = "Alexandre";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "vboxusers" "adbusers" "wireshark" "networkmanager" ];
    };
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
  environment.variables = { EDITOR = "vim"; };
  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
    # Basic tools
    wget utillinux pciutils file mosh dmidecode inetutils jq vulkan-tools
    clinfo pass playerctl screen tmux nvtop tree wget rsync nettools
    python-with-my-packages scrot binutils-unwrapped appimage-run
    lm_sensors ripgrep mpc_cli ntfs3g patchelf nix-prefetch-git
    usbutils strace

    # Archiver
    zip unzip p7zip unrar

    # Audiovisual
    ffmpeg-full espeak opusTools
    # openseeface: removed because of poor maintenability of onnxruntime

    # Graphical applications
    firefox brave thunderbird steam-run wineWowPackages.staging
    winetricks xournalpp apache-directory-studio
    audacity obs-studio meld picard
    vscode gimp keepassxc vlc zoom-us libreoffice-fresh
    inkscape multimc krita blender musescore owncloud-client
    cura handbrake evince xlockmore puredata qemu gnome3.file-roller
    gource arandr dolphinEmu gnome3.gedit texmaker cutecom
    transmission baobab gparted mesa-demos i3lock pulseeffects-pw rubberband
    openscad printrun gnome3.gnome-disk-utility pavucontrol

    # Dicts
    aspellDicts.en aspellDicts.fr aspellDicts.en-computers aspellDicts.en-science

    # Development and writing
    hugo black cargo go yarn gcc gdb lua mono nodejs gnumake shellcheck
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
  # networking.firewall.allowedTCPPorts = [ 4444 ];
  # networking.firewall.allowedUDPPorts = [ 5004 ];
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
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  # Extra codec
  hardware.bluetooth.enable = true;
}
