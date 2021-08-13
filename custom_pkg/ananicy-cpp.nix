with import <nixpkgs> {};

stdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "0.7.1";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "v${version}";
    sha256 = "1ccqjhy8fdwrpyniw4a88yjh2cxa6fjycv40xg6fq8rlg31kmv6m";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ nlohmann_json fmt spdlog systemd ];

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DUSE_EXTERNAL_JSON=ON"
    "-DUSE_EXTERNAL_FMTLIB=ON"
    "-DUSE_EXTERNAL_SPDLOG=ON"
  ];

  meta = with lib; {
    description = "Another auto nice daemon rewritten in C++";
    homepage = "https://gitlab.com/ananicy-cpp/ananicy-cpp";
    maintainers = with maintainers; [ ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}

