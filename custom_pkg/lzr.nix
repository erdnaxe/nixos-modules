with import <nixpkgs> { };

buildBazelPackage rec {
  pname = "lzr";
  version = "unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "brendan-w";
    repo = pname;
    rev = "e19b5b3b82bb0eab9e80e081b650413a476f9cde";
    sha256 = "1vxcya1x0iwlpn28vg1bcbg4ffq9jyjsm4fb9r1qc3v67mkhjcp4";
  };

  #strictDeps = true;
  nativeBuildInputs = [ git ];
  bazelTarget = [ "//..." ];
  bazelFlags = [ "--override_repository=com_google_absl=${abseil-cpp.src}" ];

  patchPhase = ''
    sed -i 's=/usr/include/SDL2=${SDL2.dev}/include/SDL2=g' WORKSPACE
  '';

  fetchAttrs = {
    sha256 = "0dass65w5vf65w54i9nvxpdwlfz1p245m737ybvsmfdjpqxvj2zd";
  };

  buildAttrs = { };

  #installPhase = ''
  #  echo TESTTEST
  #  ls -la $bazelOut
  #  echo TEST
  #  ls -la
  #'';

  meta = with lib; {
    description = "Laser show projection software, and ILDA handling library";
    homepage = "https://gitlab.com/brendan-w/lzr";
    maintainers = with maintainers; [ ];
    license = with licenses; [ lgpl3Only ];
    platforms = [ "x86_64-linux" ];
  };
}

