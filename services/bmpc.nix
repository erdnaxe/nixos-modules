{ pkgs, ... }:

let
  bmpc = pkgs.fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "ff30d45bd5bc2b35cc307c1bbe9f7e976a92c7cc";
    sha256 = "sha256-FiLKDb/Oel7U3h7TbMte4HjmKiArfT6qAw0CArT+fwU=";
  };
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."bmpc.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      root = "${bmpc}/static";
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
        add_header X-XSS-Protection "1; mode=block";
      '';
    };
  };
}
