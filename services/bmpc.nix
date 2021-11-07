{ pkgs, ... }:

let
  bmpc = pkgs.fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "eb997d5dae1c8e498217aa460971526e60f59560";
    sha256 = "1ligiy0ldmj3zhcl3gpjm4s6qjxh8bga89h8fiy14pr3xz6xdf44";
  };
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."bmpc.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      root = "${bmpc}/static";
    };
  };
}
