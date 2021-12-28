with import <nixpkgs> {};

stdenv.mkDerivation {
  pname = "fabric-server";
  version = "1.18.1";

  src = fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/1.18.1/0.12.12/0.10.2/server/jar";
    sha256 = "0z9sa444l77sxxxnqp9qskcjkp3wcsgnk4n60hnvp2jxsbk3s1mg";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib/minecraft
    cp -v $src $out/lib/minecraft/server.jar
    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
    EOF
    chmod +x $out/bin/minecraft-server
  '';

  dontUnpack = true;
}
