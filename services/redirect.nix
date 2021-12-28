{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.virtualHosts = {
    "ens-ps.fr" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [ "www.ens-ps.fr" ];
      locations."/".return = "302 https://services.crans.org$request_uri";
    };
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
