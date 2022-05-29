{ pkgs, ... }:

let
  bmpc = pkgs.fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "c89af7577710f2270542106cf697220e7cf64d85";
    sha256 = "sha256-lurgYZnv9f8/k+m70T0RHAiCzHBMoYRM2Ab6vlYQTkA=";
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
