# Configuration NixOS

```bash
git clone https://gitlab.crans.org/erdnaxe/nixos.git /etc/nixos/modules
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
sudo nix-channel --update
```
