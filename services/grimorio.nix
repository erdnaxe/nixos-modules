{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."grimorio.org" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/grimorio/";
    };
  };
}
