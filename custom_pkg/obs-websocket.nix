with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  pname = "obs-websocket";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-websocket";
    rev = version;
    sha256 = "184w54v9wqp4ihmm2vq4xm799wipiaisi62s19whwlzdzskw6802";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ asio_1_10 websocketpp qt514.qtbase obs-studio ];

  cmakeFlags = with lib; [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-Wno-dev"
  ];

  # obs-studio expects the shared object to be located in bin/32bit or bin/64bit
  # https://github.com/obsproject/obs-studio/blob/d60c736cb0ec0491013293c8a483d3a6573165cb/libobs/obs-nix.c#L48
  postInstall = let
    pluginPath = {
      i686-linux = "bin/32bit";
      x86_64-linux = "bin/64bit";
    }.${stdenv.targetPlatform.system} or (throw "Unsupported system: ${stdenv.targetPlatform.system}");
  in ''
    mkdir -p $out/share/obs/obs-plugins/obs-websocket/${pluginPath}
    ln -s $out/lib/obs-plugins/obs-websocket.so $out/share/obs/obs-plugins/obs-websocket/${pluginPath}
  '';

  meta = with lib; {
    description = "Remote-control OBS Studio through WebSockets";
    homepage = "https://github.com/Palakis/obs-websocket";
    maintainers = with maintainers; [ ];  # TODO
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

