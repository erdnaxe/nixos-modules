{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.virtualHosts = {
    "nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/".return = "302 https://blog.nanax.fr$request_uri";
    };
    "rss.iooss.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/".return = "302 https://rss.nanax.fr$request_uri";
    };
  };
}
