{
  # Allow non-free software such as VSCode
  nixpkgs.config.allowUnfree = true;

  # Disk space saver
  nix.autoOptimiseStore = true;

  # Restrict nix deamon to wheel group
  nix.allowedUsers = [ "@wheel" ];
}
