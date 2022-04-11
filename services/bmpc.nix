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
    };
  };
}
