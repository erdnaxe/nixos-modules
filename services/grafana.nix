{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.grafana = {
    enable = true;
    port = 3001;
    domain = "grafana.nanax.fr";
    protocol = "http";
    auth.anonymous.enable = true;
    extraOptions = {
      ALERTING_ENABLED = "false";
      METRICS_ENABLED = "false";
      ANALYTICS_REPORTING_ENABLED = "false";
      SNAPSHOTS_ENABLED = "false";
      PANELS_DISABLE_SANITIZE_HTML = "true";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."grafana.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/pull/134174
  # To remove in NixOS 21.11
  systemd.services.grafana = {
    serviceConfig = {
      # Hardening
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
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
      ProtectSystem = "full";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      UMask = "0077";
    };
  };
}
