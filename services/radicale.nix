{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.radicale = {
    enable = true;
    settings.auth = {
      type = "htpasswd";
      htpasswd_filename = "/var/lib/radicale/htpasswd";
      htpasswd_encryption = "md5";
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."radicale.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:5232";
      };
    };
  };
}
