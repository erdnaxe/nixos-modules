{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.libreddit = {
    enable = true;
    port = 3003;
    address = "127.0.0.1";
  };

  # https://github.com/NixOS/nixpkgs/pull/133771
  systemd.services.libreddit.serviceConfig = {
    # Hardening
    CapabilityBoundingSet = [ "" ];
    DeviceAllow = [ "" ];
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    PrivateDevices = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
    UMask = "0077";
  };

  services.nginx = {
    enable = true;
    virtualHosts."reddit.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3003";
        proxyWebsockets = true;
      };
    };
  };
}
