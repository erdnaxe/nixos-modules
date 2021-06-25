# Base module that should be imported on all machines.
# `default.nix` is loaded when importing this folder.
{
  imports = [
    ./home-manager.nix
    ./letsencrypt.nix
    ./locale.nix
    ./nix.nix
    ./package.nix
    ./zsh.nix
  ];
}
