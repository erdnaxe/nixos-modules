{ pkgs, ... }:

{
  # Disk space saver
  nix.autoOptimiseStore = true;

  # Restrict nix deamon to wheel group
  nix.allowedUsers = [ "@wheel" ];
}
