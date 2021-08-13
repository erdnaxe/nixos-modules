{ lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  environment.variables = { EDITOR = "vim"; };

  # Remove ZFS, CIFS, XFS, REISERFS from supported filesystems
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "vfat" "f2fs" "ntfs" ];
}
