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
      locations."/" = { proxyPass = "http://127.0.0.1:3001"; };
    };
  };
}
