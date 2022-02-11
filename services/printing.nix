{ pkgs, ... }:

{
  users.users.erdnaxe.extraGroups = [ "scanner" "lp" ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin hplip ];
  };
  services.system-config-printer.enable = true;

  systemd.services.cups.serviceConfig = {
    # Hardening
    CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_AUDIT_WRITE" "CAP_DAC_OVERRIDE" "CAP_FSETID" "CAP_KILL" "CAP_NET_BIND_SERVICE" "CAP_SETGID" "CAP_SETUID" ];
    # ProtectClock = true;  # breaks HP printer
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" "AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
  };

  # Scanner
  # Disabled because of incompatibility with cups
  #hardware.sane.enable = true;
}
