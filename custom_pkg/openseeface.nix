with import <nixpkgs> {};
with pkgs.python3Packages;

# https://github.com/emilianavt/OpenSeeFace
# openseeface -c /dev/video2 -W 1920 -H 1080 --discard-after 0 --scan-every 0 --no-3d-adapt 1 --max-feature-updates 900 > /dev/null

let
  onnxruntimeWheel = fetchurl {
    url = "https://files.pythonhosted.org/packages/07/87/33906d5959565093bb23e7c6d4623f1caf2cb43d43745e6ab0293a8ccce2/onnxruntime-1.6.0-cp38-cp38-manylinux2014_x86_64.whl";
    sha256 = "1j0cscrca5f4n9ppqyp7q9zmr50zrhq3bngb0l0v45vmgzv3313d";
  };
  openSeeFaceSrc = fetchFromGitHub {
    owner = "emilianavt";
    repo = "OpenSeeFace";
    rev = "971f81b0308559900c05bfe8681e903c35af52da";
    sha256 = "1vlyl2xr516mw8ysvwfmkzdbnl6qf2nr28qlhm7l29kvlnvmcch5";
  };
in stdenv.mkDerivation rec {
  name = "openseeface";
  src = openSeeFaceSrc;
  configurePhase = ''
    mkdir py-prefix
  '';
  buildPhase = ''
    cp ${onnxruntimeWheel} ./onnxruntime-1.6.0-cp38-cp38-manylinux2014_x86_64.whl
    pip install ./onnxruntime-1.6.0-cp38-cp38-manylinux2014_x86_64.whl --prefix=./py-prefix --no-deps
  '';
  installPhase = ''
    mkdir $out
    cp -R ./* $out
    makeWrapper ${python38}/bin/python $out/bin/${name} \
      --add-flags $out/facetracker.py \
      --set PYTHONPATH $out/py-prefix/lib/python3.8/site-packages:$PYTHONPATH
  '';
  propagatedBuildInputs = [
    makeWrapper
    onnxruntime
    python38
    python3Packages.pip
    python3Packages.opencv4
    python3Packages.pillow
    python3Packages.numpy
    python3Packages.protobuf
  ];
}

