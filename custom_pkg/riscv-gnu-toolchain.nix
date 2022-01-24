with import <nixpkgs> {};

stdenv.mkDerivation {
  pname = "riscv-gnu-toolchain";
  version = "2021.12.22-nightly";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-gnu-toolchain";
    rev = "2021.12.22";
    sha256 = "0j2xl1r85hl8xnlmswch2qhjml4znrx01p86jyiw7ah1wgbkgvf9";
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [ curl file texinfo bison flex ];
  buildInputs = [ mpfr libmpc gmp zlib expat ];
  hardeningDisable = [ "format" ];

  configureFlags = [
    "--disable-linux"
    "--with-cmodel=medany"
    "--with-arch=rv32ima"
  ];
  buildFlags = [ "newlib" ];

  # Make will try to init submodules if .git is not present
  preBuildPhases = ["preBuildPhase"];
  preBuildPhase = ''
    touch riscv-binutils/.git riscv-gcc/.git riscv-glibc/.git riscv-dejagnu/.git riscv-newlib/.git riscv-gdb/.git qemu/.git
  '';

  meta = with lib; {
    homepage = "https://github.com/riscv-collab/riscv-gnu-toolchain";
    description = "GNU toolchain for RISC-V, including GCC";
    platforms = platforms.unix;
    license = with licenses; [ mit gpl2Only lgpl2Only ];
    maintainers = with maintainers; [ erdnaxe ];
  };
}
