{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users.root.hashedPassword = "*";
    users.erdnaxe = {
      uid = 1000;
      passwordFile = "/etc/nixos/erdnaxe_password.secret";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "dialout" ];
    };
  };
}
