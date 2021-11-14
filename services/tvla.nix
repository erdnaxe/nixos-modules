{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    virtualHosts."tvla.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.fetchFromGitHub {
        owner = "erdnaxe";
        repo = "tvla";
        rev = "d06c54a164e9b14f5dcf7b0d58de89b70379c071";
        sha256 = "0gmm49bqrqqn0j8n3icl4jwax893p3d7zsn25azijp8q2p07z5nv";
      };
    };
  };
}
