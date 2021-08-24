{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.virtualHosts."chat.iooss.fr" = {
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
        integrations_widgets_urls = [];
        bug_report_endpoint_url = "";
        showLabsSettings = true;
        jitsi.preferredDomain = "jitsi.crans.org";
      };
    };
  };
}
