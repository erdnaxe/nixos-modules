{ lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  environment.variables = { EDITOR = "vim"; };

  # Remove ZFS, CIFS, XFS, REISERFS, BTRFS from supported filesystems
  boot.supportedFilesystems = lib.mkForce [ "vfat" "f2fs" "ntfs" ];

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
}
