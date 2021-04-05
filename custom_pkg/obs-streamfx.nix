with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  pname = "obs-streamfx";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Xaymar";
    repo = "obs-StreamFX";
    rev = version;
    sha256 = "1nkw8as6b45bcs2n7d2l81b7fh32ngyw7xzcyrgwxajr7nijb8z8";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ffmpeg qt5.qtbase obs-studio ];

  cmakeFlags = with lib; [
    "-DOBS_STUDIO_DIR=${obs-studio}/lib"
    "-DENABLE_UPDATER=FALSE"
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "StreamFX is a plugin for OBS Studio which adds many new effects, filters, sources, transitions and encoders";
    homepage = "https://github.com/Xaymar/obs-StreamFX";
    maintainers = with maintainers; [ ];  # TODO
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

