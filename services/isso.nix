let
  unstable = import <nixos-unstable> {};
in
{
  imports = [ <nixos-unstable/nixos/modules/services/web-apps/isso.nix> ];
  nixpkgs.config.packageOverrides = pkgs: {
    isso = unstable.isso;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.isso = {
    enable = true;
    settings = {
      general = {
        host = "https://blog.nanax.fr";
        notify = "smtp";
        max-age = "15m";
      };
      moderation = {
        enabled = true;
        purge-after = "30d";
      };
      smtp = {
        host = "smtp.crans.org";
        port = 25;
        to = "erdnaxe@crans.org";
        from = "Isso <root@nanax.fr>";
      };
      guard = {
        enabled = true;
        ratelimit = 2;
        require-author = true;
      };
      server = {
        listen = "http://localhost:3006/";
        public-endpoint = "https://isso.nanax.fr";
      };
      admin.enabled = false;
      markup = {
        options = "strikethrough,superscript,autolink";
        allowed-elements = "a,blockquote,br,code,del,em,h1,h2,h3,h4,h5,h6,hr,ins,li,ol,p,pre,strong,table,tbody,td,th,thead,ul";
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/pull/140840
  systemd.services.isso.serviceConfig = {
    # Hardening
    CapabilityBoundingSet = [ "" ];
    DeviceAllow = [ "" ];
    LockPersonality = true;
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
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."isso.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3006";
        proxyWebsockets = true;
      };
    };
  };
}
