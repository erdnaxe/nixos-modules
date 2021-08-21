let
  bmpc = import ../custom_pkg/bmpc.nix;
in
{
  home-manager.users.erdnaxe = {
    # Music player deamon on 127.0.0.1:6600
    services.mpd = {
      enable = true;
      musicDirectory = "/home/erdnaxe/Music";
      extraConfig = ''
        audio_output {
            type "pulse"
            name "PulseAudio"
        }
        audio_output {
            type "httpd"
            name "HTTP Stream"
            encoder "opus"
            port "8000"
        }
      '';
    };
  };

  systemd.services.bmpc = {
    description = "Minimalist MPD client in browser";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${bmpc}/bin/bmpc";
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
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      UMask = "0077";
    };
  };
}
