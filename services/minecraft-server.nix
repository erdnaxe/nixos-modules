{
  nixpkgs.config.allowUnfree = true;
  services.minecraft-server = {
    enable = true;
    package = import ../custom_pkg/fabric-server.nix;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      gamemode = 1;
      motd = "Fabric Creative server";
    };
  };

  systemd.services.minecraft-server.serviceConfig = {
    # Hardening
    #AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = [ "" ];  # upstream: if cfg.server.port < 1024 then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
    DeviceAllow = [ "" ];
    LockPersonality = true;
    #MemoryDenyWriteExecute = true;  BREAKS!
    PrivateDevices = true;
    # A private user cannot have process capabilities on the host's user
    # namespace and thus CAP_NET_BIND_SERVICE has no effect.
    PrivateTmp = true;
    PrivateUsers = true;  # cfg.server.port >= 1024;
    #ProcSubset = "pid";  BREAKS /proc/cpuinfo meminfo
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
    #SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
    UMask = "0077";
  };
}
