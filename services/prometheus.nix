{ pkgs, ... }:

{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      nginx.enable = true;
      blackbox = {
        enable = true;
        configFile = ./prometheus-blackbox.yml;
      };
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [ "localhost:9090" ];
            labels.instance = "chevalier.nanax.fr";
          }
        ];
      }
      {
        job_name = "node";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [ "localhost:9100" ];
            labels.instance = "chevalier.nanax.fr";
          }
        ];
      }
      {
        job_name = "nginx";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [ "localhost:9113" ];
            labels.instance = "chevalier.nanax.fr";
          }
        ];
      }
      {
        job_name = "blackbox_http_2xx";
        scrape_interval = "600s";
        static_configs = [
          {
            targets = [
              "https://www.crans.org/"
              "https://ens-paris-saclay.fr/"
              "https://blog.nanax.fr/"
            ];
          }
        ];
        metrics_path = "/probe";
        params.module = [ "http_2xx" ];
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            replacement = "127.0.0.1:9115";
            target_label = "__address__";
          }
        ];
      }
      {
        job_name = "matrix-appservice-irc";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [
              "matrix.rezosup.net"
            ];
          }
        ];
        scheme = "https";
      }
    ];
    ruleFiles = [
      (pkgs.writeText "prometheus-rules.yml" (builtins.toJSON {
        groups = [{
          name = "alerting-rules";
          rules = import ./prometheus-alert-rules.nix;
        }];
      }))
    ];
  };

  services.nginx = {
    enable = true;
    statusPage = true;
  };

  systemd.services.prometheus.serviceConfig = {
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
}

