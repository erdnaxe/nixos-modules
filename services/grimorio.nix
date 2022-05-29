{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."grimorio.org" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/grimorio/";
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
      '';
    };
  };
}
