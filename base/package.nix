{ lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  environment.variables = { EDITOR = "vim"; };

  # Remove ZFS, CIFS, XFS, REISERFS, BTRFS from supported filesystems
  boot.supportedFilesystems = lib.mkForce [ "vfat" "f2fs" "ntfs" ];

  environment.systemPackages = with pkgs; [
    wget utillinux file dmidecode inetutils jq
    tmux tree nettools ripgrep
  ];

  # Coming in D-Bus 0.14
  # https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/107
  systemd.services.dbus.serviceConfig = {
    # Hardening
    CapabilityBoundingSet = [ "CAP_SETGID" "CAP_SETUID" "CAP_SETPCAP" "CAP_SYS_RESOURCE" "CAP_AUDIT_WRITE" ];
    DeviceAllow = [ "/dev/null rw" "/dev/urandom r" ];
    DevicePolicy = "strict";
    IPAddressDeny = "any";
    LimitMEMLOCK = 0;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    ReadOnlyPaths = [ "-/" ];
    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@chown" "~@clock" "~@cpu-emulation" "~@debug" "~@module" "~@mount" "~@obsolete" "~@raw-io" "~@reboot" "~@resources" "~@swap" "~memfd_create" "~mincore" "~mlock" "~mlockall" "~personality" ];
    UMask = "0077";
  };

  systemd.services.rtkit-daemon.serviceConfig = {
    # Hardening
    NoNewPrivileges = true;
    PrivateDevices = true; # opensuse
    PrivateTmp = true; # fedora
    ProtectClock = true; # opensuse
    ProtectControlGroups = true; # opensuse
    ProtectHome = true; # opensuse
    ProtectHostname = true; # opensuse
    ProtectKernelLogs = true; # opensuse
    ProtectKernelModules = true; # opensuse
    ProtectKernelTunables = true; # opensuse
    ProtectSystem = "full"; # opensuse (strict?)
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
  };

  systemd.services.NetworkManager.serviceConfig = {
    # Hardening
    ProtectKernelLogs = true;
    #ProtectKernelTunables = true;  breaks ipv4/ip_forward
    ProtectKernelModules = true;
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
  };

  systemd.services.bluetooth.serviceConfig = {
    # Hardening
    # RestrictAddressFamilies = [ "AF_UNIX" "AF_BLUETOOTH" "AF_NETLINK" ]; breaks rfkill
    ProtectClock = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
  };

  systemd.services.postgresql.serviceConfig = {
    NoNewPrivileges = true; # arch
    PrivateDevices = true; # arch
    PrivateTmp = true; # arch
    ProtectControlGroups = true; # arch
    ProtectHome = true; # arch
    ProtectKernelModules = true; # arch
    ProtectKernelTunables = true; # arch
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ]; # arch
    RestrictNamespaces = true; # arch
    RestrictRealtime = true; # arch
  };

  systemd.services.logrotate.serviceConfig = {
    # https://github.com/logrotate/logrotate/blob/master/examples/logrotate.service
    Nice = 19;
    IOSchedulingClass = "best-effort";
    IOSchedulingPriority = 7;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "full";
    RestrictNamespaces = true;
    RestrictRealtime = true;
  };
}
