{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nitter = {
    enable = true;
    server = {
      address = "127.0.0.1";
      port = 3005;
      https = true;
      hostname = "nitter.nanax.fr";
      title = "Nitter Nanax";
    };
    preferences = {
      hlsPlayback = true;
      proxyVideos = false;
      replaceTwitter = "nitter.nanax.fr";
    };
    cache = {
      rssMinutes = 120;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."nitter.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = { proxyPass = "http://127.0.0.1:3005"; };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
        add_header X-XSS-Protection "1; mode=block";
      '';
    };
  };
}
