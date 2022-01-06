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

  # Merged in unstable, https://github.com/NixOS/nixpkgs/pull/152455
  systemd.services.minecraft-server.serviceConfig = {
    # Hardening
    CapabilityBoundingSet = [ "" ];
    DeviceAllow = [ "" ];
    LockPersonality = true;
    PrivateDevices = true;
    PrivateTmp = true;
    PrivateUsers = true;
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
    UMask = "0077";
  };
}
