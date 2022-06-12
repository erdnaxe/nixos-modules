let
  miniflux-luma = import ../custom_pkg/miniflux-luma.nix;
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  systemd.services.miniflux-luma = {
    description = "Atom feed exporter for Miniflux starred items";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${miniflux-luma}/bin/miniflux-luma -feed-title \"Nanax feed\" -listen-addr 127.0.0.1:3004 -endpoint https://rss.nanax.fr";
      Restart = "on-failure";
      RestartSec = "2s";

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
      StateDirectory = "miniflux-luma";
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      UMask = "0077";
      WorkingDirectory = "/var/lib/miniflux-luma";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."luma.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3004";
      };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
      '';
    };
  };
}
