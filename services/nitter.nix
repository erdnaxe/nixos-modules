let
  unstable = import <nixos-unstable> {};
in
{
  imports = [ <nixos-unstable/nixos/modules/services/misc/nitter.nix> ];
  nixpkgs.config.packageOverrides = pkgs: {
    nitter = unstable.nitter;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nitter = {
    enable = true;
    server = {
      address = "127.0.0.1";
      port = 3005;
      https = true;
      hostname = "nitter.nanax.fr";
      title = "Nitter Nanax";
    };
    preferences = {
      hlsPlayback = true;
      proxyVideos = false;
      replaceTwitter = "nitter.nanax.fr";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."nitter.nanax.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3005";
      };
    };
  };
}
