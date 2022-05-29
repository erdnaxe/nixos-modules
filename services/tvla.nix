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
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options deny;
        add_header X-XSS-Protection "1; mode=block";
      '';
    };
  };
}
