{
  # To remove in NixOS 22.05
  imports = [ <nixos-unstable/nixos/modules/services/misc/heisenbridge.nix> ];

  services.heisenbridge = {
    enable = true;
    homeserver = "http://127.0.0.1:8008";
  };
}
