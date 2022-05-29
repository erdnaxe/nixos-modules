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
    virtualHosts."radicale.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = { proxyPass = "http://localhost:5232"; };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
        add_header X-XSS-Protection "1; mode=block";
      '';
    };
  };
}
