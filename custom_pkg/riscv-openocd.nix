with import <nixpkgs> {};

stdenv.mkDerivation rec {
  pname = "riscv-openocd";
  version = "2019-12-06-unstable";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-openocd";
    rev = "aec5cca15b41d778fb85e95b38a9a552438fec6a";
    sha256 = "1msz895w3xwv9r20hi3qhpb5xcprfyjx0y24gv9icm003y5dchjm";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ hidapi libftdi1 libusb1 jimtcl ];

  configureFlags = [
    "--enable-ftdi"
    "--disable-internal-jimtcl"
  ];

  # TODO: be more specific
  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
    #"-Wno-error=cpp"
    #"-Wno-error=strict-prototypes" # fixes build failure with hidapi 0.10.0
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = with lib; {
    homepage = "https://github.com/riscv/riscv-openocd";
    description = "Fork of OpenOCD that has RISC-V support";
    platforms = platforms.unix;
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ erdnaxe ];
  };
}

