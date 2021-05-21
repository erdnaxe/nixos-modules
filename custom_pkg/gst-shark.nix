with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  pname = "gst-shark";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "RidgeRun";
    repo = "gst-shark";
    rev = "v${version}";
    sha256 = "0mcz98jqnsqw6x3rhphhi2ipaynca0awipwgi1hbf5xbm5qrlwv7";
  };

  prePatch = ''
    git clone https://github.com/GStreamer/common
  '';

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ gst_all_1.gstreamer ];

  meta = with lib; {
    description = "Open-source benchmarking and profiling tool for GStreamer";
    homepage = "https://developer.ridgerun.com/wiki/index.php?title=GstShark";
    maintainers = with maintainers; [ ];  # TODO
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}

