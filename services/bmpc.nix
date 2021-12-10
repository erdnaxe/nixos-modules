{ pkgs, ... }:

let
  bmpc = pkgs.fetchFromGitHub {
    owner = "erdnaxe";
    repo = "bmpc";
    rev = "647cfd17fc37789c179358291f291a45a02df40c";
    sha256 = "12i26qkpf908mszvpn1wcsbnfjfw75gaghqqf3z7fgvpdnam57da";
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
