with import <nixpkgs> { };

stdenv.mkDerivation rec {
  pname = "openlase";
  version = "unstable-2020-09-01";

  src = fetchFromGitHub {
    owner = "marcan";
    repo = "openlase";
    rev = "e6c80165479a1fa85774673257e938f4066c939e";
    sha256 = "1p5jsn609y5aczs226hcgwy89i992zrpwiagdxv73s0fpnmcdl09";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake python3 yasm python3Packages.cython libsForQt5.qt5.wrapQtAppsHook ];
  buildInputs = [ jack2 ffmpeg alsaLib freeglut ncurses libsForQt5.qt5.qtbase libGLU ];

  postInstall = ''
    mkdir -p $out/bin
    cp output/output $out/bin/
    cp tools/cal $out/bin/
    cp tools/invert $out/bin/
    cp tools/playilda $out/bin/
    cp tools/simulator $out/bin/
    cp tools/qplayvid/qplayvid $out/bin/
    cp examples/circlescope $out/bin/
    cp examples/harp $out/bin/
    cp examples/multihead $out/bin/
    cp examples/scope $out/bin/
    cp examples/midiview $out/bin/
    cp examples/pong $out/bin/
    cp examples/simple $out/bin/
  '';

  meta = with lib; {
    description = "Open source realtime laser graphics framework";
    homepage = "https://gitlab.com/marcan/openlase";
    maintainers = with maintainers; [ ];
    license = with licenses; [ gpl2Only gpl3Only ];
    platforms = [ "x86_64-linux" ];
  };
}

