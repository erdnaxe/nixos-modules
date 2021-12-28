{
  nixpkgs.config.allowUnfree = true;
  services.minecraft-server = {
    enable = true;
    package = import ../custom_pkg/fabric-server.nix;
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      gamemode = 1;
      motd = "Fabric Creative server";
    };
  };
}
