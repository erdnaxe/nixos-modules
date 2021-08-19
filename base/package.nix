{ lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  environment.variables = { EDITOR = "vim"; };

  # Remove ZFS, CIFS, XFS, REISERFS, BTRFS from supported filesystems
  boot.supportedFilesystems = lib.mkForce [ "vfat" "f2fs" "ntfs" ];
}
