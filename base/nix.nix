{ pkgs, ... }:

{
  # Disk space saver
  nix.autoOptimiseStore = true;

  # Restrict nix deamon to wheel group
  nix.allowedUsers = [ "@wheel" ];

  # Use more recent Nix
  nix.package = pkgs.nix_2_4;
}
