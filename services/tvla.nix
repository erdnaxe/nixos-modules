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
        rev = "cfa18c1e0abe6d2127d1d9b54f4eaf0dd795d72e";
        sha256 = "sha256-L+0MtPQMdI7jm43jnXeJKGcW8PyDvJmi4NHgcRRB+mg=";
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
