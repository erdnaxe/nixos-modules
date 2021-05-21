# Machine specific configuration

{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/dell/g3/3779>
    ];

  networking.hostName = "ventus";
}
