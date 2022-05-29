{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."chat.iooss.fr" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.element-web.override {
        conf = {
          default_server_config = {
            "m.homeserver" = {
              "base_url" = "https://iooss.fr";
              "server_name" = "iooss.fr";
            };
            "m.identity_server".base_url = "";
          };
          disable_3pid_login = true;
          integrations_ui_url = "";
          integrations_rest_url = "";
          integrations_widgets_urls = [ ];
          bug_report_endpoint_url = "";
          showLabsSettings = true;
          jitsi.preferredDomain = "jitsi.crans.org";
        };
      };
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
        add_header X-XSS-Protection "1; mode=block";
      '';
    };
  };
}
