{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.gitea = {
    enable = true;
    appName = "Git iooss.fr";
    cookieSecure = true;
    disableRegistration = true;
    domain = "git.iooss.fr";
    rootUrl = "https://git.iooss.fr/";
    # default to user gitea, database gitea
    database.type = "postgres";
    settings = { other = { SHOW_FOOTER_VERSION = false; }; };
  };

  services.postgresql = {
    enable = true;
    # Map the gitea user to postgresql
    # This might already be done by default
    identMap = ''
      gitea-users gitea gitea
    '';
  };

  services.nginx = {
    enable = true;
    virtualHosts."git.iooss.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = { proxyPass = "http://[::1]:3000"; };
    };
  };
}
