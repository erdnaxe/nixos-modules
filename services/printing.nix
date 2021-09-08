{ pkgs, ... }:

{
  users.users.erdnaxe.extraGroups = [ "scanner" "lp" ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint gutenprintBin hplip ];
  };
  services.system-config-printer.enable = true;

  # Scanner
  # Disabled because of incompatibility with cups
  #hardware.sane.enable = true;
}
