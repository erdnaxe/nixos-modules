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
      SECURITY_STRICT_TRANSPORT_SECURITY = "true";
      SECURITY_STRICT_TRANSPORT_SECURITY_MAX_AGE_SECONDS = "31536000";
      SECURITY_STRICT_TRANSPORT_SECURITY_PRELOAD = "true";
      SECURITY_STRICT_TRANSPORT_SECURITY_SUBDOMAINS = "true";
      SECURITY_CONTENT_SECURITY_POLICY = "true";
    };
  };

  # Allow only localhost network access
  systemd.services.grafana.serviceConfig = {
    IPAddressAllow = "localhost";
    IPAddressDeny = "any";
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
