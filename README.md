# Configuration NixOS

For hardware configuration, you need to use nixos-hardware repository,

```bash
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
```

For home manager, you need to use home-manager repository,

```bash
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
sudo nix-channel --update
```
