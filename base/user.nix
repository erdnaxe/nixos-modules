{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users.root.hashedPassword = "*";
    users.erdnaxe = {
      uid = 1000;
      passwordFile = "/etc/nixos/erdnaxe_password.secret";
      isNormalUser = true;
      home = "/home/erdnaxe";
      description = "Alexandre";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "dialout" ];
    };
  };
}
